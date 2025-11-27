import 'package:cloud_firestore/cloud_firestore.dart';

class LearningAnalytics {
  final String id;
  final String userId;
  final DateTime analysisDate;
  final double overallPerformance;
  final Map<String, double> subjectPerformance;
  final Map<String, int> learningPattern;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;
  final int totalStudyTime;
  final int currentStreak;
  final int longestStreak;
  final double completionRate;
  final Map<String, dynamic> detailedMetrics;
  
  LearningAnalytics({
    required this.id,
    required this.userId,
    required this.analysisDate,
    required this.overallPerformance,
    required this.subjectPerformance,
    required this.learningPattern,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
    required this.totalStudyTime,
    required this.currentStreak,
    required this.longestStreak,
    required this.completionRate,
    required this.detailedMetrics,
  });
  
  factory LearningAnalytics.fromJson(Map<String, dynamic> json) {
    return LearningAnalytics(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      analysisDate: (json['analysisDate'] as Timestamp).toDate(),
      overallPerformance: (json['overallPerformance'] ?? 0.0).toDouble(),
      subjectPerformance: Map<String, double>.from(json['subjectPerformance'] ?? {}),
      learningPattern: Map<String, int>.from(json['learningPattern'] ?? {}),
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      totalStudyTime: json['totalStudyTime'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      completionRate: (json['completionRate'] ?? 0.0).toDouble(),
      detailedMetrics: Map<String, dynamic>.from(json['detailedMetrics'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'analysisDate': Timestamp.fromDate(analysisDate),
      'overallPerformance': overallPerformance,
      'subjectPerformance': subjectPerformance,
      'learningPattern': learningPattern,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'recommendations': recommendations,
      'totalStudyTime': totalStudyTime,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'completionRate': completionRate,
      'detailedMetrics': detailedMetrics,
    };
  }
}

class LearningInsight {
  final String id;
  final String userId;
  final InsightType type;
  final String title;
  final String description;
  final double confidence;
  final Map<String, dynamic> data;
  final String priority; // high, medium, low
  final bool isActionable;
  final List<String> suggestedActions;
  final DateTime createdAt;
  final bool isRead;
  
  LearningInsight({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.confidence,
    required this.data,
    required this.priority,
    required this.isActionable,
    required this.suggestedActions,
    required this.createdAt,
    required this.isRead,
  });
  
  factory LearningInsight.fromJson(Map<String, dynamic> json) {
    return LearningInsight(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: InsightType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => InsightType.performance,
      ),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      priority: json['priority'] ?? 'medium',
      isActionable: json['isActionable'] ?? false,
      suggestedActions: List<String>.from(json['suggestedActions'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      isRead: json['isRead'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'confidence': confidence,
      'data': data,
      'priority': priority,
      'isActionable': isActionable,
      'suggestedActions': suggestedActions,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }
}

enum InsightType {
  performance,
  engagement,
  timeManagement,
  skillGap,
  recommendation,
  warning,
  achievement,
}

class LearningReport {
  final String id;
  final String userId;
  final String reportType; // weekly, monthly, semester, custom
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> summary;
  final List<String> achievements;
  final List<String> goals;
  final Map<String, dynamic> detailedAnalysis;
  final String generatedBy; // ai, instructor, system
  final DateTime createdAt;
  
  LearningReport({
    required this.id,
    required this.userId,
    required this.reportType,
    required this.startDate,
    required this.endDate,
    required this.summary,
    required this.achievements,
    required this.goals,
    required this.detailedAnalysis,
    required this.generatedBy,
    required this.createdAt,
  });
  
  factory LearningReport.fromJson(Map<String, dynamic> json) {
    return LearningReport(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      reportType: json['reportType'] ?? '',
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      summary: Map<String, dynamic>.from(json['summary'] ?? {}),
      achievements: List<String>.from(json['achievements'] ?? []),
      goals: List<String>.from(json['goals'] ?? []),
      detailedAnalysis: Map<String, dynamic>.from(json['detailedAnalysis'] ?? {}),
      generatedBy: json['generatedBy'] ?? 'system',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'reportType': reportType,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'summary': summary,
      'achievements': achievements,
      'goals': goals,
      'detailedAnalysis': detailedAnalysis,
      'generatedBy': generatedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}