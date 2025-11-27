import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/structured_class.dart';
import '../models/course.dart';
import 'notification_service.dart';

class ClassService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  static CollectionReference get classesCollection => 
      _firestore.collection('structured_classes');
  static CollectionReference get enrollmentsCollection => 
      _firestore.collection('class_enrollments');
  static CollectionReference get sessionsCollection => 
      _firestore.collection('class_sessions');
  
  // Create a new structured class
  static Future<String> createClass(StructuredClass structuredClass) async {
    try {
      DocumentReference doc = await classesCollection.add(structuredClass.toJson());
      return doc.id;
    } catch (e) {
      print('Error creating class: $e');
      throw 'Failed to create class';
    }
  }
  
  // Get all classes
  static Future<List<StructuredClass>> getAllClasses({
    ClassStatus? status,
    String? instructorId,
    int limit = 20,
  }) async {
    try {
      Query query = classesCollection.orderBy('createdAt', descending: true).limit(limit);
      
      if (status != null) {
        query = query.where('status', isEqualTo: status.toString().split('.').last);
      }
      
      if (instructorId != null) {
        query = query.where('instructorId', isEqualTo: instructorId);
      }
      
      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return StructuredClass.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting all classes: $e');
      return [];
    }
  }
  
  // Get class by ID
  static Future<StructuredClass?> getClassById(String classId) async {
    try {
      DocumentSnapshot doc = await classesCollection.doc(classId).get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return StructuredClass.fromJson(data);
      }
    } catch (e) {
      print('Error getting class by ID: $e');
    }
    return null;
  }
  
  // Update class
  static Future<void> updateClass(String classId, StructuredClass structuredClass) async {
    try {
      Map<String, dynamic> updatedData = structuredClass.toJson();
      updatedData['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await classesCollection.doc(classId).update(updatedData);
    } catch (e) {
      print('Error updating class: $e');
      throw 'Failed to update class';
    }
  }
  
  // Enroll student in class
  static Future<String> enrollStudent(String classId, String studentId, String studentName) async {
    try {
      // Check if class exists and has available spots
      StructuredClass? classInfo = await getClassById(classId);
      if (classInfo == null) {
        throw 'Class not found';
      }
      
      if (!classInfo.isEnrollmentOpen) {
        throw 'Enrollment is not open for this class';
      }
      
      if (classInfo.currentEnrollment >= classInfo.maxStudents) {
        throw 'Class is full';
      }
      
      // Check if student is already enrolled
      QuerySnapshot existingEnrollment = await enrollmentsCollection
          .where('classId', isEqualTo: classId)
          .where('studentId', isEqualTo: studentId)
          .where('status', isEqualTo: EnrollmentStatus.enrolled.toString().split('.').last)
          .get();
      
      if (existingEnrollment.docs.isNotEmpty) {
        throw 'Student is already enrolled in this class';
      }
      
      // Create enrollment record
      ClassEnrollment enrollment = ClassEnrollment(
        id: '',
        classId: classId,
        studentId: studentId,
        studentName: studentName,
        status: EnrollmentStatus.enrolled,
        enrolledAt: DateTime.now(),
        finalGrade: 0.0,
        certificateIssued: false,
        attendance: {},
        completedAssignments: [],
        metadata: {},
      );
      
      DocumentReference doc = await enrollmentsCollection.add(enrollment.toJson());
      
      // Update class enrollment count
      await classesCollection.doc(classId).update({
        'currentEnrollment': FieldValue.increment(1),
        'enrolledStudents': FieldValue.arrayUnion([studentId]),
      });
      
      // Send enrollment confirmation notification
      await NotificationService.sendTemplatedNotification(
        userId: studentId,
        templateId: 'class_enrollment',
        data: {
          'classTitle': classInfo.title,
          'instructorName': classInfo.instructorName,
          'startDate': classInfo.startDate.toIso8601String(),
        },
      );
      
      return doc.id;
    } catch (e) {
      print('Error enrolling student: $e');
      throw 'Failed to enroll student: $e';
    }
  }
  
  // Drop student from class
  static Future<void> dropStudent(String classId, String studentId) async {
    try {
      QuerySnapshot enrollmentSnapshot = await enrollmentsCollection
          .where('classId', isEqualTo: classId)
          .where('studentId', isEqualTo: studentId)
          .where('status', isEqualTo: EnrollmentStatus.enrolled.toString().split('.').last)
          .get();
      
      if (enrollmentSnapshot.docs.isEmpty) {
        throw 'Enrollment not found';
      }
      
      // Update enrollment status
      await enrollmentSnapshot.docs.first.reference.update({
        'status': EnrollmentStatus.dropped.toString().split('.').last,
      });
      
      // Update class enrollment count
      await classesCollection.doc(classId).update({
        'currentEnrollment': FieldValue.increment(-1),
        'enrolledStudents': FieldValue.arrayRemove([studentId]),
      });
    } catch (e) {
      print('Error dropping student: $e');
      throw 'Failed to drop student: $e';
    }
  }
  
  // Get class enrollments
  static Future<List<ClassEnrollment>> getClassEnrollments(String classId) async {
    try {
      QuerySnapshot snapshot = await enrollmentsCollection
          .where('classId', isEqualTo: classId)
          .where('status', isEqualTo: EnrollmentStatus.enrolled.toString().split('.').last)
          .orderBy('enrolledAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ClassEnrollment.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting class enrollments: $e');
      return [];
    }
  }
  
  // Get student enrollments
  static Future<List<ClassEnrollment>> getStudentEnrollments(String studentId) async {
    try {
      QuerySnapshot snapshot = await enrollmentsCollection
          .where('studentId', isEqualTo: studentId)
          .where('status', isEqualTo: EnrollmentStatus.enrolled.toString().split('.').last)
          .orderBy('enrolledAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ClassEnrollment.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting student enrollments: $e');
      return [];
    }
  }
  
  // Create class session
  static Future<String> createClassSession(ClassSession session) async {
    try {
      DocumentReference doc = await sessionsCollection.add(session.toJson());
      return doc.id;
    } catch (e) {
      print('Error creating class session: $e');
      throw 'Failed to create class session';
    }
  }
  
  // Get class sessions
  static Future<List<ClassSession>> getClassSessions(String classId) async {
    try {
      QuerySnapshot snapshot = await sessionsCollection
          .where('classId', isEqualTo: classId)
          .orderBy('scheduledTime')
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ClassSession.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting class sessions: $e');
      return [];
    }
  }
  
  // Mark attendance for session
  static Future<void> markAttendance(
    String sessionId, 
    String studentId, 
    bool isPresent,
  ) async {
    try {
      await sessionsCollection.doc(sessionId).update({
        'studentAttendance.$studentId': isPresent,
        'attendanceCount': isPresent ? FieldValue.increment(1) : FieldValue.increment(0),
      });
    } catch (e) {
      print('Error marking attendance: $e');
      throw 'Failed to mark attendance';
    }
  }
  
  // Get instructor's classes
  static Future<List<StructuredClass>> getInstructorClasses(String instructorId) async {
    try {
      QuerySnapshot snapshot = await classesCollection
          .where('instructorId', isEqualTo: instructorId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return StructuredClass.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting instructor classes: $e');
      return [];
    }
  }
  
  // Search classes
  static Future<List<StructuredClass>> searchClasses({
    required String query,
    ClassType? type,
    ClassStatus? status,
    int limit = 20,
  }) async {
    try {
      Query searchQuery = classesCollection;
      
      if (status != null) {
        searchQuery = searchQuery.where('status', isEqualTo: status.toString().split('.').last);
      }
      
      if (type != null) {
        searchQuery = searchQuery.where('type', isEqualTo: type.toString().split('.').last);
      }
      
      // Simple text search (in production, you might use Algolia)
      searchQuery = searchQuery
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + '\uf8ff')
          .orderBy('createdAt', descending: true)
          .limit(limit);
      
      QuerySnapshot snapshot = await searchQuery.get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return StructuredClass.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error searching classes: $e');
      return [];
    }
  }
  
  // Get class statistics for instructor
  static Future<Map<String, dynamic>> getClassStatistics(String instructorId) async {
    try {
      QuerySnapshot snapshot = await classesCollection
          .where('instructorId', isEqualTo: instructorId)
          .get();
      
      List<StructuredClass> classes = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return StructuredClass.fromJson(data);
      }).toList();
      
      int totalClasses = classes.length;
      int activeClasses = classes.where((c) => c.isActive).length;
      int enrollmentOpenClasses = classes.where((c) => c.isEnrollmentOpen).length;
      int totalStudents = classes.fold(0, (sum, c) => sum + c.currentEnrollment);
      double averageEnrollment = totalClasses > 0 ? totalStudents / totalClasses : 0.0;
      
      Map<String, int> classesByType = {};
      Map<String, int> classesByStatus = {};
      
      for (StructuredClass classInfo in classes) {
        classesByType[classInfo.type.toString().split('.').last] = 
            (classesByType[classInfo.type.toString().split('.').last] ?? 0) + 1;
        classesByStatus[classInfo.status.toString().split('.').last] = 
            (classesByStatus[classInfo.status.toString().split('.').last] ?? 0) + 1;
      }
      
      return {
        'totalClasses': totalClasses,
        'activeClasses': activeClasses,
        'enrollmentOpenClasses': enrollmentOpenClasses,
        'totalStudents': totalStudents,
        'averageEnrollment': averageEnrollment,
        'classesByType': classesByType,
        'classesByStatus': classesByStatus,
        'classes': classes,
      };
    } catch (e) {
      print('Error getting class statistics: $e');
      return {};
    }
  }
  
  // Stream classes for real-time updates
  static Stream<List<StructuredClass>> streamClasses({ClassStatus? status}) {
    Query query = classesCollection.orderBy('createdAt', descending: true).limit(20);
    
    if (status != null) {
      query = query.where('status', isEqualTo: status.toString().split('.').last);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return StructuredClass.fromJson(data);
      }).toList();
    });
  }
  
  // Seed sample class data
  static Future<void> seedSampleClassData(List<Course> courses) async {
    try {
      // Check if classes already exist
      QuerySnapshot existing = await classesCollection.limit(1).get();
      if (existing.docs.isNotEmpty) {
        return; // Already seeded
      }
      
      List<StructuredClass> sampleClasses = [];
      
      for (Course course in courses.take(3)) {
        sampleClasses.add(StructuredClass(
          id: '',
          title: '${course.title} - Kelas A',
          description: 'Kelas terstruktur untuk ${course.title} dengan pembimbing langsung.',
          instructorId: 'instructor_1',
          instructorName: 'Dr. John Doe',
          courseId: course.id,
          courseTitle: course.title,
          status: ClassStatus.enrollmentOpen,
          startDate: DateTime.now().add(const Duration(days: 7)),
          endDate: DateTime.now().add(const Duration(days: 90)),
          maxStudents: 25,
          currentEnrollment: 0,
          enrolledStudents: [],
          classSchedule: ['Senin 09:00-11:00', 'Rabu 09:00-11:00'],
          classMaterials: [],
          classroom: 'Ruang 101, Gedung A',
          type: ClassType.regular,
          credits: 3,
          price: 500000.0,
          syllabusUrl: 'https://example.com/syllabus.pdf',
          coverImageUrl: course.imageUrl,
          metadata: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
        
        sampleClasses.add(StructuredClass(
          id: '',
          title: '${course.title} - Kelas Online',
          description: 'Kelas online untuk ${course.title} dengan fleksibilitas waktu belajar.',
          instructorId: 'instructor_2',
          instructorName: 'Prof. Jane Smith',
          courseId: course.id,
          courseTitle: course.title,
          status: ClassStatus.active,
          startDate: DateTime.now().subtract(const Duration(days: 14)),
          endDate: DateTime.now().add(const Duration(days: 60)),
          maxStudents: 50,
          currentEnrollment: 32,
          enrolledStudents: ['student_1', 'student_2', 'student_3'],
          classSchedule: ['Sabtu 14:00-16:00'],
          classMaterials: [],
          classroom: 'Online - Zoom',
          type: ClassType.online,
          credits: 3,
          price: 300000.0,
          syllabusUrl: 'https://example.com/online-syllabus.pdf',
          coverImageUrl: course.imageUrl,
          metadata: {},
          createdAt: DateTime.now().subtract(const Duration(days: 21)),
          updatedAt: DateTime.now().subtract(const Duration(days: 14)),
        ));
      }
      
      // Create classes
      for (StructuredClass classInfo in sampleClasses) {
        String classId = await createClass(classInfo);
        
        // Create sample sessions for active classes
        if (classInfo.status == ClassStatus.active) {
          List<ClassSession> sampleSessions = [
            ClassSession(
              id: '',
              classId: classId,
              title: 'Sesi 1: Pengenalan Konsep Dasar',
              description: 'Pembahasan konsep dasar dan overview materi',
              scheduledTime: classInfo.startDate.add(const Duration(days: 7)),
              duration: 120,
              location: classInfo.classroom,
              type: SessionType.lecture,
              materials: ['slide1.pdf', 'materi1.pdf'],
              attendanceCount: 0,
              studentAttendance: {},
              instructorNotes: '',
              createdAt: DateTime.now(),
            ),
            ClassSession(
              id: '',
              classId: classId,
              title: 'Sesi 2: Praktikum dan Latihan',
              description: 'Hands-on practice dan diskusi kasus',
              scheduledTime: classInfo.startDate.add(const Duration(days: 14)),
              duration: 120,
              location: classInfo.classroom,
              type: SessionType.lab,
              materials: ['exercise1.pdf'],
              attendanceCount: 0,
              studentAttendance: {},
              instructorNotes: '',
              createdAt: DateTime.now(),
            ),
          ];
          
          for (ClassSession session in sampleSessions) {
            await createClassSession(session);
          }
        }
      }
      
      print('Sample class data seeded successfully');
    } catch (e) {
      print('Error seeding sample class data: $e');
    }
  }
}