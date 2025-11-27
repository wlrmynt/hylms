import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/learning_analytics.dart';
import '../models/user_progress.dart';
import 'progress_service.dart';

class AnalyticsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  static CollectionReference get analyticsCollection => 
      _firestore.collection('learning_analytics');
  static CollectionReference get insightsCollection => 
      _firestore.collection('learning_insights');
  static CollectionReference get reportsCollection => 
      _firestore.collection('learning_reports');
  
  // Generate comprehensive learning analytics for a user
  static Future<LearningAnalytics> generateUserAnalytics(String userId) async {
    try {
      // Get user's progress data
      List<UserProgress> allProgress = await ProgressService.getUserAllProgress(userId);
      
      if (allProgress.isEmpty) {
        return _createEmptyAnalytics(userId);
      }
      
      // Calculate overall performance
      double overallPerformance = allProgress.fold(0.0, (total, p) => total + p.completionPercentage) / allProgress.length;
      
      // Analyze subject performance
      Map<String, double> subjectPerformance = {};
      Map<String, List<double>> subjectScores = {};
      
      for (UserProgress progress in allProgress) {
        if (!subjectScores.containsKey(progress.courseId)) {
          subjectScores[progress.courseId] = [];
        }
        subjectScores[progress.courseId]!.add(progress.averageScore);
      }
      
      subjectScores.forEach((subjectId, scores) {
        subjectPerformance[subjectId] = scores.reduce((a, b) => a + b) / scores.length;
      });
      
      // Analyze learning patterns
      Map<String, int> learningPattern = _analyzeLearningPattern(allProgress);
      
      // Generate strengths and weaknesses
      List<String> strengths = _identifyStrengths(subjectPerformance, overallPerformance);
      List<String> weaknesses = _identifyWeaknesses(subjectPerformance, overallPerformance);
      
      // Generate recommendations
      List<String> recommendations = _generateRecommendations(
        overallPerformance, 
        subjectPerformance, 
        learningPattern,
      );
      
      // Calculate study metrics
      int totalStudyTime = allProgress.fold(0, (total, p) => total + p.timeSpent.totalMinutes);
      int currentStreak = _calculateCurrentStreak(allProgress);
      int longestStreak = _calculateLongestStreak(allProgress);
      double completionRate = _calculateCompletionRate(allProgress);
      
      // Create detailed metrics
      Map<String, dynamic> detailedMetrics = {
        'totalCourses': allProgress.length,
        'completedCourses': allProgress.where((p) => p.status == AchievementStatus.completed).length,
        'averageCompletionTime': _calculateAverageCompletionTime(allProgress),
        'studyVelocity': _calculateStudyVelocity(allProgress),
        'engagementScore': _calculateEngagementScore(allProgress),
        'consistencyScore': _calculateConsistencyScore(allProgress),
      };
      
      LearningAnalytics analytics = LearningAnalytics(
        id: '',
        userId: userId,
        analysisDate: DateTime.now(),
        overallPerformance: overallPerformance,
        subjectPerformance: subjectPerformance,
        learningPattern: learningPattern,
        strengths: strengths,
        weaknesses: weaknesses,
        recommendations: recommendations,
        totalStudyTime: totalStudyTime,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        completionRate: completionRate,
        detailedMetrics: detailedMetrics,
      );
      
      // Save analytics to database
      DocumentReference doc = await analyticsCollection.add(analytics.toJson());
      
      // Update the analytics with the generated document ID
      analytics = LearningAnalytics(
        id: doc.id,
        userId: analytics.userId,
        analysisDate: analytics.analysisDate,
        overallPerformance: analytics.overallPerformance,
        subjectPerformance: analytics.subjectPerformance,
        learningPattern: analytics.learningPattern,
        strengths: analytics.strengths,
        weaknesses: analytics.weaknesses,
        recommendations: analytics.recommendations,
        totalStudyTime: analytics.totalStudyTime,
        currentStreak: analytics.currentStreak,
        longestStreak: analytics.longestStreak,
        completionRate: analytics.completionRate,
        detailedMetrics: analytics.detailedMetrics,
      );
      
      // Generate insights based on analytics
      await _generateInsightsFromAnalytics(userId, analytics);
      
      return analytics;
    } catch (e) {
      print('Error generating user analytics: $e');
      return _createEmptyAnalytics(userId);
    }
  }
  
  // Get latest analytics for user
  static Future<LearningAnalytics?> getLatestAnalytics(String userId) async {
    try {
      QuerySnapshot snapshot = await analyticsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('analysisDate', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
        data['id'] = snapshot.docs.first.id;
        return LearningAnalytics.fromJson(data);
      }
    } catch (e) {
      print('Error getting latest analytics: $e');
    }
    return null;
  }
  
  // Generate learning insights
  static Future<List<LearningInsight>> generateInsights(String userId) async {
    try {
      LearningAnalytics? analytics = await getLatestAnalytics(userId);
      analytics ??= await generateUserAnalytics(userId);
      
      List<LearningInsight> insights = [];
      
      // Performance insights
      if (analytics.overallPerformance < 50) {
        insights.add(LearningInsight(
          id: '',
          userId: userId,
          type: InsightType.performance,
          title: 'Performa Rendah',
          description: 'Performa Anda dalam belajar perlu ditingkatkan. Fokus pada konsistensi dan metode belajar yang efektif.',
          confidence: 0.9,
          data: {'performance': analytics.overallPerformance},
          priority: 'high',
          isActionable: true,
          suggestedActions: [
            'Buat jadwal belajar yang konsisten',
            'Cari mentor atau tutor',
            'Evaluasi metode belajar saat ini',
            'Fokus pada satu mata kuliah terlebih dahulu',
          ],
          createdAt: DateTime.now(),
          isRead: false,
        ));
      }
      
      // Engagement insights
      if (analytics.currentStreak < 3) {
        insights.add(LearningInsight(
          id: '',
          userId: userId,
          type: InsightType.engagement,
          title: 'Konsistensi Belajar Rendah',
          description: 'Streak belajar Anda pendek. Konsistensi adalah kunci sukses dalam pembelajaran.',
          confidence: 0.8,
          data: {'streak': analytics.currentStreak},
          priority: 'medium',
          isActionable: true,
          suggestedActions: [
            'Tentukan waktu belajar yang tetap setiap hari',
            'Gunakan pengingat atau alarm',
            'Mulai dengan target kecil (15-30 menit per hari)',
            'Gunakan teknik pomodoro',
          ],
          createdAt: DateTime.now(),
          isRead: false,
        ));
      }
      
      // Time management insights
      if (analytics.totalStudyTime < 300) { // Less than 5 hours
        insights.add(LearningInsight(
          id: '',
          userId: userId,
          type: InsightType.timeManagement,
          title: 'Waktu Belajar Tidak Mencukupi',
          description: 'Waktu belajar Anda masih kurang untuk mencapai hasil optimal.',
          confidence: 0.9,
          data: {'studyTime': analytics.totalStudyTime},
          priority: 'high',
          isActionable: true,
          suggestedActions: [
            'Tambahkan minimal 2 jam belajar per hari',
            'Manfaatkan waktu luang (transportasi, waiting time)',
            'Prioritaskan waktu belajar di jadwal harian',
            'Buat lingkungan belajar yang mendukung',
          ],
          createdAt: DateTime.now(),
          isRead: false,
        ));
      }
      
      // Subject-specific insights
      analytics.subjectPerformance.forEach((subjectId, score) {
        if (score < 60) {
          insights.add(LearningInsight(
            id: '',
            userId: userId,
            type: InsightType.skillGap,
            title: 'Kekurangan Skill di Mata Kuliah Tertentu',
            description: 'Ada kesulitan dalam mata kuliah tertentu yang perlu mendapatkan perhatian lebih.',
            confidence: 0.85,
            data: {'subjectId': subjectId, 'score': score},
            priority: score < 50 ? 'high' : 'medium',
            isActionable: true,
            suggestedActions: [
              'Cari referensi tambahan untuk mata kuliah ini',
              'Bergabung dalam grup belajar',
              'Konsultasi dengan dosen atau asisten',
              'Latihan soal lebih banyak',
            ],
            createdAt: DateTime.now(),
            isRead: false,
          ));
        }
      });
      
      // Save insights to database
      for (LearningInsight insight in insights) {
        await insightsCollection.add(insight.toJson());
      }
      
      return insights;
    } catch (e) {
      print('Error generating insights: $e');
      return [];
    }
  }
  
  // Get user's insights
  static Future<List<LearningInsight>> getUserInsights(
    String userId, {
    bool includeRead = false,
    int limit = 10,
  }) async {
    try {
      Query query = insightsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit);
      
      if (!includeRead) {
        query = query.where('isRead', isEqualTo: false);
      }
      
      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return LearningInsight.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting user insights: $e');
      return [];
    }
  }
  
  // Generate learning report
  static Future<LearningReport> generateLearningReport({
    required String userId,
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Get progress data for the period
      List<UserProgress> periodProgress = await _getProgressInPeriod(userId, startDate, endDate);
      
      // Calculate summary metrics
      Map<String, dynamic> summary = _calculatePeriodSummary(periodProgress);
      
      // Identify achievements
      List<String> achievements = _identifyAchievements(periodProgress);
      
      // Set goals for next period
      List<String> goals = _setLearningGoals(periodProgress, reportType);
      
      // Generate detailed analysis
      Map<String, dynamic> detailedAnalysis = await _generateDetailedAnalysis(userId, periodProgress);
      
      LearningReport report = LearningReport(
        id: '',
        userId: userId,
        reportType: reportType,
        startDate: startDate,
        endDate: endDate,
        summary: summary,
        achievements: achievements,
        goals: goals,
        detailedAnalysis: detailedAnalysis,
        generatedBy: 'ai',
        createdAt: DateTime.now(),
      );
      
      // Save report to database
      DocumentReference doc = await reportsCollection.add(report.toJson());
      
      // Update the report with the generated document ID
      report = LearningReport(
        id: doc.id,
        userId: report.userId,
        reportType: report.reportType,
        startDate: report.startDate,
        endDate: report.endDate,
        summary: report.summary,
        achievements: report.achievements,
        goals: report.goals,
        detailedAnalysis: report.detailedAnalysis,
        generatedBy: report.generatedBy,
        createdAt: report.createdAt,
      );
      
      return report;
    } catch (e) {
      print('Error generating learning report: $e');
      throw 'Failed to generate learning report';
    }
  }
  
  // Get learning reports for user
  static Future<List<LearningReport>> getUserReports(String userId) async {
    try {
      QuerySnapshot snapshot = await reportsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return LearningReport.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting user reports: $e');
      return [];
    }
  }
  
  // Helper methods
  static LearningAnalytics _createEmptyAnalytics(String userId) {
    return LearningAnalytics(
      id: '',
      userId: userId,
      analysisDate: DateTime.now(),
      overallPerformance: 0.0,
      subjectPerformance: {},
      learningPattern: {},
      strengths: [],
      weaknesses: [],
      recommendations: [],
      totalStudyTime: 0,
      currentStreak: 0,
      longestStreak: 0,
      completionRate: 0.0,
      detailedMetrics: {},
    );
  }
  
  static Map<String, int> _analyzeLearningPattern(List<UserProgress> progressList) {
    Map<String, int> pattern = {
      'morning': 0,
      'afternoon': 0,
      'evening': 0,
      'night': 0,
    };
    
    // This is a simplified analysis - in reality, you'd track actual study times
    for (UserProgress progress in progressList) {
      int hour = progress.lastAccessed.hour;
      if (hour >= 6 && hour < 12) {
        pattern['morning'] = (pattern['morning'] ?? 0) + 1;
      } else if (hour >= 12 && hour < 17) {
        pattern['afternoon'] = (pattern['afternoon'] ?? 0) + 1;
      } else if (hour >= 17 && hour < 22) {
        pattern['evening'] = (pattern['evening'] ?? 0) + 1;
      } else {
        pattern['night'] = (pattern['night'] ?? 0) + 1;
      }
    }
    
    return pattern;
  }
  
  static List<String> _identifyStrengths(Map<String, double> subjectPerformance, double overallPerformance) {
    List<String> strengths = [];
    
    if (overallPerformance >= 80) {
      strengths.add('Konsistensi tinggi dalam belajar');
    }
    
    subjectPerformance.forEach((subject, score) {
      if (score >= 85) {
        strengths.add('Kemampuan tinggi di mata kuliah tertentu');
      }
    });
    
    if (strengths.isEmpty) {
      strengths.add('Potensi untuk berkembang');
    }
    
    return strengths;
  }
  
  static List<String> _identifyWeaknesses(Map<String, double> subjectPerformance, double overallPerformance) {
    List<String> weaknesses = [];
    
    if (overallPerformance < 60) {
      weaknesses.add('Perlu meningkatkan konsistensi belajar');
    }
    
    subjectPerformance.forEach((subject, score) {
      if (score < 60) {
        weaknesses.add('Kesulitan di mata kuliah tertentu');
      }
    });
    
    return weaknesses;
  }
  
  static List<String> _generateRecommendations(
    double overallPerformance,
    Map<String, double> subjectPerformance,
    Map<String, int> learningPattern,
  ) {
    List<String> recommendations = [];
    
    if (overallPerformance < 70) {
      recommendations.add('Tingkatkan frekuensi belajar harian');
    }
    
    if (learningPattern['morning'] == 0 && learningPattern['afternoon'] == 0) {
      recommendations.add('Coba belajar di pagi atau siang hari untuk hasil optimal');
    }
    
    if (subjectPerformance.isNotEmpty) {
      double lowestScore = subjectPerformance.values.reduce((a, b) => a < b ? a : b);
      if (lowestScore < 70) {
        recommendations.add('Fokus lebih pada mata kuliah dengan nilai rendah');
      }
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Pertahankan performa yang baik');
    }
    
    return recommendations;
  }
  
  static int _calculateCurrentStreak(List<UserProgress> progressList) {
    // Simplified streak calculation
    if (progressList.isEmpty) return 0;
    return progressList.first.timeSpent.todayMinutes > 0 ? 1 : 0;
  }
  
  static int _calculateLongestStreak(List<UserProgress> progressList) {
    // Simplified longest streak calculation
    return progressList.length;
  }
  
  static double _calculateCompletionRate(List<UserProgress> progressList) {
    if (progressList.isEmpty) return 0.0;
    
    int completedCourses = progressList.where((p) => p.status == AchievementStatus.completed).length;
    return (completedCourses / progressList.length) * 100;
  }
  
  static double _calculateAverageCompletionTime(List<UserProgress> progressList) {
    // Simplified calculation
    return progressList.isNotEmpty 
        ? progressList.fold(0.0, (total, p) => total + p.timeSpent.totalMinutes) / progressList.length
        : 0.0;
  }
  
  static double _calculateStudyVelocity(List<UserProgress> progressList) {
    // Simplified velocity calculation
    return progressList.isNotEmpty 
        ? progressList.fold(0.0, (total, p) => total + p.completionPercentage) / progressList.length
        : 0.0;
  }
  
  static double _calculateEngagementScore(List<UserProgress> progressList) {
    // Simplified engagement score
    if (progressList.isEmpty) return 0.0;
    
    double totalTimeScore = progressList.fold(0.0, (total, p) => total + (p.timeSpent.totalMinutes / 60.0)) / progressList.length;
    return totalTimeScore > 10 ? 100.0 : totalTimeScore * 10;
  }
  
  static double _calculateConsistencyScore(List<UserProgress> progressList) {
    // Simplified consistency score
    return progressList.isNotEmpty ? 75.0 : 0.0;
  }
  
  static Future<void> _generateInsightsFromAnalytics(String userId, LearningAnalytics analytics) async {
    // This method would generate specific insights based on analytics data
    // Implementation would be similar to generateInsights but more automated
  }
  
  static Future<List<UserProgress>> _getProgressInPeriod(
    String userId, 
    DateTime startDate, 
    DateTime endDate,
  ) async {
    // This would filter progress by date range
    // For now, return all progress
    return await ProgressService.getUserAllProgress(userId);
  }
  
  static Map<String, dynamic> _calculatePeriodSummary(List<UserProgress> progressList) {
    return {
      'totalCourses': progressList.length,
      'averagePerformance': progressList.isNotEmpty 
          ? progressList.fold(0.0, (total, p) => total + p.completionPercentage) / progressList.length
          : 0.0,
      'totalStudyTime': progressList.fold(0, (total, p) => total + p.timeSpent.totalMinutes),
      'completedCourses': progressList.where((p) => p.status == AchievementStatus.completed).length,
    };
  }
  
  static List<String> _identifyAchievements(List<UserProgress> progressList) {
    List<String> achievements = [];
    
    int completedCourses = progressList.where((p) => p.status == AchievementStatus.completed).length;
    if (completedCourses > 0) {
      achievements.add('Menyelesaikan $completedCourses mata kuliah');
    }
    
    if (progressList.isNotEmpty) {
      double avgPerformance = progressList.fold(0.0, (total, p) => total + p.completionPercentage) / progressList.length;
      if (avgPerformance >= 80) {
        achievements.add('Mempertahankan performa tinggi');
      }
    }
    
    return achievements;
  }
  
  static List<String> _setLearningGoals(List<UserProgress> progressList, String reportType) {
    List<String> goals = [];
    
    if (reportType == 'weekly') {
      goals.add('Tingkatkan waktu belajar 20% minggu ini');
      goals.add('Selesaikan 1 mata kuliah tambahan');
    } else if (reportType == 'monthly') {
      goals.add('Capai target 90% completion rate');
      goals.add('Kembangkan skill di 2 mata kuliah');
    } else {
      goals.add('Tingkatkan performa belajar secara keseluruhan');
    }
    
    return goals;
  }
  
  static Future<Map<String, dynamic>> _generateDetailedAnalysis(
    String userId, 
    List<UserProgress> progressList,
  ) async {
    // This would generate more detailed analysis based on all available data
    return {
      'trendAnalysis': 'Positive trend in learning progress',
      'riskFactors': ['Inconsistent study schedule', 'Low engagement in some subjects'],
      'opportunities': ['Increase study time', 'Focus on weak areas'],
    };
  }
}