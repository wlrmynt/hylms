import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  static CollectionReference get notificationsCollection => 
      _firestore.collection('notifications');
  static CollectionReference get preferencesCollection => 
      _firestore.collection('notification_preferences');
  static CollectionReference get templatesCollection => 
      _firestore.collection('notification_templates');
  
  // Send a notification to a user
  static Future<String> sendNotification(Notification notification) async {
    try {
      // Check user preferences
      NotificationPreferences? preferences = await getUserPreferences(notification.userId);
      if (preferences == null) {
        // Create default preferences if not exist
        preferences = NotificationPreferences.defaultPreferences(notification.userId);
        await saveUserPreferences(preferences);
      }
      
      // Check if notification should be sent based on preferences
      bool shouldSend = false;
      for (String channel in notification.channels) {
        if (preferences.shouldSendNotification(notification, channel)) {
          shouldSend = true;
          break;
        }
      }
      
      if (!shouldSend) {
        print('Notification not sent due to user preferences');
        return '';
      }
      
      // Check if notification is expired
      if (notification.isExpired) {
        print('Notification not sent due to expiry');
        return '';
      }
      
      DocumentReference doc = await notificationsCollection.add(notification.toJson());
      return doc.id;
    } catch (e) {
      print('Error sending notification: $e');
      throw 'Failed to send notification';
    }
  }
  
  // Get notifications for a user
  static Future<List<Notification>> getUserNotifications(
    String userId, {
    bool includeRead = false,
    int limit = 50,
    NotificationType? type,
  }) async {
    try {
      Query query = notificationsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit);
      
      if (!includeRead) {
        query = query.where('isRead', isEqualTo: false);
      }
      
      if (type != null) {
        query = query.where('type', isEqualTo: type.toString().split('.').last);
      }
      
      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Notification.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting user notifications: $e');
      return [];
    }
  }
  
  // Get unread notification count
  static Future<int> getUnreadCount(String userId) async {
    try {
      QuerySnapshot snapshot = await notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }
  
  // Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    try {
      await notificationsCollection.doc(notificationId).update({
        'isRead': true,
        'readAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error marking notification as read: $e');
      throw 'Failed to mark notification as read';
    }
  }
  
  // Mark all notifications as read for a user
  static Future<void> markAllAsRead(String userId) async {
    try {
      QuerySnapshot snapshot = await notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      
      WriteBatch batch = _firestore.batch();
      
      for (DocumentSnapshot doc in snapshot.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'readAt': Timestamp.fromDate(DateTime.now()),
        });
      }
      
      await batch.commit();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      throw 'Failed to mark all notifications as read';
    }
  }
  
  // Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      await notificationsCollection.doc(notificationId).delete();
    } catch (e) {
      print('Error deleting notification: $e');
      throw 'Failed to delete notification';
    }
  }
  
  // Get user notification preferences
  static Future<NotificationPreferences?> getUserPreferences(String userId) async {
    try {
      DocumentSnapshot doc = await preferencesCollection.doc(userId).get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['userId'] = userId;
        return NotificationPreferences.fromJson(data);
      }
    } catch (e) {
      print('Error getting user preferences: $e');
    }
    return null;
  }
  
  // Save user notification preferences
  static Future<void> saveUserPreferences(NotificationPreferences preferences) async {
    try {
      Map<String, dynamic> preferencesData = preferences.toJson();
      preferencesData['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await preferencesCollection.doc(preferences.userId).set(preferencesData);
    } catch (e) {
      print('Error saving user preferences: $e');
      throw 'Failed to save user preferences';
    }
  }
  
  // Send bulk notifications
  static Future<void> sendBulkNotifications({
    required List<String> userIds,
    required Notification notification,
  }) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (String userId in userIds) {
        // Check user preferences
        NotificationPreferences? preferences = await getUserPreferences(userId);
        if (preferences == null) {
          preferences = NotificationPreferences.defaultPreferences(userId);
          await saveUserPreferences(preferences);
        }
        
        // Check if notification should be sent
        bool shouldSend = false;
        for (String channel in notification.channels) {
          if (preferences.shouldSendNotification(notification, channel)) {
            shouldSend = true;
            break;
          }
        }
        
        if (shouldSend) {
          DocumentReference doc = notificationsCollection.doc();
          batch.set(doc, notification.copyWith(userId: userId).toJson());
        }
      }
      
      await batch.commit();
    } catch (e) {
      print('Error sending bulk notifications: $e');
      throw 'Failed to send bulk notifications';
    }
  }
  
  // Create notification template
  static Future<String> createTemplate(NotificationTemplate template) async {
    try {
      DocumentReference doc = await templatesCollection.add(template.toJson());
      return doc.id;
    } catch (e) {
      print('Error creating notification template: $e');
      throw 'Failed to create notification template';
    }
  }
  
  // Get notification template
  static Future<NotificationTemplate?> getTemplate(String templateId) async {
    try {
      DocumentSnapshot doc = await templatesCollection.doc(templateId).get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return NotificationTemplate.fromJson(data);
      }
    } catch (e) {
      print('Error getting notification template: $e');
    }
    return null;
  }
  
  // Send notification using template
  static Future<String> sendTemplatedNotification({
    required String userId,
    required String templateId,
    required Map<String, dynamic> data,
    String? locale = 'id',
  }) async {
    try {
      NotificationTemplate? template = await getTemplate(templateId);
      if (template == null) {
        throw 'Template not found';
      }
      
      // Replace placeholders in templates
      String title = _replacePlaceholders(
        template.titleTemplates[locale] ?? template.titleTemplates['id'] ?? '',
        data,
      );
      
      String message = _replacePlaceholders(
        template.messageTemplates[locale] ?? template.messageTemplates['id'] ?? '',
        data,
      );
      
      Notification notification = Notification(
        id: '',
        userId: userId,
        title: title,
        message: message,
        type: template.type,
        priority: template.defaultPriority,
        relatedType: template.name,
        data: {...template.defaultData, ...data},
        createdAt: DateTime.now(),
        channels: template.channels,
        senderId: 'system',
        senderName: 'System',
      );
      
      return await sendNotification(notification);
    } catch (e) {
      print('Error sending templated notification: $e');
      throw 'Failed to send templated notification';
    }
  }
  
  // Stream notifications for real-time updates
  static Stream<List<Notification>> streamUserNotifications(String userId) {
    return notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Notification.fromJson(data);
      }).toList();
    });
  }
  
  // Clean up expired notifications
  static Future<void> cleanupExpiredNotifications() async {
    try {
      QuerySnapshot snapshot = await notificationsCollection
          .where('expiryAt', isLessThan: Timestamp.fromDate(DateTime.now()))
          .get();
      
      WriteBatch batch = _firestore.batch();
      
      for (DocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      print('Error cleaning up expired notifications: $e');
    }
  }
  
  // Helper methods
  static String _replacePlaceholders(String template, Map<String, dynamic> data) {
    String result = template;
    
    data.forEach((key, value) {
      String placeholder = '{$key}';
      result = result.replaceAll(placeholder, value.toString());
    });
    
    return result;
  }
}

// Extension to add copyWith method to Notification
extension NotificationCopy on Notification {
  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    String? actionUrl,
    String? relatedId,
    String? relatedType,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? readAt,
    bool? isRead,
    String? iconUrl,
    String? imageUrl,
    String? sound,
    List<String>? channels,
    DateTime? expiryAt,
    String? senderId,
    String? senderName,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      actionUrl: actionUrl ?? this.actionUrl,
      relatedId: relatedId ?? this.relatedId,
      relatedType: relatedType ?? this.relatedType,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      isRead: isRead ?? this.isRead,
      iconUrl: iconUrl ?? this.iconUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      sound: sound ?? this.sound,
      channels: channels ?? this.channels,
      expiryAt: expiryAt ?? this.expiryAt,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
    );
  }
}