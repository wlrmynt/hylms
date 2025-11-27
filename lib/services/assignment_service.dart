import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/assignment.dart';
import '../models/course.dart';

class AssignmentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  static CollectionReference get assignmentsCollection => 
      _firestore.collection('assignments');
  static CollectionReference get submissionsCollection => 
      _firestore.collection('assignments_submissions');
  
  // Create a new assignment
  static Future<String> createAssignment(Assignment assignment) async {
    try {
      DocumentReference doc = await assignmentsCollection.add(assignment.toJson());
      return doc.id;
    } catch (e) {
      print('Error creating assignment: $e');
      throw 'Failed to create assignment';
    }
  }
  
  // Get assignments by course
  static Future<List<Assignment>> getAssignmentsByCourse(String courseId) async {
    try {
      QuerySnapshot snapshot = await assignmentsCollection
          .where('courseId', isEqualTo: courseId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Assignment.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting assignments by course: $e');
      return [];
    }
  }
  
  // Get assignment by ID
  static Future<Assignment?> getAssignmentById(String assignmentId) async {
    try {
      DocumentSnapshot doc = await assignmentsCollection.doc(assignmentId).get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Assignment.fromJson(data);
      }
    } catch (e) {
      print('Error getting assignment by ID: $e');
    }
    return null;
  }
  
  // Update assignment
  static Future<void> updateAssignment(String assignmentId, Assignment assignment) async {
    try {
      Map<String, dynamic> updatedData = assignment.toJson();
      updatedData['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await assignmentsCollection.doc(assignmentId).update(updatedData);
    } catch (e) {
      print('Error updating assignment: $e');
      throw 'Failed to update assignment';
    }
  }
  
  // Delete assignment
  static Future<void> deleteAssignment(String assignmentId) async {
    try {
      await assignmentsCollection.doc(assignmentId).delete();
    } catch (e) {
      print('Error deleting assignment: $e');
      throw 'Failed to delete assignment';
    }
  }
  
  // Submit assignment
  static Future<String> submitAssignment(AssignmentSubmission submission) async {
    try {
      DocumentReference doc = await submissionsCollection.add(submission.toJson());
      return doc.id;
    } catch (e) {
      print('Error submitting assignment: $e');
      throw 'Failed to submit assignment';
    }
  }
  
  // Get student submission for assignment
  static Future<AssignmentSubmission?> getStudentSubmission(
    String assignmentId, 
    String studentId,
  ) async {
    try {
      QuerySnapshot snapshot = await submissionsCollection
          .where('assignmentId', isEqualTo: assignmentId)
          .where('studentId', isEqualTo: studentId)
          .orderBy('submittedAt', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
        data['id'] = snapshot.docs.first.id;
        return AssignmentSubmission.fromJson(data);
      }
    } catch (e) {
      print('Error getting student submission: $e');
    }
    return null;
  }
  
  // Get all submissions for an assignment (for instructors)
  static Future<List<AssignmentSubmission>> getAssignmentSubmissions(String assignmentId) async {
    try {
      QuerySnapshot snapshot = await submissionsCollection
          .where('assignmentId', isEqualTo: assignmentId)
          .orderBy('submittedAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return AssignmentSubmission.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting assignment submissions: $e');
      return [];
    }
  }
  
  // Grade submission
  static Future<void> gradeSubmission(
    String submissionId, 
    int score, 
    String feedback,
  ) async {
    try {
      await submissionsCollection.doc(submissionId).update({
        'score': score,
        'instructorFeedback': feedback,
        'gradedAt': Timestamp.fromDate(DateTime.now()),
        'status': SubmissionStatus.graded.toString().split('.').last,
      });
    } catch (e) {
      print('Error grading submission: $e');
      throw 'Failed to grade submission';
    }
  }
  
  // Get student's submissions for a course
  static Future<List<AssignmentSubmission>> getStudentCourseSubmissions(
    String courseId, 
    String studentId,
  ) async {
    try {
      // First get assignments for the course
      List<Assignment> assignments = await getAssignmentsByCourse(courseId);
      List<String> assignmentIds = assignments.map((a) => a.id).toList();
      
      if (assignmentIds.isEmpty) return [];
      
      QuerySnapshot snapshot = await submissionsCollection
          .where('studentId', isEqualTo: studentId)
          .where('assignmentId', whereIn: assignmentIds)
          .orderBy('submittedAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return AssignmentSubmission.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting student course submissions: $e');
      return [];
    }
  }
  
  // Auto-grade quiz submissions
  static int autoGradeQuiz(Assignment assignment, List<String> studentAnswers) {
    int score = 0;
    
    for (int i = 0; i < assignment.questions.length && i < studentAnswers.length; i++) {
      Question question = assignment.questions[i];
      String studentAnswer = studentAnswers[i];
      
      // Simple auto-grading for multiple choice and true/false
      if (question.type == QuestionType.multipleChoice || 
          question.type == QuestionType.trueFalse) {
        if (studentAnswer.toLowerCase() == question.correctAnswer.toLowerCase()) {
          score += question.points;
        }
      }
      // For other question types, manual grading is required
    }
    
    return score;
  }
  
  // Stream assignments for a course (real-time updates)
  static Stream<List<Assignment>> streamAssignmentsByCourse(String courseId) {
    return assignmentsCollection
        .where('courseId', isEqualTo: courseId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Assignment.fromJson(data);
      }).toList();
    });
  }
  
  // Get upcoming assignments for a student
  static Future<List<Assignment>> getUpcomingAssignmentsForStudent(String studentId) async {
    try {
      // Get student's enrolled courses
      // For now, we'll get all assignments and filter by due date
      QuerySnapshot snapshot = await assignmentsCollection
          .where('dueDate', isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .where('isPublished', isEqualTo: true)
          .orderBy('dueDate')
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Assignment.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting upcoming assignments: $e');
      return [];
    }
  }
  
  // Seed sample assignments for development
  static Future<void> seedSampleAssignments(List<Course> courses) async {
    try {
      // Check if assignments already exist
      QuerySnapshot existing = await assignmentsCollection.limit(1).get();
      if (existing.docs.isNotEmpty) {
        return; // Already seeded
      }
      
      List<Assignment> sampleAssignments = [];
      
      for (Course course in courses.take(3)) { // Create assignments for first 3 courses
        // Quiz 1
        sampleAssignments.add(Assignment(
          id: '',
          title: 'Quiz 1: ${course.title} Fundamentals',
          description: 'Test your understanding of the basic concepts covered in this course.',
          courseId: course.id,
          instructorId: 'instructor_1',
          dueDate: DateTime.now().add(const Duration(days: 7)),
          maxPoints: 100,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          type: AssignmentType.quiz,
          questions: [
            Question(
              id: 'q1',
              text: 'What is the main purpose of ${course.title}?',
              type: QuestionType.multipleChoice,
              options: ['Option A', 'Option B', 'Option C', 'Option D'],
              correctAnswer: 'Option A',
              points: 25,
              explanation: 'The correct answer is Option A because...',
            ),
            Question(
              id: 'q2',
              text: 'True or False: ${course.title} is important for technology.',
              type: QuestionType.trueFalse,
              options: ['True', 'False'],
              correctAnswer: 'True',
              points: 25,
              explanation: 'This statement is true because...',
            ),
            Question(
              id: 'q3',
              text: 'Explain the key concepts of ${course.title}.',
              type: QuestionType.essay,
              options: [],
              correctAnswer: '',
              points: 50,
              explanation: 'Key concepts include...',
            ),
          ],
          isPublished: true,
          timeLimitMinutes: 30,
        ));
        
        // Homework assignment
        sampleAssignments.add(Assignment(
          id: '',
          title: 'Homework: Practical Application',
          description: 'Apply what you learned in this course to solve real-world problems.',
          courseId: course.id,
          instructorId: 'instructor_1',
          dueDate: DateTime.now().add(const Duration(days: 14)),
          maxPoints: 100,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          type: AssignmentType.homework,
          questions: [
            Question(
              id: 'q1',
              text: 'Describe a real-world scenario where ${course.title} concepts would be applicable.',
              type: QuestionType.essay,
              options: [],
              correctAnswer: '',
              points: 100,
              explanation: 'Look for practical understanding and application...',
            ),
          ],
          isPublished: true,
        ));
      }
      
      for (Assignment assignment in sampleAssignments) {
        await createAssignment(assignment);
      }
      
      print('Sample assignments seeded successfully');
    } catch (e) {
      print('Error seeding sample assignments: $e');
    }
  }
}