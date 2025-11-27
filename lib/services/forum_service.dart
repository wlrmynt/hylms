import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/forum.dart';

class ForumService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  static CollectionReference get threadsCollection => 
      _firestore.collection('discussion_threads');
  static CollectionReference get repliesCollection => 
      _firestore.collection('discussion_replies');
  
  // Create a new discussion thread
  static Future<String> createThread(DiscussionThread thread) async {
    try {
      DocumentReference doc = await threadsCollection.add(thread.toJson());
      return doc.id;
    } catch (e) {
      print('Error creating thread: $e');
      throw 'Failed to create thread';
    }
  }
  
  // Get threads by course
  static Future<List<DiscussionThread>> getThreadsByCourse(
    String courseId, {
    ThreadCategory? category,
    int limit = 20,
  }) async {
    try {
      Query query = threadsCollection
          .where('courseId', isEqualTo: courseId)
          .orderBy('isPinned', descending: true)
          .orderBy('updatedAt', descending: true)
          .limit(limit);
      
      if (category != null) {
        query = query.where('category', isEqualTo: category.toString().split('.').last);
      }
      
      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return DiscussionThread.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting threads by course: $e');
      return [];
    }
  }
  
  // Get thread by ID with replies
  static Future<DiscussionThread?> getThreadWithReplies(String threadId) async {
    try {
      DocumentSnapshot threadDoc = await threadsCollection.doc(threadId).get();
      
      if (!threadDoc.exists) return null;
      
      Map<String, dynamic> threadData = threadDoc.data() as Map<String, dynamic>;
      threadData['id'] = threadDoc.id;
      DiscussionThread thread = DiscussionThread.fromJson(threadData);
      
      // Increment view count
      await threadsCollection.doc(threadId).update({
        'views': FieldValue.increment(1),
      });
      
      return thread;
    } catch (e) {
      print('Error getting thread: $e');
      return null;
    }
  }
  
  // Get replies for a thread
  static Future<List<DiscussionReply>> getRepliesForThread(String threadId) async {
    try {
      QuerySnapshot snapshot = await repliesCollection
          .where('threadId', isEqualTo: threadId)
          .orderBy('createdAt')
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return DiscussionReply.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting replies for thread: $e');
      return [];
    }
  }
  
  // Add reply to thread
  static Future<String> addReply(DiscussionReply reply) async {
    try {
      // Add the reply
      DocumentReference doc = await repliesCollection.add(reply.toJson());
      
      // Update thread with reply count and last reply info
      await threadsCollection.doc(reply.threadId).update({
        'replies': FieldValue.increment(1),
        'lastReplyBy': reply.authorName,
        'lastReplyAt': Timestamp.fromDate(reply.createdAt),
        'updatedAt': Timestamp.fromDate(reply.createdAt),
      });
      
      return doc.id;
    } catch (e) {
      print('Error adding reply: $e');
      throw 'Failed to add reply';
    }
  }
  
  // Update thread
  static Future<void> updateThread(String threadId, DiscussionThread thread) async {
    try {
      Map<String, dynamic> updatedData = thread.toJson();
      updatedData['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await threadsCollection.doc(threadId).update(updatedData);
    } catch (e) {
      print('Error updating thread: $e');
      throw 'Failed to update thread';
    }
  }
  
  // Delete thread (soft delete)
  static Future<void> deleteThread(String threadId) async {
    try {
      await threadsCollection.doc(threadId).update({
        'content': '[Thread Deleted]',
        'isLocked': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error deleting thread: $e');
      throw 'Failed to delete thread';
    }
  }
  
  // Pin/unpin thread
  static Future<void> pinThread(String threadId, bool shouldPin) async {
    try {
      await threadsCollection.doc(threadId).update({
        'isPinned': shouldPin,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error pinning thread: $e');
      throw 'Failed to pin thread';
    }
  }
  
  // Lock/unlock thread
  static Future<void> lockThread(String threadId, bool shouldLock) async {
    try {
      await threadsCollection.doc(threadId).update({
        'isLocked': shouldLock,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error locking thread: $e');
      throw 'Failed to lock thread';
    }
  }
  
  // Vote on thread or reply
  static Future<void> vote({
    required String itemId,
    required bool isThread,
    required String userId,
    required int voteType, // 1 for upvote, -1 for downvote, 0 to remove vote
  }) async {
    try {
      CollectionReference collection = isThread ? threadsCollection : repliesCollection;
      
      // In a real application, you would track individual user votes
      // For now, we'll just update the counts
      if (voteType == 1) {
        await collection.doc(itemId).update({
          'upvotes': FieldValue.increment(1),
        });
      } else if (voteType == -1) {
        await collection.doc(itemId).update({
          'downvotes': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print('Error voting: $e');
      throw 'Failed to vote';
    }
  }
  
  // Search threads
  static Future<List<DiscussionThread>> searchThreads({
    required String query,
    String? courseId,
    ThreadCategory? category,
    int limit = 20,
  }) async {
    try {
      Query searchQuery = threadsCollection;
      
      if (courseId != null) {
        searchQuery = searchQuery.where('courseId', isEqualTo: courseId);
      }
      
      if (category != null) {
        searchQuery = searchQuery.where('category', isEqualTo: category.toString().split('.').last);
      }
      
      // Simple search by title (in a real app, you might use Algolia or similar)
      searchQuery = searchQuery
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + '\uf8ff')
          .orderBy('updatedAt', descending: true)
          .limit(limit);
      
      QuerySnapshot snapshot = await searchQuery.get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return DiscussionThread.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error searching threads: $e');
      return [];
    }
  }
  
  // Get trending threads
  static Future<List<DiscussionThread>> getTrendingThreads(String courseId) async {
    try {
      QuerySnapshot snapshot = await threadsCollection
          .where('courseId', isEqualTo: courseId)
          .orderBy('views', descending: true)
          .orderBy('updatedAt', descending: true)
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return DiscussionThread.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting trending threads: $e');
      return [];
    }
  }
  
  // Get forum statistics
  static Future<ForumStatistics> getForumStatistics(String courseId) async {
    try {
      // Get total threads
      QuerySnapshot threadsSnapshot = await threadsCollection
          .where('courseId', isEqualTo: courseId)
          .get();
      
      int totalThreads = threadsSnapshot.docs.length;
      
      // Get total replies
      QuerySnapshot repliesSnapshot = await repliesCollection
          .where('threadId', whereIn: threadsSnapshot.docs.map((doc) => doc.id).take(10).toList())
          .get();
      
      int totalReplies = repliesSnapshot.docs.length;
      
      // Get threads this week
      DateTime weekStart = DateTime.now().subtract(const Duration(days: 7));
      QuerySnapshot weekThreadsSnapshot = await threadsCollection
          .where('courseId', isEqualTo: courseId)
          .where('createdAt', isGreaterThan: Timestamp.fromDate(weekStart))
          .get();
      
      int threadsThisWeek = weekThreadsSnapshot.docs.length;
      
      // Get threads this month
      DateTime monthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
      QuerySnapshot monthThreadsSnapshot = await threadsCollection
          .where('courseId', isEqualTo: courseId)
          .where('createdAt', isGreaterThan: Timestamp.fromDate(monthStart))
          .get();
      
      int threadsThisMonth = monthThreadsSnapshot.docs.length;
      
      // Count by category
      Map<String, int> threadsByCategory = {};
      Map<String, int> threadsByPriority = {};
      
      for (DocumentSnapshot doc in threadsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String category = data['category'] ?? 'general';
        String priority = data['priority'] ?? 'normal';
        
        threadsByCategory[category] = (threadsByCategory[category] ?? 0) + 1;
        threadsByPriority[priority] = (threadsByPriority[priority] ?? 0) + 1;
      }
      
      return ForumStatistics(
        totalThreads: totalThreads,
        totalReplies: totalReplies,
        activeUsers: _estimateActiveUsers(threadsSnapshot.docs, repliesSnapshot.docs),
        threadsThisWeek: threadsThisWeek,
        threadsThisMonth: threadsThisMonth,
        threadsByCategory: threadsByCategory,
        threadsByPriority: threadsByPriority,
      );
    } catch (e) {
      print('Error getting forum statistics: $e');
      return ForumStatistics(
        totalThreads: 0,
        totalReplies: 0,
        activeUsers: 0,
        threadsThisWeek: 0,
        threadsThisMonth: 0,
        threadsByCategory: {},
        threadsByPriority: {},
      );
    }
  }
  
  // Stream threads for real-time updates
  static Stream<List<DiscussionThread>> streamThreadsByCourse(String courseId) {
    return threadsCollection
        .where('courseId', isEqualTo: courseId)
        .orderBy('isPinned', descending: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return DiscussionThread.fromJson(data);
      }).toList();
    });
  }
  
  // Stream replies for a thread
  static Stream<List<DiscussionReply>> streamRepliesForThread(String threadId) {
    return repliesCollection
        .where('threadId', isEqualTo: threadId)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return DiscussionReply.fromJson(data);
      }).toList();
    });
  }
  
  // Seed sample forum data
  static Future<void> seedSampleForumData(List<String> courseIds) async {
    try {
      // Check if forum data already exists
      QuerySnapshot existing = await threadsCollection.limit(1).get();
      if (existing.docs.isNotEmpty) {
        return; // Already seeded
      }
      
      List<DiscussionThread> sampleThreads = [];
      
      for (String courseId in courseIds.take(3)) {
        sampleThreads.add(DiscussionThread(
          id: '',
          title: 'Welcome to this course!',
          content: 'Feel free to ask questions and share your thoughts about the course material.',
          courseId: courseId,
          authorId: 'instructor_1',
          authorName: 'Course Instructor',
          authorRole: 'Dosen',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
          category: ThreadCategory.announcement,
          priority: ThreadPriority.high,
          views: 45,
          replies: 8,
          isPinned: true,
          isLocked: false,
          tags: ['welcome', 'announcement'],
          lastReplyBy: 'student_1',
          lastReplyAt: DateTime.now().subtract(const Duration(days: 2)),
          upvotes: 12,
          downvotes: 0,
        ));
        
        sampleThreads.add(DiscussionThread(
          id: '',
          title: 'Question about Assignment 1',
          content: 'I\'m having trouble understanding the requirements for the first assignment. Can someone help clarify?',
          courseId: courseId,
          authorId: 'student_1',
          authorName: 'John Doe',
          authorRole: 'Mahasiswa',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
          category: ThreadCategory.question,
          priority: ThreadPriority.normal,
          views: 23,
          replies: 3,
          isPinned: false,
          isLocked: false,
          tags: ['assignment', 'question', 'help'],
          lastReplyBy: 'instructor_1',
          lastReplyAt: DateTime.now().subtract(const Duration(hours: 5)),
          upvotes: 5,
          downvotes: 0,
        ));
      }
      
      // Create threads
      for (DiscussionThread thread in sampleThreads) {
        String threadId = await createThread(thread);
        
        // Add some sample replies
        List<DiscussionReply> sampleReplies = [
          DiscussionReply(
            id: '',
            threadId: threadId,
            content: 'Thank you for asking! I\'ll clarify this in the next lecture.',
            authorId: 'instructor_1',
            authorName: 'Course Instructor',
            authorRole: 'Dosen',
            createdAt: thread.createdAt.add(const Duration(hours: 2)),
            updatedAt: thread.createdAt.add(const Duration(hours: 2)),
            mentionedUsers: ['student_1'],
            upvotes: 3,
            downvotes: 0,
            isInstructorResponse: true,
          ),
          DiscussionReply(
            id: '',
            threadId: threadId,
            content: 'Thanks! I was wondering the same thing.',
            authorId: 'student_2',
            authorName: 'Jane Smith',
            authorRole: 'Mahasiswa',
            createdAt: thread.createdAt.add(const Duration(hours: 4)),
            updatedAt: thread.createdAt.add(const Duration(hours: 4)),
            mentionedUsers: [],
            upvotes: 1,
            downvotes: 0,
            isInstructorResponse: false,
          ),
        ];
        
        for (DiscussionReply reply in sampleReplies) {
          await addReply(reply);
        }
      }
      
      print('Sample forum data seeded successfully');
    } catch (e) {
      print('Error seeding sample forum data: $e');
    }
  }
  
  // Helper method to estimate active users
  static int _estimateActiveUsers(List<DocumentSnapshot> threadDocs, List<DocumentSnapshot> replyDocs) {
    Set<String> uniqueUsers = {};
    
    for (DocumentSnapshot doc in threadDocs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      uniqueUsers.add(data['authorId'] ?? '');
    }
    
    for (DocumentSnapshot doc in replyDocs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      uniqueUsers.add(data['authorId'] ?? '');
    }
    
    return uniqueUsers.length;
  }
}