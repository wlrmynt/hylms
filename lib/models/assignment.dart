import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String instructorId;
  final DateTime dueDate;
  final int maxPoints;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AssignmentType type;
  final List<Question> questions;
  final bool isPublished;
  final int timeLimitMinutes; // For quizzes
  
  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.instructorId,
    required this.dueDate,
    required this.maxPoints,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.questions,
    this.isPublished = false,
    this.timeLimitMinutes = 0,
  });
  
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      courseId: json['courseId'] ?? '',
      instructorId: json['instructorId'] ?? '',
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      maxPoints: json['maxPoints'] ?? 100,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      type: AssignmentType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AssignmentType.homework,
      ),
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      isPublished: json['isPublished'] ?? false,
      timeLimitMinutes: json['timeLimitMinutes'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'instructorId': instructorId,
      'dueDate': Timestamp.fromDate(dueDate),
      'maxPoints': maxPoints,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'type': type.toString().split('.').last,
      'questions': questions.map((q) => q.toJson()).toList(),
      'isPublished': isPublished,
      'timeLimitMinutes': timeLimitMinutes,
    };
  }
}

enum AssignmentType {
  homework,
  quiz,
  exam,
  project,
  discussion,
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final String correctAnswer;
  final int points;
  final String? explanation;
  
  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.points,
    this.explanation,
  });
  
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      type: QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => QuestionType.multipleChoice,
      ),
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
      points: json['points'] ?? 10,
      explanation: json['explanation'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString().split('.').last,
      'options': options,
      'correctAnswer': correctAnswer,
      'points': points,
      'explanation': explanation,
    };
  }
}

enum QuestionType {
  multipleChoice,
  trueFalse,
  shortAnswer,
  essay,
}

class AssignmentSubmission {
  final String id;
  final String assignmentId;
  final String studentId;
  final List<String> answers;
  final int score;
  final int maxScore;
  final DateTime submittedAt;
  final DateTime? gradedAt;
  final String? instructorFeedback;
  final SubmissionStatus status;
  final int attemptNumber;
  
  AssignmentSubmission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.answers,
    required this.score,
    required this.maxScore,
    required this.submittedAt,
    this.gradedAt,
    this.instructorFeedback,
    required this.status,
    required this.attemptNumber,
  });
  
  factory AssignmentSubmission.fromJson(Map<String, dynamic> json) {
    return AssignmentSubmission(
      id: json['id'] ?? '',
      assignmentId: json['assignmentId'] ?? '',
      studentId: json['studentId'] ?? '',
      answers: List<String>.from(json['answers'] ?? []),
      score: json['score'] ?? 0,
      maxScore: json['maxScore'] ?? 100,
      submittedAt: (json['submittedAt'] as Timestamp).toDate(),
      gradedAt: json['gradedAt'] != null 
          ? (json['gradedAt'] as Timestamp).toDate()
          : null,
      instructorFeedback: json['instructorFeedback'],
      status: SubmissionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => SubmissionStatus.submitted,
      ),
      attemptNumber: json['attemptNumber'] ?? 1,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'answers': answers,
      'score': score,
      'maxScore': maxScore,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'gradedAt': gradedAt != null 
          ? Timestamp.fromDate(gradedAt!)
          : null,
      'instructorFeedback': instructorFeedback,
      'status': status.toString().split('.').last,
      'attemptNumber': attemptNumber,
    };
  }
}

enum SubmissionStatus {
  draft,
  submitted,
  graded,
  late,
  needsGrading,
}