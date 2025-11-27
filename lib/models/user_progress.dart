import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgress {
  final String id;
  final String userId;
  final String courseId;
  final double completionPercentage;
  final int totalLessonsCompleted;
  final int totalLessons;
  final int totalAssignmentsCompleted;
  final int totalAssignments;
  final double averageScore;
  final DateTime lastAccessed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<LessonProgress> lessonProgress;
  final List<AssignmentProgress> assignmentProgress;
  final TimeSpent timeSpent;
  final AchievementStatus status;
  
  UserProgress({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.completionPercentage,
    required this.totalLessonsCompleted,
    required this.totalLessons,
    required this.totalAssignmentsCompleted,
    required this.totalAssignments,
    required this.averageScore,
    required this.lastAccessed,
    required this.createdAt,
    required this.updatedAt,
    required this.lessonProgress,
    required this.assignmentProgress,
    required this.timeSpent,
    required this.status,
  });
  
  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      courseId: json['courseId'] ?? '',
      completionPercentage: (json['completionPercentage'] ?? 0.0).toDouble(),
      totalLessonsCompleted: json['totalLessonsCompleted'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      totalAssignmentsCompleted: json['totalAssignmentsCompleted'] ?? 0,
      totalAssignments: json['totalAssignments'] ?? 0,
      averageScore: (json['averageScore'] ?? 0.0).toDouble(),
      lastAccessed: (json['lastAccessed'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      lessonProgress: (json['lessonProgress'] as List<dynamic>? ?? [])
          .map((lp) => LessonProgress.fromJson(lp as Map<String, dynamic>))
          .toList(),
      assignmentProgress: (json['assignmentProgress'] as List<dynamic>? ?? [])
          .map((ap) => AssignmentProgress.fromJson(ap as Map<String, dynamic>))
          .toList(),
      timeSpent: TimeSpent.fromJson(json['timeSpent'] as Map<String, dynamic>),
      status: AchievementStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AchievementStatus.inProgress,
      ),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'completionPercentage': completionPercentage,
      'totalLessonsCompleted': totalLessonsCompleted,
      'totalLessons': totalLessons,
      'totalAssignmentsCompleted': totalAssignmentsCompleted,
      'totalAssignments': totalAssignments,
      'averageScore': averageScore,
      'lastAccessed': Timestamp.fromDate(lastAccessed),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lessonProgress': lessonProgress.map((lp) => lp.toJson()).toList(),
      'assignmentProgress': assignmentProgress.map((ap) => ap.toJson()).toList(),
      'timeSpent': timeSpent.toJson(),
      'status': status.toString().split('.').last,
    };
  }
}

class LessonProgress {
  final String lessonId;
  final String lessonTitle;
  final bool isCompleted;
  final DateTime? completedAt;
  final int timeSpentMinutes;
  final double completionPercentage;
  final List<String> completedActivities;
  
  LessonProgress({
    required this.lessonId,
    required this.lessonTitle,
    required this.isCompleted,
    this.completedAt,
    required this.timeSpentMinutes,
    required this.completionPercentage,
    required this.completedActivities,
  });
  
  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'] ?? '',
      lessonTitle: json['lessonTitle'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null 
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
      timeSpentMinutes: json['timeSpentMinutes'] ?? 0,
      completionPercentage: (json['completionPercentage'] ?? 0.0).toDouble(),
      completedActivities: List<String>.from(json['completedActivities'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'lessonTitle': lessonTitle,
      'isCompleted': isCompleted,
      'completedAt': completedAt != null 
          ? Timestamp.fromDate(completedAt!)
          : null,
      'timeSpentMinutes': timeSpentMinutes,
      'completionPercentage': completionPercentage,
      'completedActivities': completedActivities,
    };
  }
}

class AssignmentProgress {
  final String assignmentId;
  final String assignmentTitle;
  final AssignmentProgressStatus status;
  final int score;
  final int maxScore;
  final DateTime? submittedAt;
  final DateTime? gradedAt;
  final int attemptNumber;
  
  AssignmentProgress({
    required this.assignmentId,
    required this.assignmentTitle,
    required this.status,
    required this.score,
    required this.maxScore,
    this.submittedAt,
    this.gradedAt,
    required this.attemptNumber,
  });
  
  factory AssignmentProgress.fromJson(Map<String, dynamic> json) {
    return AssignmentProgress(
      assignmentId: json['assignmentId'] ?? '',
      assignmentTitle: json['assignmentTitle'] ?? '',
      status: AssignmentProgressStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AssignmentProgressStatus.notStarted,
      ),
      score: json['score'] ?? 0,
      maxScore: json['maxScore'] ?? 100,
      submittedAt: json['submittedAt'] != null 
          ? (json['submittedAt'] as Timestamp).toDate()
          : null,
      gradedAt: json['gradedAt'] != null 
          ? (json['gradedAt'] as Timestamp).toDate()
          : null,
      attemptNumber: json['attemptNumber'] ?? 1,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'assignmentTitle': assignmentTitle,
      'status': status.toString().split('.').last,
      'score': score,
      'maxScore': maxScore,
      'submittedAt': submittedAt != null 
          ? Timestamp.fromDate(submittedAt!)
          : null,
      'gradedAt': gradedAt != null 
          ? Timestamp.fromDate(gradedAt!)
          : null,
      'attemptNumber': attemptNumber,
    };
  }
}

class TimeSpent {
  final int totalMinutes;
  final int todayMinutes;
  final int thisWeekMinutes;
  final int thisMonthMinutes;
  final Map<String, int> dailyBreakdown; // Date string -> minutes
  
  TimeSpent({
    required this.totalMinutes,
    required this.todayMinutes,
    required this.thisWeekMinutes,
    required this.thisMonthMinutes,
    required this.dailyBreakdown,
  });
  
  factory TimeSpent.fromJson(Map<String, dynamic> json) {
    return TimeSpent(
      totalMinutes: json['totalMinutes'] ?? 0,
      todayMinutes: json['todayMinutes'] ?? 0,
      thisWeekMinutes: json['thisWeekMinutes'] ?? 0,
      thisMonthMinutes: json['thisMonthMinutes'] ?? 0,
      dailyBreakdown: Map<String, int>.from(json['dailyBreakdown'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'totalMinutes': totalMinutes,
      'todayMinutes': todayMinutes,
      'thisWeekMinutes': thisWeekMinutes,
      'thisMonthMinutes': thisMonthMinutes,
      'dailyBreakdown': dailyBreakdown,
    };
  }
}

enum AchievementStatus {
  notStarted,
  inProgress,
  completed,
  certificateEarned,
}

enum AssignmentProgressStatus {
  notStarted,
  inProgress,
  submitted,
  graded,
  late,
}