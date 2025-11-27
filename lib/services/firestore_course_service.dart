import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class FirestoreCourseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference
  static CollectionReference get coursesCollection => 
      _firestore.collection('courses');

  // Create a new course
  static Future<String> createCourse(Course course) async {
    try {
      DocumentReference doc = await coursesCollection.add(course.toJson());
      return doc.id;
    } catch (e) {
      print('Error creating course: $e');
      throw 'Failed to create course';
    }
  }

  // Get all courses
  static Future<List<Course>> getAllCourses() async {
    try {
      QuerySnapshot snapshot = await coursesCollection
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID to the data
        return Course.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting courses: $e');
      return [];
    }
  }

  // Get courses by category
  static Future<List<Course>> getCoursesByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await coursesCollection
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting courses by category: $e');
      return [];
    }
  }

  // Get courses by difficulty
  static Future<List<Course>> getCoursesByDifficulty(String difficulty) async {
    try {
      QuerySnapshot snapshot = await coursesCollection
          .where('difficulty', isEqualTo: difficulty)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting courses by difficulty: $e');
      return [];
    }
  }

  // Get course by ID
  static Future<Course?> getCourseById(String courseId) async {
    try {
      DocumentSnapshot doc = await coursesCollection.doc(courseId).get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }
    } catch (e) {
      print('Error getting course by ID: $e');
    }
    return null;
  }

  // Update course
  static Future<void> updateCourse(String courseId, Course course) async {
    try {
      await coursesCollection.doc(courseId).update(course.toJson());
    } catch (e) {
      print('Error updating course: $e');
      throw 'Failed to update course';
    }
  }

  // Delete course
  static Future<void> deleteCourse(String courseId) async {
    try {
      await coursesCollection.doc(courseId).delete();
    } catch (e) {
      print('Error deleting course: $e');
      throw 'Failed to delete course';
    }
  }

  // Search courses
  static Future<List<Course>> searchCourses(String query) async {
    try {
      QuerySnapshot snapshot = await coursesCollection
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + '\uf8ff')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error searching courses: $e');
      return [];
    }
  }

  // Stream courses for real-time updates
  static Stream<List<Course>> streamAllCourses() {
    return coursesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }).toList();
    });
  }

  // Stream courses by category for real-time updates
  static Stream<List<Course>> streamCoursesByCategory(String category) {
    return coursesCollection
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Course.fromJson(data);
      }).toList();
    });
  }

  // Seed sample courses (for development)
  static Future<void> seedSampleCourses() async {
    try {
      // Check if courses already exist
      QuerySnapshot existing = await coursesCollection.limit(1).get();
      if (existing.docs.isNotEmpty) {
        return; // Already seeded
      }

      List<Course> sampleCourses = [
        Course(
          id: '1',
          title: 'Flutter Mobile Development',
          category: 'Programming',
          difficulty: 'Intermediate',
          durationHours: 40,
          students: 1200,
          rating: 4.8,
          imageUrl: 'https://flutter.dev/images/flutter-logo-sharing.png',
          createdAt: DateTime.now(),
        ),
        Course(
          id: '2',
          title: 'Introduction to AI',
          category: 'Artificial Intelligence',
          difficulty: 'Beginner',
          durationHours: 25,
          students: 800,
          rating: 4.6,
          imageUrl: 'https://example.com/ai-course.jpg',
          createdAt: DateTime.now(),
        ),
        Course(
          id: '3',
          title: 'Advanced JavaScript',
          category: 'Programming',
          difficulty: 'Advanced',
          durationHours: 35,
          students: 950,
          rating: 4.7,
          imageUrl: 'https://example.com/js-course.jpg',
          createdAt: DateTime.now(),
        ),
      ];

      for (Course course in sampleCourses) {
        await createCourse(course);
      }

      print('Sample courses seeded successfully');
    } catch (e) {
      print('Error seeding sample courses: $e');
    }
  }
}