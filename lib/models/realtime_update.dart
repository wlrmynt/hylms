import 'package:cloud_firestore/cloud_firestore.dart';

class RealtimeUpdate {
  final String id;
  final String userId;
  final String type; // 'progress', 'assignment', 'forum', 'notification', etc.
  final String action; // 'created', 'updated', 'deleted', 'completed'
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String? source; // Source of the update
  final bool isProcessed;
  final Map<String, dynamic> metadata;
  
  RealtimeUpdate({
    required this.id,
    required this.userId,
    required this.type,
    required this.action,
    required this.data,
    required this.timestamp,
    this.source,
    this.isProcessed = false,
    required this.metadata,
  });
  
  factory RealtimeUpdate.fromJson(Map<String, dynamic> json) {
    return RealtimeUpdate(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      action: json['action'] ?? '',
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      source: json['source'],
      isProcessed: json['isProcessed'] ?? false,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'action': action,
      'data': data,
      'timestamp': Timestamp.fromDate(timestamp),
      'source': source,
      'isProcessed': isProcessed,
      'metadata': metadata,
    };
  }
}

class RealtimeChannel {
  final String name;
  final String description;
  final List<String> allowedUsers; // User IDs who can access this channel
  final bool isPrivate;
  final Map<String, dynamic> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  RealtimeChannel({
    required this.name,
    required this.description,
    required this.allowedUsers,
    required this.isPrivate,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory RealtimeChannel.fromJson(Map<String, dynamic> json) {
    return RealtimeChannel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      allowedUsers: List<String>.from(json['allowedUsers'] ?? []),
      isPrivate: json['isPrivate'] ?? false,
      permissions: Map<String, dynamic>.from(json['permissions'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'allowedUsers': allowedUsers,
      'isPrivate': isPrivate,
      'permissions': permissions,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class SyncStatus {
  final String userId;
  final String entityType; // 'course', 'assignment', 'progress', etc.
  final String entityId;
  final DateTime lastSync;
  final DateTime lastUpdate;
  final bool isSynced;
  final Map<String, dynamic> syncData;
  final int version; // Version number for conflict resolution
  final String? conflictResolution;
  
  SyncStatus({
    required this.userId,
    required this.entityType,
    required this.entityId,
    required this.lastSync,
    required this.lastUpdate,
    required this.isSynced,
    required this.syncData,
    required this.version,
    this.conflictResolution,
  });
  
  factory SyncStatus.fromJson(Map<String, dynamic> json) {
    return SyncStatus(
      userId: json['userId'] ?? '',
      entityType: json['entityType'] ?? '',
      entityId: json['entityId'] ?? '',
      lastSync: (json['lastSync'] as Timestamp).toDate(),
      lastUpdate: (json['lastUpdate'] as Timestamp).toDate(),
      isSynced: json['isSynced'] ?? false,
      syncData: Map<String, dynamic>.from(json['syncData'] ?? {}),
      version: json['version'] ?? 1,
      conflictResolution: json['conflictResolution'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'entityType': entityType,
      'entityId': entityId,
      'lastSync': Timestamp.fromDate(lastSync),
      'lastUpdate': Timestamp.fromDate(lastUpdate),
      'isSynced': isSynced,
      'syncData': syncData,
      'version': version,
      'conflictResolution': conflictResolution,
    };
  }
  
  bool get hasConflicts {
    return lastUpdate.isAfter(lastSync);
  }
}