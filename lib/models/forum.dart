import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionThread {
  final String id;
  final String title;
  final String content;
  final String courseId;
  final String authorId;
  final String authorName;
  final String authorRole; // Mahasiswa, Dosen, Admin
  final DateTime createdAt;
  final DateTime updatedAt;
  final ThreadCategory category;
  final ThreadPriority priority;
  final int views;
  final int replies;
  final bool isPinned;
  final bool isLocked;
  final List<String> tags;
  final String? lastReplyBy;
  final DateTime? lastReplyAt;
  final int upvotes;
  final int downvotes;
  
  DiscussionThread({
    required this.id,
    required this.title,
    required this.content,
    required this.courseId,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.priority,
    required this.views,
    required this.replies,
    this.isPinned = false,
    this.isLocked = false,
    required this.tags,
    this.lastReplyBy,
    this.lastReplyAt,
    required this.upvotes,
    required this.downvotes,
  });
  
  factory DiscussionThread.fromJson(Map<String, dynamic> json) {
    return DiscussionThread(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      courseId: json['courseId'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorRole: json['authorRole'] ?? 'Mahasiswa',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      category: ThreadCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => ThreadCategory.general,
      ),
      priority: ThreadPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => ThreadPriority.normal,
      ),
      views: json['views'] ?? 0,
      replies: json['replies'] ?? 0,
      isPinned: json['isPinned'] ?? false,
      isLocked: json['isLocked'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      lastReplyBy: json['lastReplyBy'],
      lastReplyAt: json['lastReplyAt'] != null 
          ? (json['lastReplyAt'] as Timestamp).toDate()
          : null,
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'courseId': courseId,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'category': category.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'views': views,
      'replies': replies,
      'isPinned': isPinned,
      'isLocked': isLocked,
      'tags': tags,
      'lastReplyBy': lastReplyBy,
      'lastReplyAt': lastReplyAt != null 
          ? Timestamp.fromDate(lastReplyAt!)
          : null,
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }
}

class DiscussionReply {
  final String id;
  final String threadId;
  final String content;
  final String authorId;
  final String authorName;
  final String authorRole;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? parentReplyId; // For nested replies
  final List<String> mentionedUsers;
  final int upvotes;
  final int downvotes;
  final bool isInstructorResponse;
  
  DiscussionReply({
    required this.id,
    required this.threadId,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.createdAt,
    required this.updatedAt,
    this.parentReplyId,
    required this.mentionedUsers,
    required this.upvotes,
    required this.downvotes,
    this.isInstructorResponse = false,
  });
  
  factory DiscussionReply.fromJson(Map<String, dynamic> json) {
    return DiscussionReply(
      id: json['id'] ?? '',
      threadId: json['threadId'] ?? '',
      content: json['content'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorRole: json['authorRole'] ?? 'Mahasiswa',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      parentReplyId: json['parentReplyId'],
      mentionedUsers: List<String>.from(json['mentionedUsers'] ?? []),
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
      isInstructorResponse: json['isInstructorResponse'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'threadId': threadId,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'parentReplyId': parentReplyId,
      'mentionedUsers': mentionedUsers,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'isInstructorResponse': isInstructorResponse,
    };
  }
}

enum ThreadCategory {
  general,
  question,
  announcement,
  assignment,
  technical,
  feedback,
  studyGroup,
}

enum ThreadPriority {
  low,
  normal,
  high,
  urgent,
}

class ForumStatistics {
  final int totalThreads;
  final int totalReplies;
  final int activeUsers;
  final int threadsThisWeek;
  final int threadsThisMonth;
  final Map<String, int> threadsByCategory;
  final Map<String, int> threadsByPriority;
  
  ForumStatistics({
    required this.totalThreads,
    required this.totalReplies,
    required this.activeUsers,
    required this.threadsThisWeek,
    required this.threadsThisMonth,
    required this.threadsByCategory,
    required this.threadsByPriority,
  });
  
  factory ForumStatistics.fromJson(Map<String, dynamic> json) {
    return ForumStatistics(
      totalThreads: json['totalThreads'] ?? 0,
      totalReplies: json['totalReplies'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
      threadsThisWeek: json['threadsThisWeek'] ?? 0,
      threadsThisMonth: json['threadsThisMonth'] ?? 0,
      threadsByCategory: Map<String, int>.from(json['threadsByCategory'] ?? {}),
      threadsByPriority: Map<String, int>.from(json['threadsByPriority'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'totalThreads': totalThreads,
      'totalReplies': totalReplies,
      'activeUsers': activeUsers,
      'threadsThisWeek': threadsThisWeek,
      'threadsThisMonth': threadsThisMonth,
      'threadsByCategory': threadsByCategory,
      'threadsByPriority': threadsByPriority,
    };
  }
}