import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';
import '../models/user_profile.dart';
import '../models/assignment.dart';
import '../models/user_progress.dart';
import '../models/certificate.dart';
import '../models/forum.dart';
import '../models/notification.dart';
import '../models/structured_class.dart';
import '../models/learning_analytics.dart';
import '../services/firestore_course_service.dart';
import '../services/assignment_service.dart';
import '../services/progress_service.dart';
import '../services/certificate_service.dart';
import '../services/forum_service.dart';
import '../services/notification_service.dart';
import '../services/class_service.dart';
import '../services/analytics_service.dart';
import '../services/realtime_service.dart';
import '../services/ai_recommendation_service.dart';
import '../services/firebase_auth_service.dart';

class BackendService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Service health status
  static bool _isInitialized = false;
  static Map<String, bool> _serviceHealth = {};
  
  // Initialize all backend services
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    print('🚀 Initializing Backend Services...');
    
    try {
      // Test Firebase connection
      await _firestore.collection('health_check').limit(1).get();
      _serviceHealth['firebase'] = true;
      
      // Initialize all services
      await Future.wait([
        _testCourseService(),
        _testAssignmentService(),
        _testProgressService(),
        _testNotificationService(),
        _testForumService(),
        _testClassService(),
        _testAnalyticsService(),
        _testRealtimeService(),
      ]);
      
      _isInitialized = true;
      print('✅ All backend services initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize backend services: $e');
      _isInitialized = false;
      rethrow;
    }
  }
  
  // Get service health status
  static Map<String, bool> getServiceHealth() {
    return Map.from(_serviceHealth);
  }
  
  // Check if service is healthy
  static bool isServiceHealthy(String serviceName) {
    return _serviceHealth[serviceName] ?? false;
  }
  
  // ===== COURSE MANAGEMENT =====
  
  // Get dashboard data for a user
  static Future<Map<String, dynamic>> getUserDashboard(String userId) async {
    await _ensureInitialized();
    
    try {
      // Get user's enrolled courses
      List<Course> courses = await FirestoreCourseService.getAllCourses();
      
      // Get user's progress
      List<UserProgress> userProgress = await ProgressService.getUserAllProgress(userId);
      
      // Get recent assignments
      List<Assignment> assignments = await AssignmentService.getUpcomingAssignmentsForStudent(userId);
      
      // Get notifications
      List<Notification> notifications = await NotificationService.getUserNotifications(userId, limit: 5);
      
      // Get learning analytics
      LearningAnalytics? analytics = await AnalyticsService.getLatestAnalytics(userId);
      
      return {
        'courses': courses,
        'userProgress': userProgress,
        'assignments': assignments,
        'notifications': notifications,
        'analytics': analytics,
        'stats': {
          'totalCourses': courses.length,
          'completedCourses': userProgress.where((p) => p.status.name == 'completed').length,
          'inProgressCourses': userProgress.where((p) => p.status.name == 'inProgress').length,
          'unreadNotifications': notifications.where((n) => !n.isRead).length,
        }
      };
    } catch (e) {
      print('Error getting user dashboard: $e');
      throw 'Failed to load dashboard data';
    }
  }
  
  // Get personalized course recommendations
  static Future<List<Course>> getPersonalizedRecommendations(String userId) async {
    await _ensureInitialized();
    
    try {
      // Get user profile
      UserProfile? userProfile = await FirebaseAuthService.getUserProfile(userId);
      if (userProfile == null) return [];
      
      // Get all courses
      List<Course> allCourses = await FirestoreCourseService.getAllCourses();
      
      // Get user's completed courses to exclude
      List<UserProgress> userProgress = await ProgressService.getUserAllProgress(userId);
      List<String> completedCourseIds = userProgress
          .where((p) => p.status.name == 'completed')
          .map((p) => p.courseId)
          .toList();
      
      // Get available courses (not completed)
      List<Course> availableCourses = allCourses
          .where((course) => !completedCourseIds.contains(course.id))
          .toList();
      
      // Get AI recommendations
      return AIRecommendationService.getPersonalizedRecommendations(
        userProfile: userProfile,
        completedCourses: userProgress
            .where((p) => p.status.name == 'completed')
            .map((p) => allCourses.firstWhere((c) => c.id == p.courseId))
            .toList(),
        availableCourses: availableCourses,
      );
    } catch (e) {
      print('Error getting personalized recommendations: $e');
      return [];
    }
  }
  
  // ===== ASSIGNMENT MANAGEMENT =====
  
  // Submit assignment with progress update
  static Future<void> submitAssignment({
    required String userId,
    required String assignmentId,
    required List<String> answers,
  }) async {
    await _ensureInitialized();
    
    try {
      // Get assignment details
      Assignment? assignment = await AssignmentService.getAssignmentById(assignmentId);
      if (assignment == null) throw 'Assignment not found';
      
      // Create submission
      AssignmentSubmission submission = AssignmentSubmission(
        id: '',
        assignmentId: assignmentId,
        studentId: userId,
        answers: answers,
        score: 0, // Will be calculated
        maxScore: assignment.maxPoints,
        submittedAt: DateTime.now(),
        status: SubmissionStatus.submitted,
        attemptNumber: 1,
      );
      
      // Auto-grade if it's a quiz
      if (assignment.type == AssignmentType.quiz) {
        int autoScore = AssignmentService.autoGradeQuiz(assignment, answers);
        submission = submission.copyWith(score: autoScore);
      }
      
      // Submit the assignment
      String submissionId = await AssignmentService.submitAssignment(submission);
      
      // Update user progress
      await ProgressService.updateAssignmentProgress(
        userId,
        assignment.courseId,
        assignment,
        submission,
      );
      
      // Send notification
      await NotificationService.sendTemplatedNotification(
        userId: userId,
        templateId: 'assignment_submitted',
        data: {
          'assignmentTitle': assignment.title,
          'submissionId': submissionId,
          'courseTitle': assignment.courseId,
        },
      );
      
      // Publish real-time update
      await RealtimeService.publishAssignmentUpdate(
        userId,
        assignmentId,
        'submitted',
        {
          'submissionId': submissionId,
          'courseId': assignment.courseId,
        },
      );
      
    } catch (e) {
      print('Error submitting assignment: $e');
      throw 'Failed to submit assignment';
    }
  }
  
  // ===== PROGRESS TRACKING =====
  
  // Update lesson progress
  static Future<void> updateLessonProgress({
    required String userId,
    required String courseId,
    required String lessonId,
    required String lessonTitle,
    required bool isCompleted,
    required int timeSpentMinutes,
  }) async {
    await _ensureInitialized();
    
    try {
      // Update progress
      await ProgressService.updateLessonProgress(
        userId,
        courseId,
        lessonId,
        lessonTitle,
        isCompleted,
        timeSpentMinutes,
        isCompleted ? 100.0 : 50.0,
      );
      
      // Track time spent
      await ProgressService.trackTimeSpent(userId, courseId, timeSpentMinutes);
      
      // Check if course is completed and generate certificate if needed
      UserProgress? progress = await ProgressService.getUserCourseProgress(userId, courseId);
      if (progress != null && progress.status.name == 'completed' && progress.completionPercentage >= 100.0) {
        Course? course = await FirestoreCourseService.getCourseById(courseId);
        UserProfile? userProfile = await FirebaseAuthService.getUserProfile(userId);
        
        if (course != null && userProfile != null) {
          // Check if certificate already exists
          Certificate? existingCert = await CertificateService.getUserCourseCertificate(userId, courseId);
          if (existingCert == null) {
            await CertificateService.generateCertificate(
              userId: userId,
              courseId: courseId,
              course: course,
              userProfile: userProfile,
              progress: progress,
            );
            
            // Send certificate notification
            await NotificationService.sendTemplatedNotification(
              userId: userId,
              templateId: 'certificate_earned',
              data: {
                'courseTitle': course.title,
                'certificateUrl': 'certificate_url_here',
              },
            );
          }
        }
      }
      
      // Publish real-time update
      await RealtimeService.publishProgressUpdate(
        userId,
        courseId,
        isCompleted ? 'lesson_completed' : 'lesson_progress',
        {
          'lessonId': lessonId,
          'lessonTitle': lessonTitle,
          'timeSpent': timeSpentMinutes,
        },
      );
      
    } catch (e) {
      print('Error updating lesson progress: $e');
      throw 'Failed to update lesson progress';
    }
  }
  
  // ===== FORUM MANAGEMENT =====
  
  // Create forum thread with notification
  static Future<String> createForumThread({
    required String userId,
    required String courseId,
    required String title,
    required String content,
    required ThreadCategory category,
  }) async {
    await _ensureInitialized();
    
    try {
      // Get user profile
      UserProfile? userProfile = await FirebaseAuthService.getUserProfile(userId);
      if (userProfile == null) throw 'User not found';
      
      // Create thread
      DiscussionThread thread = DiscussionThread(
        id: '',
        title: title,
        content: content,
        courseId: courseId,
        authorId: userId,
        authorName: userProfile.name,
        authorRole: userProfile.role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        category: category,
        priority: ThreadPriority.normal,
        views: 0,
        replies: 0,
        tags: [category.toString().split('.').last],
        upvotes: 0,
        downvotes: 0,
      );
      
      String threadId = await ForumService.createThread(thread);
      
      // Notify enrolled students in the course
      List<String> enrolledStudentIds = await _getEnrolledStudentIds(courseId);
      enrolledStudentIds.remove(userId); // Don't notify the creator
      
      if (enrolledStudentIds.isNotEmpty) {
        // Note: Real-time notifications would be sent to enrolled students
        // This is a placeholder for the full implementation
      }
      
      return threadId;
    } catch (e) {
      print('Error creating forum thread: $e');
      throw 'Failed to create forum thread';
    }
  }
  
  // ===== CLASS MANAGEMENT =====
  
  // Enroll in structured class
  static Future<void> enrollInClass({
    required String userId,
    required String classId,
  }) async {
    await _ensureInitialized();
    
    try {
      // Get class and user details
      StructuredClass? classInfo = await ClassService.getClassById(classId);
      UserProfile? userProfile = await FirebaseAuthService.getUserProfile(userId);
      
      if (classInfo == null) throw 'Class not found';
      if (userProfile == null) throw 'User not found';
      
      // Enroll in class
      await ClassService.enrollStudent(classId, userId, userProfile.name);
      
      // Update user progress for the course
      await ProgressService.createInitialProgress(userId, classInfo.courseId);
      
      // Send notification
      await NotificationService.sendTemplatedNotification(
        userId: userId,
        templateId: 'class_enrolled',
        data: {
          'classTitle': classInfo.title,
          'instructorName': classInfo.instructorName,
          'startDate': classInfo.startDate.toIso8601String(),
        },
      );
      
    } catch (e) {
      print('Error enrolling in class: $e');
      throw 'Failed to enroll in class';
    }
  }
  
  // ===== ANALYTICS & INSIGHTS =====
  
  // Get comprehensive user insights
  static Future<Map<String, dynamic>> getUserInsights(String userId) async {
    await _ensureInitialized();
    
    try {
      // Get or generate analytics
      LearningAnalytics? analytics = await AnalyticsService.getLatestAnalytics(userId);
      if (analytics == null) {
        analytics = await AnalyticsService.generateUserAnalytics(userId);
      }
      
      // Generate insights
      List<LearningInsight> insights = await AnalyticsService.generateInsights(userId);
      
      // Get recent reports
      List<LearningReport> reports = await AnalyticsService.getUserReports(userId);
      
      return {
        'analytics': analytics,
        'insights': insights,
        'reports': reports.take(3).toList(), // Last 3 reports
        'recommendations': analytics.recommendations,
        'strengths': analytics.strengths,
        'weaknesses': analytics.weaknesses,
      };
    } catch (e) {
      print('Error getting user insights: $e');
      throw 'Failed to get user insights';
    }
  }
  
  // ===== REAL-TIME FEATURES =====
  
  // Subscribe to user updates
  static dynamic getUserUpdates(String userId) {
    // Note: This would return a stream in a full implementation
    return null;
  }
  
  // ===== HEALTH & MONITORING =====
  
  // Get system health status
  static Future<Map<String, dynamic>> getSystemHealth() async {
    Map<String, dynamic> health = {
      'timestamp': DateTime.now().toIso8601String(),
      'overallStatus': 'healthy',
      'services': getServiceHealth(),
    };
    
    // Check if any critical services are down
    List<String> criticalServices = ['firebase', 'course', 'assignment', 'progress'];
    List<String> failedServices = criticalServices
        .where((service) => !isServiceHealthy(service))
        .toList();
    
    if (failedServices.isNotEmpty) {
      health['overallStatus'] = 'degraded';
      health['failedServices'] = failedServices;
    }
    
    return health;
  }
  
  // ===== PRIVATE HELPER METHODS =====
  
  static Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
  
  static Future<void> _testCourseService() async {
    try {
      await FirestoreCourseService.getAllCourses();
      _serviceHealth['course'] = true;
    } catch (e) {
      _serviceHealth['course'] = false;
    }
  }
  
  static Future<void> _testAssignmentService() async {
    try {
      await AssignmentService.getUpcomingAssignmentsForStudent('test_user');
      _serviceHealth['assignment'] = true;
    } catch (e) {
      _serviceHealth['assignment'] = false;
    }
  }
  
  static Future<void> _testProgressService() async {
    try {
      await ProgressService.getUserAllProgress('test_user');
      _serviceHealth['progress'] = true;
    } catch (e) {
      _serviceHealth['progress'] = false;
    }
  }
  
  static Future<void> _testNotificationService() async {
    try {
      await NotificationService.getUserNotifications('test_user', limit: 1);
      _serviceHealth['notification'] = true;
    } catch (e) {
      _serviceHealth['notification'] = false;
    }
  }
  
  static Future<void> _testForumService() async {
    try {
      await ForumService.getTrendingThreads('test_course');
      _serviceHealth['forum'] = true;
    } catch (e) {
      _serviceHealth['forum'] = false;
    }
  }
  
  static Future<void> _testClassService() async {
    try {
      await ClassService.getAllClasses(limit: 1);
      _serviceHealth['class'] = true;
    } catch (e) {
      _serviceHealth['class'] = false;
    }
  }
  
  static Future<void> _testAnalyticsService() async {
    try {
      await AnalyticsService.getLatestAnalytics('test_user');
      _serviceHealth['analytics'] = true;
    } catch (e) {
      _serviceHealth['analytics'] = false;
    }
  }
  
  static Future<void> _testRealtimeService() async {
    try {
      await RealtimeService.getRealtimeStatistics();
      _serviceHealth['realtime'] = true;
    } catch (e) {
      _serviceHealth['realtime'] = false;
    }
  }
  
  static Future<List<String>> _getEnrolledStudentIds(String courseId) async {
    // This would get enrolled students from class enrollments or progress data
    // For now, return empty list
    return [];
  }
}

// Extension to add copyWith method to AssignmentSubmission
extension AssignmentSubmissionCopy on AssignmentSubmission {
  AssignmentSubmission copyWith({
    String? id,
    String? assignmentId,
    String? studentId,
    List<String>? answers,
    int? score,
    int? maxScore,
    DateTime? submittedAt,
    DateTime? gradedAt,
    String? instructorFeedback,
    SubmissionStatus? status,
    int? attemptNumber,
  }) {
    return AssignmentSubmission(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      studentId: studentId ?? this.studentId,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      submittedAt: submittedAt ?? this.submittedAt,
      gradedAt: gradedAt ?? this.gradedAt,
      instructorFeedback: instructorFeedback ?? this.instructorFeedback,
      status: status ?? this.status,
      attemptNumber: attemptNumber ?? this.attemptNumber,
    );
  }
}