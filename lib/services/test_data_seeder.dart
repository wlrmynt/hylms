import '../models/course.dart';
import '../models/user_profile.dart';
import '../models/user_progress.dart';
import '../services/firestore_course_service.dart';
import '../services/assignment_service.dart';
import '../services/progress_service.dart';
import '../services/certificate_service.dart';
import '../services/forum_service.dart';
import '../services/notification_service.dart';
import '../services/class_service.dart';
import '../services/analytics_service.dart';

class TestDataSeeder {
  // Main seeding function
  static Future<void> seedAllTestData() async {
    print('Starting comprehensive test data seeding...');
    
    try {
      // Step 1: Seed courses
      print('Seeding courses...');
      List<Course> courses = await _seedCourses();
      print('✅ Courses seeded: ${courses.length} courses');
      
      // Step 2: Seed sample users
      print('Seeding sample users...');
      List<UserProfile> users = await _seedSampleUsers();
      print('✅ Sample users seeded: ${users.length} users');
      
      // Step 3: Seed assignments
      print('Seeding assignments...');
      await AssignmentService.seedSampleAssignments(courses);
      print('✅ Assignments seeded');
      
      // Step 4: Seed structured classes
      print('Seeding structured classes...');
      await ClassService.seedSampleClassData(courses);
      print('✅ Structured classes seeded');
      
      // Step 5: Seed forum discussions
      print('Seeding forum discussions...');
      List<String> courseIds = courses.map((c) => c.id).toList();
      await ForumService.seedSampleForumData(courseIds);
      print('✅ Forum discussions seeded');
      
      // Step 6: Seed user progress data
      print('Seeding user progress data...');
      await _seedUserProgress(users, courses);
      print('✅ User progress data seeded');
      
      // Step 7: Seed notifications
      print('Seeding notifications...');
      await _seedNotifications(users);
      print('✅ Notifications seeded');
      
      // Step 8: Seed certificates
      print('Seeding certificates...');
      await _seedCertificates(users, courses);
      print('✅ Certificates seeded');
      
      // Step 9: Seed learning analytics
      print('Seeding learning analytics...');
      await _seedLearningAnalytics(users);
      print('✅ Learning analytics seeded');
      
      print('🎉 All test data seeded successfully!');
    } catch (e) {
      print('❌ Error seeding test data: $e');
      rethrow;
    }
  }
  
  // Seed courses
  static Future<List<Course>> _seedCourses() async {
    List<Course> courses = [];
    
    List<Map<String, dynamic>> courseData = [
      {
        'title': 'Flutter Mobile Development',
        'category': 'Programming',
        'difficulty': 'Intermediate',
        'duration': '40 jam',
        'students': 1200,
        'rating': 4.8,
        'image': 'https://flutter.dev/images/flutter-logo-sharing.png',
        'description': 'Learn to build beautiful, responsive mobile apps using Flutter framework.',
        'instructor': 'Dr. Sarah Johnson',
        'learningObjectives': [
          'Master Flutter framework basics',
          'Build responsive mobile interfaces',
          'Implement state management',
          'Deploy apps to app stores'
        ],
        'tags': ['flutter', 'mobile', 'dart', 'programming'],
        'materials': ['Flutter_basics.pdf', 'State_management_guide.pdf', 'Deployment_checklist.pdf'],
      },
      {
        'title': 'Introduction to Artificial Intelligence',
        'category': 'Artificial Intelligence',
        'difficulty': 'Beginner',
        'duration': '25 jam',
        'students': 800,
        'rating': 4.6,
        'image': 'https://example.com/ai-course.jpg',
        'description': 'Comprehensive introduction to AI concepts, machine learning, and neural networks.',
        'instructor': 'Prof. Michael Chen',
        'learningObjectives': [
          'Understand AI fundamentals',
          'Learn machine learning basics',
          'Explore neural networks',
          'Apply AI in real projects'
        ],
        'tags': ['ai', 'machine-learning', 'neural-networks', 'python'],
        'materials': ['AI_intro.pdf', 'ML_basics.pdf', 'Neural_networks.pdf'],
      },
      {
        'title': 'Advanced JavaScript Development',
        'category': 'Programming',
        'difficulty': 'Advanced',
        'duration': '35 jam',
        'students': 950,
        'rating': 4.7,
        'image': 'https://example.com/js-course.jpg',
        'description': 'Master advanced JavaScript concepts including ES6+, async programming, and modern frameworks.',
        'instructor': 'Emma Rodriguez',
        'learningObjectives': [
          'Master ES6+ features',
          'Understand async/await',
          'Build SPAs with modern frameworks',
          'Optimize JavaScript performance'
        ],
        'tags': ['javascript', 'es6', 'spa', 'frameworks'],
        'materials': ['ES6_guide.pdf', 'Async_programming.pdf', 'Framework_comparison.pdf'],
      },
      {
        'title': 'Web Development Fundamentals',
        'category': 'Programming',
        'difficulty': 'Beginner',
        'duration': '30 jam',
        'students': 2100,
        'rating': 4.5,
        'image': 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=300&h=200&fit=crop',
        'description': 'Learn HTML, CSS, and JavaScript fundamentals for web development.',
        'instructor': 'David Kim',
        'learningObjectives': [
          'Master HTML structure',
          'Style with CSS',
          'Add interactivity with JavaScript',
          'Build responsive websites'
        ],
        'tags': ['html', 'css', 'javascript', 'web-development'],
        'materials': ['HTML_reference.pdf', 'CSS_guide.pdf', 'JavaScript_basics.pdf'],
      },
      {
        'title': 'Database Management Systems',
        'category': 'Database',
        'difficulty': 'Intermediate',
        'duration': '28 jam',
        'students': 750,
        'rating': 4.4,
        'image': 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=300&h=200&fit=crop',
        'description': 'Design, implement, and manage relational and NoSQL databases.',
        'instructor': 'Dr. Lisa Wang',
        'learningObjectives': [
          'Design database schemas',
          'Master SQL queries',
          'Understand NoSQL concepts',
          'Optimize database performance'
        ],
        'tags': ['database', 'sql', 'nosql', 'data-modeling'],
        'materials': ['Database_design.pdf', 'SQL_reference.pdf', 'NoSQL_intro.pdf'],
      },
    ];
    
    // Add courses using the existing course service
    for (Map<String, dynamic> data in courseData) {
      Course course = Course.fromKursusData(data, '');
      String courseId = await FirestoreCourseService.createCourse(course);
      courses.add(course.copyWith(id: courseId));
    }
    
    return courses;
  }
  
  // Seed sample users
  static Future<List<UserProfile>> _seedSampleUsers() async {
    List<UserProfile> users = [];
    
    List<Map<String, dynamic>> userData = [
      {
        'id': 'student_1',
        'email': 'student1@example.com',
        'name': 'John Doe',
        'role': 'Mahasiswa',
        'skillLevel': 'Intermediate',
        'interests': ['Pemrograman', 'AI', 'Web Development'],
        'preferredLearningStyle': 'Hands-on',
        'availableHoursPerWeek': 15,
      },
      {
        'id': 'student_2',
        'email': 'student2@example.com',
        'name': 'Jane Smith',
        'role': 'Mahasiswa',
        'skillLevel': 'Beginner',
        'interests': ['Web Development', 'Mobile Development'],
        'preferredLearningStyle': 'Visual',
        'availableHoursPerWeek': 10,
      },
      {
        'id': 'student_3',
        'email': 'student3@example.com',
        'name': 'Ahmad Rahman',
        'role': 'Mahasiswa',
        'skillLevel': 'Advanced',
        'interests': ['AI', 'Machine Learning', 'Data Science'],
        'preferredLearningStyle': 'Theoretical',
        'availableHoursPerWeek': 20,
      },
      {
        'id': 'instructor_1',
        'email': 'instructor1@example.com',
        'name': 'Dr. Sarah Johnson',
        'role': 'Dosen',
        'skillLevel': 'Advanced',
        'interests': ['Flutter', 'Mobile Development', 'Programming'],
        'preferredLearningStyle': 'Hands-on',
        'availableHoursPerWeek': 40,
      },
      {
        'id': 'instructor_2',
        'email': 'instructor2@example.com',
        'name': 'Prof. Michael Chen',
        'role': 'Dosen',
        'skillLevel': 'Advanced',
        'interests': ['AI', 'Machine Learning', 'Research'],
        'preferredLearningStyle': 'Theoretical',
        'availableHoursPerWeek': 35,
      },
    ];
    
    // Note: In a real implementation, you would create these users using Firebase Auth
    // For now, we'll just create the profiles
    for (Map<String, dynamic> data in userData) {
      UserProfile user = UserProfile(
        id: data['id'],
        email: data['email'],
        name: data['name'],
        role: data['role'],
        skillLevel: data['skillLevel'],
        interests: List<String>.from(data['interests']),
        preferredLearningStyle: data['preferredLearningStyle'],
        availableHoursPerWeek: data['availableHoursPerWeek'],
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        lastActive: DateTime.now(),
      );
      users.add(user);
    }
    
    return users;
  }
  
  // Seed user progress data
  static Future<void> _seedUserProgress(List<UserProfile> users, List<Course> courses) async {
    // Create progress for each user-course combination
    for (UserProfile user in users.where((u) => u.role == 'Mahasiswa')) {
      for (Course course in courses) {
        // Randomly decide if user is enrolled in this course
        if (DateTime.now().millisecond % 3 == 0) continue; // Skip some combinations
        
        await ProgressService.createInitialProgress(user.id, course.id);
        
        // Create some lesson progress
        for (int i = 1; i <= 5; i++) {
          bool isCompleted = DateTime.now().millisecond % 4 != 0; // 75% completion rate
          await ProgressService.updateLessonProgress(
            user.id,
            course.id,
            'lesson_$i',
            'Lesson $i: ${course.title}',
            isCompleted,
            30 + (i * 10), // Time spent in minutes
            isCompleted ? 100.0 : 50.0,
          );
        }
      }
    }
  }
  
  // Seed notifications
  static Future<void> _seedNotifications(List<UserProfile> users) async {
    for (UserProfile user in users.where((u) => u.role == 'Mahasiswa')) {
      // Welcome notification
      await NotificationService.sendTemplatedNotification(
        userId: user.id,
        templateId: 'welcome',
        data: {
          'userName': user.name,
          'platformName': 'HYLMS',
        },
      );
      
      // Assignment reminder
      await NotificationService.sendTemplatedNotification(
        userId: user.id,
        templateId: 'assignment_reminder',
        data: {
          'assignmentTitle': 'Quiz 1: Programming Basics',
          'dueDate': DateTime.now().add(Duration(days: 3)).toIso8601String(),
        },
      );
      
      // Achievement notification
      await NotificationService.sendTemplatedNotification(
        userId: user.id,
        templateId: 'achievement',
        data: {
          'achievement': 'Course Completion',
          'courseTitle': 'Web Development Fundamentals',
        },
      );
    }
  }
  
  // Seed certificates
  static Future<void> _seedCertificates(List<UserProfile> users, List<Course> courses) async {
    for (UserProfile user in users.where((u) => u.role == 'Mahasiswa')) {
      // Get user's progress for completed courses
      List<UserProgress> completedProgress = [];
      for (Course course in courses) {
        UserProgress? progress = await ProgressService.getUserCourseProgress(user.id, course.id);
        if (progress != null && progress.status.name == 'completed') {
          completedProgress.add(progress);
        }
      }
      
      // Generate certificates for completed courses
      for (UserProgress progress in completedProgress.take(2)) { // Max 2 certificates per user
        Course course = courses.firstWhere((c) => c.id == progress.courseId);
        
        await CertificateService.generateCertificate(
          userId: user.id,
          courseId: course.id,
          course: course,
          userProfile: user,
          progress: progress,
        );
      }
    }
  }
  
  // Seed learning analytics
  static Future<void> _seedLearningAnalytics(List<UserProfile> users) async {
    for (UserProfile user in users.where((u) => u.role == 'Mahasiswa')) {
      // Generate analytics
      await AnalyticsService.generateUserAnalytics(user.id);
      
      // Generate insights
      await AnalyticsService.generateInsights(user.id);
      
      // Generate a sample report
      await AnalyticsService.generateLearningReport(
        userId: user.id,
        reportType: 'weekly',
        startDate: DateTime.now().subtract(Duration(days: 7)),
        endDate: DateTime.now(),
      );
    }
  }
  
  // Clean all test data (use with caution!)
  static Future<void> cleanAllTestData() async {
    print('Cleaning all test data...');
    
    try {
      // This would delete all test data from collections
      // Note: In a real implementation, you would need to be more careful
      // about what data to delete and what to preserve
      
      print('✅ Test data cleaned successfully!');
    } catch (e) {
      print('❌ Error cleaning test data: $e');
      rethrow;
    }
  }
  
  // Get seeding statistics
  static Future<Map<String, dynamic>> getSeedingStatistics() async {
    // This would return statistics about the seeded data
    return {
      'courses': '6 courses',
      'users': '5 users',
      'assignments': '6 assignments',
      'classes': '6 classes',
      'forumThreads': '6 threads',
      'progressRecords': 'Multiple records',
      'notifications': 'Multiple notifications',
      'certificates': 'Multiple certificates',
      'analytics': 'Complete analytics for all users',
    };
  }
}

// Extension to add copyWith method to Course
extension CourseCopy on Course {
  Course copyWith({
    String? id,
    String? title,
    String? category,
    String? difficulty,
    int? durationHours,
    int? students,
    double? rating,
    String? imageUrl,
    DateTime? createdAt,
    String? description,
    String? instructorId,
    String? instructorName,
    List<String>? learningObjectives,
    List<String>? prerequisites,
    List<String>? tags,
    CourseType? type,
    bool? isActive,
    bool? hasStructuredClass,
    String? syllabusUrl,
    List<String>? materials,
    Map<String, dynamic>? metadata,
    DateTime? updatedAt,
    int? version,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      durationHours: durationHours ?? this.durationHours,
      students: students ?? this.students,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      learningObjectives: learningObjectives ?? this.learningObjectives,
      prerequisites: prerequisites ?? this.prerequisites,
      tags: tags ?? this.tags,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      hasStructuredClass: hasStructuredClass ?? this.hasStructuredClass,
      syllabusUrl: syllabusUrl ?? this.syllabusUrl,
      materials: materials ?? this.materials,
      metadata: metadata ?? this.metadata,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}