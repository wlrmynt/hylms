import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_progress.dart';
import '../models/assignment.dart';

class ProgressService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference
  static CollectionReference get progressCollection => 
      _firestore.collection('user_progress');
  
  // Get user's progress for a specific course
  static Future<UserProgress?> getUserCourseProgress(String userId, String courseId) async {
    try {
      QuerySnapshot snapshot = await progressCollection
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
        data['id'] = snapshot.docs.first.id;
        return UserProgress.fromJson(data);
      }
    } catch (e) {
      print('Error getting user course progress: $e');
    }
    return null;
  }
  
  // Get all progress for a user across all courses
  static Future<List<UserProgress>> getUserAllProgress(String userId) async {
    try {
      QuerySnapshot snapshot = await progressCollection
          .where('userId', isEqualTo: userId)
          .orderBy('lastAccessed', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return UserProgress.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting user all progress: $e');
      return [];
    }
  }
  
  // Create initial progress for a user in a course
  static Future<String> createInitialProgress(String userId, String courseId) async {
    try {
      UserProgress progress = UserProgress(
        id: '',
        userId: userId,
        courseId: courseId,
        completionPercentage: 0.0,
        totalLessonsCompleted: 0,
        totalLessons: 0,
        totalAssignmentsCompleted: 0,
        totalAssignments: 0,
        averageScore: 0.0,
        lastAccessed: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lessonProgress: [],
        assignmentProgress: [],
        timeSpent: TimeSpent(
          totalMinutes: 0,
          todayMinutes: 0,
          thisWeekMinutes: 0,
          thisMonthMinutes: 0,
          dailyBreakdown: {},
        ),
        status: AchievementStatus.notStarted,
      );
      
      DocumentReference doc = await progressCollection.add(progress.toJson());
      return doc.id;
    } catch (e) {
      print('Error creating initial progress: $e');
      throw 'Failed to create initial progress';
    }
  }
  
  // Update lesson progress
  static Future<void> updateLessonProgress(
    String userId, 
    String courseId, 
    String lessonId, 
    String lessonTitle,
    bool isCompleted,
    int timeSpentMinutes,
    double completionPercentage,
  ) async {
    try {
      UserProgress? progress = await getUserCourseProgress(userId, courseId);
      if (progress == null) {
        await createInitialProgress(userId, courseId);
        progress = await getUserCourseProgress(userId, courseId);
      }
      
      if (progress != null) {
        // Update or add lesson progress
        List<LessonProgress> updatedLessonProgress = [...progress.lessonProgress];
        int existingIndex = updatedLessonProgress.indexWhere((lp) => lp.lessonId == lessonId);
        
        LessonProgress lessonProgress = LessonProgress(
          lessonId: lessonId,
          lessonTitle: lessonTitle,
          isCompleted: isCompleted,
          completedAt: isCompleted ? DateTime.now() : null,
          timeSpentMinutes: timeSpentMinutes,
          completionPercentage: completionPercentage,
          completedActivities: existingIndex >= 0 
              ? updatedLessonProgress[existingIndex].completedActivities
              : [],
        );
        
        if (existingIndex >= 0) {
          updatedLessonProgress[existingIndex] = lessonProgress;
        } else {
          updatedLessonProgress.add(lessonProgress);
        }
        
        // Recalculate overall progress
        int totalCompletedLessons = updatedLessonProgress.where((lp) => lp.isCompleted).length;
        int totalLessons = progress.totalLessons > 0 ? progress.totalLessons : updatedLessonProgress.length;
        double newCompletionPercentage = totalLessons > 0 ? (totalCompletedLessons / totalLessons) * 100 : 0.0;
        
        // Update time spent
        TimeSpent updatedTimeSpent = _updateTimeSpent(progress.timeSpent, timeSpentMinutes);
        
        AchievementStatus newStatus = _determineAchievementStatus(
          newCompletionPercentage, 
          progress.totalAssignmentsCompleted, 
          progress.totalAssignments,
          progress.averageScore,
        );
        
        UserProgress updatedProgress = UserProgress(
          id: progress.id,
          userId: progress.userId,
          courseId: progress.courseId,
          completionPercentage: newCompletionPercentage,
          totalLessonsCompleted: totalCompletedLessons,
          totalLessons: totalLessons,
          totalAssignmentsCompleted: progress.totalAssignmentsCompleted,
          totalAssignments: progress.totalAssignments,
          averageScore: progress.averageScore,
          lastAccessed: DateTime.now(),
          createdAt: progress.createdAt,
          updatedAt: DateTime.now(),
          lessonProgress: updatedLessonProgress,
          assignmentProgress: progress.assignmentProgress,
          timeSpent: updatedTimeSpent,
          status: newStatus,
        );
        
        await progressCollection.doc(progress.id).update(updatedProgress.toJson());
      }
    } catch (e) {
      print('Error updating lesson progress: $e');
      throw 'Failed to update lesson progress';
    }
  }
  
  // Update assignment progress
  static Future<void> updateAssignmentProgress(
    String userId, 
    String courseId, 
    Assignment assignment,
    AssignmentSubmission submission,
  ) async {
    try {
      UserProgress? progress = await getUserCourseProgress(userId, courseId);
      if (progress == null) {
        await createInitialProgress(userId, courseId);
        progress = await getUserCourseProgress(userId, courseId);
      }
      
      if (progress != null) {
        // Update or add assignment progress
        List<AssignmentProgress> updatedAssignmentProgress = [...progress.assignmentProgress];
        int existingIndex = updatedAssignmentProgress.indexWhere((ap) => ap.assignmentId == assignment.id);
        
        AssignmentProgressStatus status = _mapSubmissionStatus(submission.status);
        
        AssignmentProgress assignmentProgress = AssignmentProgress(
          assignmentId: assignment.id,
          assignmentTitle: assignment.title,
          status: status,
          score: submission.score,
          maxScore: submission.maxScore,
          submittedAt: submission.submittedAt,
          gradedAt: submission.gradedAt,
          attemptNumber: submission.attemptNumber,
        );
        
        if (existingIndex >= 0) {
          updatedAssignmentProgress[existingIndex] = assignmentProgress;
        } else {
          updatedAssignmentProgress.add(assignmentProgress);
        }
        
        // Recalculate overall progress
        int totalCompletedAssignments = updatedAssignmentProgress
            .where((ap) => ap.status == AssignmentProgressStatus.graded || ap.status == AssignmentProgressStatus.submitted)
            .length;
        int totalAssignments = progress.totalAssignments > 0 ? progress.totalAssignments : updatedAssignmentProgress.length;
        double newAverageScore = _calculateAverageScore(updatedAssignmentProgress);
        
        // Update lesson progress count if exists
        int totalLessons = progress.totalLessons;
        int totalCompletedLessons = progress.totalLessonsCompleted;
        
        // Calculate overall completion percentage
        double lessonWeight = 0.6; // 60% weight for lessons
        double assignmentWeight = 0.4; // 40% weight for assignments
        
        double lessonCompletion = totalLessons > 0 ? (totalCompletedLessons / totalLessons) * 100 : 0.0;
        double assignmentCompletion = totalAssignments > 0 ? (totalCompletedAssignments / totalAssignments) * 100 : 0.0;
        
        double newCompletionPercentage = (lessonCompletion * lessonWeight) + (assignmentCompletion * assignmentWeight);
        
        AchievementStatus newStatus = _determineAchievementStatus(
          newCompletionPercentage, 
          totalCompletedAssignments, 
          totalAssignments,
          newAverageScore,
        );
        
        UserProgress updatedProgress = UserProgress(
          id: progress.id,
          userId: progress.userId,
          courseId: progress.courseId,
          completionPercentage: newCompletionPercentage,
          totalLessonsCompleted: totalCompletedLessons,
          totalLessons: totalLessons,
          totalAssignmentsCompleted: totalCompletedAssignments,
          totalAssignments: totalAssignments,
          averageScore: newAverageScore,
          lastAccessed: DateTime.now(),
          createdAt: progress.createdAt,
          updatedAt: DateTime.now(),
          lessonProgress: progress.lessonProgress,
          assignmentProgress: updatedAssignmentProgress,
          timeSpent: progress.timeSpent,
          status: newStatus,
        );
        
        await progressCollection.doc(progress.id).update(updatedProgress.toJson());
      }
    } catch (e) {
      print('Error updating assignment progress: $e');
      throw 'Failed to update assignment progress';
    }
  }
  
  // Track time spent on a lesson
  static Future<void> trackTimeSpent(
    String userId, 
    String courseId, 
    int additionalMinutes,
  ) async {
    try {
      UserProgress? progress = await getUserCourseProgress(userId, courseId);
      if (progress != null) {
        TimeSpent updatedTimeSpent = _updateTimeSpent(progress.timeSpent, additionalMinutes);
        
        await progressCollection.doc(progress.id).update({
          'timeSpent': updatedTimeSpent.toJson(),
          'lastAccessed': Timestamp.fromDate(DateTime.now()),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
      }
    } catch (e) {
      print('Error tracking time spent: $e');
    }
  }
  
  // Get learning analytics for a user
  static Future<Map<String, dynamic>> getUserLearningAnalytics(String userId) async {
    try {
      List<UserProgress> allProgress = await getUserAllProgress(userId);
      
      int totalCoursesEnrolled = allProgress.length;
      int totalCoursesCompleted = allProgress.where((p) => p.status == AchievementStatus.completed).length;
      double averageCompletion = allProgress.isNotEmpty 
          ? allProgress.map((p) => p.completionPercentage).reduce((a, b) => a + b) / allProgress.length
          : 0.0;
      double averageScore = allProgress.isNotEmpty 
          ? allProgress.map((p) => p.averageScore).reduce((a, b) => a + b) / allProgress.length
          : 0.0;
      int totalTimeSpent = allProgress.fold(0, (sum, p) => sum + p.timeSpent.totalMinutes);
      
      // Learning streak calculation
      Map<String, int> dailyActivity = {};
      for (UserProgress progress in allProgress) {
        dailyActivity.addAll(progress.timeSpent.dailyBreakdown);
      }
      
      int currentStreak = _calculateLearningStreak(dailyActivity);
      int longestStreak = _calculateLongestStreak(dailyActivity);
      
      return {
        'totalCoursesEnrolled': totalCoursesEnrolled,
        'totalCoursesCompleted': totalCoursesCompleted,
        'averageCompletion': averageCompletion,
        'averageScore': averageScore,
        'totalTimeSpent': totalTimeSpent,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'completionRate': totalCoursesEnrolled > 0 ? (totalCoursesCompleted / totalCoursesEnrolled) * 100 : 0.0,
        'progressData': allProgress,
      };
    } catch (e) {
      print('Error getting user learning analytics: $e');
      return {};
    }
  }
  
  // Helper methods
  static TimeSpent _updateTimeSpent(TimeSpent current, int additionalMinutes) {
    Map<String, int> updatedDailyBreakdown = Map.from(current.dailyBreakdown);
    String today = DateTime.now().toIso8601String().split('T').first;
    
    updatedDailyBreakdown[today] = (updatedDailyBreakdown[today] ?? 0) + additionalMinutes;
    
    // Update weekly and monthly totals
    int thisWeekMinutes = _getThisWeekMinutes(updatedDailyBreakdown);
    int thisMonthMinutes = _getThisMonthMinutes(updatedDailyBreakdown);
    
    return TimeSpent(
      totalMinutes: current.totalMinutes + additionalMinutes,
      todayMinutes: updatedDailyBreakdown[today] ?? 0,
      thisWeekMinutes: thisWeekMinutes,
      thisMonthMinutes: thisMonthMinutes,
      dailyBreakdown: updatedDailyBreakdown,
    );
  }
  
  static AchievementStatus _determineAchievementStatus(
    double completionPercentage, 
    int completedAssignments, 
    int totalAssignments,
    double averageScore,
  ) {
    if (completionPercentage >= 100.0 && totalAssignments > 0 && completedAssignments >= totalAssignments && averageScore >= 70.0) {
      return AchievementStatus.certificateEarned;
    } else if (completionPercentage >= 100.0) {
      return AchievementStatus.completed;
    } else if (completionPercentage > 0.0) {
      return AchievementStatus.inProgress;
    } else {
      return AchievementStatus.notStarted;
    }
  }
  
  static double _calculateAverageScore(List<AssignmentProgress> assignmentProgress) {
    if (assignmentProgress.isEmpty) return 0.0;
    
    int totalScore = 0;
    int totalMaxScore = 0;
    
    for (AssignmentProgress ap in assignmentProgress) {
      if (ap.status == AssignmentProgressStatus.graded) {
        totalScore += ap.score;
        totalMaxScore += ap.maxScore;
      }
    }
    
    return totalMaxScore > 0 ? (totalScore / totalMaxScore) * 100 : 0.0;
  }
  
  static AssignmentProgressStatus _mapSubmissionStatus(SubmissionStatus submissionStatus) {
    switch (submissionStatus) {
      case SubmissionStatus.draft:
        return AssignmentProgressStatus.notStarted;
      case SubmissionStatus.submitted:
        return AssignmentProgressStatus.submitted;
      case SubmissionStatus.graded:
        return AssignmentProgressStatus.graded;
      case SubmissionStatus.late:
        return AssignmentProgressStatus.late;
      case SubmissionStatus.needsGrading:
        return AssignmentProgressStatus.submitted;
    }
  }
  
  static int _getThisWeekMinutes(Map<String, int> dailyBreakdown) {
    DateTime now = DateTime.now();
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    int totalMinutes = 0;
    
    for (int i = 0; i < 7; i++) {
      String date = weekStart.add(Duration(days: i)).toIso8601String().split('T').first;
      totalMinutes += dailyBreakdown[date] ?? 0;
    }
    
    return totalMinutes;
  }
  
  static int _getThisMonthMinutes(Map<String, int> dailyBreakdown) {
    DateTime now = DateTime.now();
    DateTime monthStart = DateTime(now.year, now.month, 1);
    int totalMinutes = 0;
    
    for (int i = 0; i < now.day; i++) {
      String date = monthStart.add(Duration(days: i)).toIso8601String().split('T').first;
      totalMinutes += dailyBreakdown[date] ?? 0;
    }
    
    return totalMinutes;
  }
  
  static int _calculateLearningStreak(Map<String, int> dailyActivity) {
    DateTime today = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 365; i++) { // Check up to a year
      DateTime checkDate = today.subtract(Duration(days: i));
      String dateString = checkDate.toIso8601String().split('T').first;
      
      if (dailyActivity[dateString] != null && dailyActivity[dateString]! > 0) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }
  
  static int _calculateLongestStreak(Map<String, int> dailyActivity) {
    List<String> activeDates = dailyActivity.entries
        .where((entry) => entry.value > 0)
        .map((entry) => entry.key)
        .toList();
    
    if (activeDates.isEmpty) return 0;
    
    activeDates.sort();
    int longestStreak = 1;
    int currentStreak = 1;
    
    for (int i = 1; i < activeDates.length; i++) {
      DateTime current = DateTime.parse(activeDates[i]);
      DateTime previous = DateTime.parse(activeDates[i-1]);
      
      if (current.difference(previous).inDays == 1) {
        currentStreak++;
        longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
      } else {
        currentStreak = 1;
      }
    }
    
    return longestStreak;
  }
}