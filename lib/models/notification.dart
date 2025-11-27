import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final String? actionUrl; // URL to navigate when clicked
  final String? relatedId; // ID of related item (assignment, course, etc.)
  final String relatedType; // Type of related item
  final Map<String, dynamic> data; // Additional notification data
  final DateTime createdAt;
  final DateTime? readAt;
  final bool isRead;
  final String? iconUrl;
  final String? imageUrl;
  final String? sound; // Sound to play for push notifications
  final List<String> channels; // push, email, sms, in_app
  final DateTime? expiryAt;
  final String senderId;
  final String senderName;
  
  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    this.actionUrl,
    this.relatedId,
    required this.relatedType,
    required this.data,
    required this.createdAt,
    this.readAt,
    this.isRead = false,
    this.iconUrl,
    this.imageUrl,
    this.sound,
    required this.channels,
    this.expiryAt,
    required this.senderId,
    required this.senderName,
  });
  
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.info,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => NotificationPriority.normal,
      ),
      actionUrl: json['actionUrl'],
      relatedId: json['relatedId'],
      relatedType: json['relatedType'] ?? '',
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      readAt: json['readAt'] != null 
          ? (json['readAt'] as Timestamp).toDate()
          : null,
      isRead: json['isRead'] ?? false,
      iconUrl: json['iconUrl'],
      imageUrl: json['imageUrl'],
      sound: json['sound'],
      channels: List<String>.from(json['channels'] ?? ['in_app']),
      expiryAt: json['expiryAt'] != null 
          ? (json['expiryAt'] as Timestamp).toDate()
          : null,
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'actionUrl': actionUrl,
      'relatedId': relatedId,
      'relatedType': relatedType,
      'data': data,
      'createdAt': Timestamp.fromDate(createdAt),
      'readAt': readAt != null 
          ? Timestamp.fromDate(readAt!)
          : null,
      'isRead': isRead,
      'iconUrl': iconUrl,
      'imageUrl': imageUrl,
      'sound': sound,
      'channels': channels,
      'expiryAt': expiryAt != null 
          ? Timestamp.fromDate(expiryAt!)
          : null,
      'senderId': senderId,
      'senderName': senderName,
    };
  }
  
  // Check if notification is expired
  bool get isExpired {
    if (expiryAt == null) return false;
    return DateTime.now().isAfter(expiryAt!);
  }
  
  // Mark as read
  Notification markAsRead() {
    return Notification(
      id: id,
      userId: userId,
      title: title,
      message: message,
      type: type,
      priority: priority,
      actionUrl: actionUrl,
      relatedId: relatedId,
      relatedType: relatedType,
      data: data,
      createdAt: createdAt,
      readAt: DateTime.now(),
      isRead: true,
      iconUrl: iconUrl,
      imageUrl: imageUrl,
      sound: sound,
      channels: channels,
      expiryAt: expiryAt,
      senderId: senderId,
      senderName: senderName,
    );
  }
}

enum NotificationType {
  info,
  success,
  warning,
  error,
  assignment,
  course,
  message,
  announcement,
  system,
  reminder,
  achievement,
  certificate,
  progress,
  forum,
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

class NotificationPreferences {
  final String userId;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final bool inAppEnabled;
  final Map<NotificationType, bool> typePreferences;
  final Map<String, bool> channelPreferences;
  final String quietHoursStart; // HH:mm format
  final String quietHoursEnd; // HH:mm format
  final bool weekendNotifications;
  final Map<String, String> languagePreferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  NotificationPreferences({
    required this.userId,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.smsEnabled,
    required this.inAppEnabled,
    required this.typePreferences,
    required this.channelPreferences,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.weekendNotifications,
    required this.languagePreferences,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory NotificationPreferences.defaultPreferences(String userId) {
    return NotificationPreferences(
      userId: userId,
      pushEnabled: true,
      emailEnabled: true,
      smsEnabled: false,
      inAppEnabled: true,
      typePreferences: {
        NotificationType.assignment: true,
        NotificationType.course: true,
        NotificationType.message: true,
        NotificationType.announcement: true,
        NotificationType.system: true,
        NotificationType.reminder: true,
        NotificationType.achievement: true,
        NotificationType.certificate: true,
        NotificationType.progress: true,
        NotificationType.forum: false,
        NotificationType.info: true,
        NotificationType.success: true,
        NotificationType.warning: true,
        NotificationType.error: true,
      },
      channelPreferences: {
        'push': true,
        'email': true,
        'sms': false,
        'in_app': true,
      },
      quietHoursStart: '22:00',
      quietHoursEnd: '08:00',
      weekendNotifications: false,
      languagePreferences: {
        'title': 'id',
        'message': 'id',
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      userId: json['userId'] ?? '',
      pushEnabled: json['pushEnabled'] ?? true,
      emailEnabled: json['emailEnabled'] ?? true,
      smsEnabled: json['smsEnabled'] ?? false,
      inAppEnabled: json['inAppEnabled'] ?? true,
      typePreferences: (json['typePreferences'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
                NotificationType.values.firstWhere(
                  (e) => e.toString().split('.').last == key,
                  orElse: () => NotificationType.info,
                ),
                value as bool,
              )),
      channelPreferences: Map<String, bool>.from(json['channelPreferences'] ?? {}),
      quietHoursStart: json['quietHoursStart'] ?? '22:00',
      quietHoursEnd: json['quietHoursEnd'] ?? '08:00',
      weekendNotifications: json['weekendNotifications'] ?? false,
      languagePreferences: Map<String, String>.from(json['languagePreferences'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'pushEnabled': pushEnabled,
      'emailEnabled': emailEnabled,
      'smsEnabled': smsEnabled,
      'inAppEnabled': inAppEnabled,
      'typePreferences': typePreferences.map((key, value) => 
          MapEntry(key.toString().split('.').last, value)),
      'channelPreferences': channelPreferences,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'weekendNotifications': weekendNotifications,
      'languagePreferences': languagePreferences,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
  
  // Check if notifications should be sent based on preferences
  bool shouldSendNotification(Notification notification, String channel) {
    // Check if channel is enabled
    if (channelPreferences[channel] == null || !channelPreferences[channel]!) return false;
    
    // Check if notification type is enabled
    if (typePreferences[notification.type] == null || !typePreferences[notification.type]!) return false;
    
    // Check quiet hours
    if (_isInQuietHours(notification.createdAt)) {
      // Allow urgent notifications even during quiet hours
      if (notification.priority != NotificationPriority.urgent) {
        return false;
      }
    }
    
    // Check weekend notifications
    if (!_isWeekend(notification.createdAt) || weekendNotifications) {
      return true;
    }
    
    return false;
  }
  
  bool _isInQuietHours(DateTime dateTime) {
    try {
      List<String> startParts = quietHoursStart.split(':');
      List<String> endParts = quietHoursEnd.split(':');
      
      int startHour = int.parse(startParts[0]);
      int startMinute = int.parse(startParts[1]);
      int endHour = int.parse(endParts[0]);
      int endMinute = int.parse(endParts[1]);
      
      DateTime startTime = DateTime(dateTime.year, dateTime.month, dateTime.day, startHour, startMinute);
      DateTime endTime = DateTime(dateTime.year, dateTime.month, dateTime.day, endHour, endMinute);
      
      // Handle overnight quiet hours (e.g., 22:00 to 08:00)
      if (endTime.isBefore(startTime)) {
        return dateTime.isAfter(startTime) || dateTime.isBefore(endTime);
      } else {
        return dateTime.isAfter(startTime) && dateTime.isBefore(endTime);
      }
    } catch (e) {
      return false;
    }
  }
  
  bool _isWeekend(DateTime dateTime) {
    return dateTime.weekday == DateTime.saturday || dateTime.weekday == DateTime.sunday;
  }
}

class NotificationTemplate {
  final String id;
  final String name;
  final NotificationType type;
  final Map<String, String> titleTemplates; // locale -> title template
  final Map<String, String> messageTemplates; // locale -> message template
  final Map<String, dynamic> defaultData;
  final List<String> channels;
  final NotificationPriority defaultPriority;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  NotificationTemplate({
    required this.id,
    required this.name,
    required this.type,
    required this.titleTemplates,
    required this.messageTemplates,
    required this.defaultData,
    required this.channels,
    required this.defaultPriority,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory NotificationTemplate.fromJson(Map<String, dynamic> json) {
    return NotificationTemplate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.info,
      ),
      titleTemplates: Map<String, String>.from(json['titleTemplates'] ?? {}),
      messageTemplates: Map<String, String>.from(json['messageTemplates'] ?? {}),
      defaultData: Map<String, dynamic>.from(json['defaultData'] ?? {}),
      channels: List<String>.from(json['channels'] ?? []),
      defaultPriority: NotificationPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['defaultPriority'],
        orElse: () => NotificationPriority.normal,
      ),
      isActive: json['isActive'] ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'titleTemplates': titleTemplates,
      'messageTemplates': messageTemplates,
      'defaultData': defaultData,
      'channels': channels,
      'defaultPriority': defaultPriority.toString().split('.').last,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}