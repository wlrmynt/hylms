import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/realtime_update.dart';

class RealtimeService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  static CollectionReference get updatesCollection => 
      _firestore.collection('realtime_updates');
  static CollectionReference get channelsCollection => 
      _firestore.collection('realtime_channels');
  static CollectionReference get syncStatusCollection => 
      _firestore.collection('sync_status');
  
  // Publish a real-time update
  static Future<void> publishUpdate(RealtimeUpdate update) async {
    try {
      await updatesCollection.add(update.toJson());
    } catch (e) {
      print('Error publishing update: $e');
      throw 'Failed to publish update';
    }
  }
  
  // Get updates for a specific user
  static Stream<List<RealtimeUpdate>> getUserUpdates(
    String userId, {
    String? type,
    int limit = 50,
  }) {
    Query query = updatesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit);
    
    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return RealtimeUpdate.fromJson(data);
      }).toList();
    });
  }
  
  // Mark updates as processed
  static Future<void> markUpdatesAsProcessed(List<String> updateIds) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (String updateId in updateIds) {
        DocumentReference docRef = updatesCollection.doc(updateId);
        batch.update(docRef, {'isProcessed': true});
      }
      
      await batch.commit();
    } catch (e) {
      print('Error marking updates as processed: $e');
      throw 'Failed to mark updates as processed';
    }
  }
  
  // Create a real-time channel
  static Future<String> createChannel(RealtimeChannel channel) async {
    try {
      DocumentReference doc = await channelsCollection.add(channel.toJson());
      return doc.id;
    } catch (e) {
      print('Error creating channel: $e');
      throw 'Failed to create channel';
    }
  }
  
  // Join a channel
  static Future<void> joinChannel(String channelId, String userId) async {
    try {
      await channelsCollection.doc(channelId).update({
        'allowedUsers': FieldValue.arrayUnion([userId]),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error joining channel: $e');
      throw 'Failed to join channel';
    }
  }
  
  // Leave a channel
  static Future<void> leaveChannel(String channelId, String userId) async {
    try {
      await channelsCollection.doc(channelId).update({
        'allowedUsers': FieldValue.arrayRemove([userId]),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error leaving channel: $e');
      throw 'Failed to leave channel';
    }
  }
  
  // Get user's channels
  static Future<List<RealtimeChannel>> getUserChannels(String userId) async {
    try {
      QuerySnapshot snapshot = await channelsCollection
          .where('allowedUsers', arrayContains: userId)
          .where('isPrivate', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['name'] = doc.id; // Use document ID as name for private access
        return RealtimeChannel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting user channels: $e');
      return [];
    }
  }
  
  // Get channel updates
  static Stream<List<RealtimeUpdate>> getChannelUpdates(String channelName) {
    return updatesCollection
        .where('metadata.channel', isEqualTo: channelName)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return RealtimeUpdate.fromJson(data);
      }).toList();
    });
  }
  
  // Update sync status for an entity
  static Future<void> updateSyncStatus(SyncStatus syncStatus) async {
    try {
      String syncId = '${syncStatus.userId}_${syncStatus.entityType}_${syncStatus.entityId}';
      await syncStatusCollection.doc(syncId).set(syncStatus.toJson());
    } catch (e) {
      print('Error updating sync status: $e');
      throw 'Failed to update sync status';
    }
  }
  
  // Get sync status for user entities
  static Future<List<SyncStatus>> getUserSyncStatus(String userId) async {
    try {
      QuerySnapshot snapshot = await syncStatusCollection
          .where('userId', isEqualTo: userId)
          .orderBy('lastSync', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return SyncStatus.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting user sync status: $e');
      return [];
    }
  }
  
  // Check for sync conflicts
  static Future<List<SyncStatus>> getSyncConflicts(String userId) async {
    try {
      QuerySnapshot snapshot = await syncStatusCollection
          .where('userId', isEqualTo: userId)
          .where('isSynced', isEqualTo: false)
          .get();
      
      List<SyncStatus> conflicts = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return SyncStatus.fromJson(data);
      }).where((status) => status.hasConflicts).toList();
      
      return conflicts;
    } catch (e) {
      print('Error getting sync conflicts: $e');
      return [];
    }
  }
  
  // Resolve sync conflict
  static Future<void> resolveSyncConflict(
    String userId,
    String entityType,
    String entityId,
    Map<String, dynamic> resolvedData,
  ) async {
    try {
      String syncId = '${userId}_${entityType}_${entityId}';
      await syncStatusCollection.doc(syncId).update({
        'syncData': resolvedData,
        'isSynced': true,
        'lastSync': Timestamp.fromDate(DateTime.now()),
        'conflictResolution': 'user_resolved',
        'version': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error resolving sync conflict: $e');
      throw 'Failed to resolve sync conflict';
    }
  }
  
  // Sync all user data
  static Future<Map<String, dynamic>> syncUserData(String userId) async {
    try {
      // Get all sync statuses for the user
      List<SyncStatus> syncStatuses = await getUserSyncStatus(userId);
      
      Map<String, dynamic> syncResults = {
        'totalEntities': syncStatuses.length,
        'syncedEntities': 0,
        'conflicts': 0,
        'errors': [],
      };
      
      for (SyncStatus status in syncStatuses) {
        try {
          if (status.hasConflicts) {
            syncResults['conflicts'] = (syncResults['conflicts'] as int) + 1;
            
            // Auto-resolve simple conflicts
            if (status.version < 3) { // Auto-resolve if version is low
              await resolveSyncConflict(
                userId,
                status.entityType,
                status.entityId,
                status.syncData,
              );
              syncResults['syncedEntities'] = (syncResults['syncedEntities'] as int) + 1;
            }
          } else {
            syncResults['syncedEntities'] = (syncResults['syncedEntities'] as int) + 1;
          }
        } catch (e) {
          (syncResults['errors'] as List).add('Error syncing ${status.entityType}: $e');
        }
      }
      
      return syncResults;
    } catch (e) {
      print('Error syncing user data: $e');
      throw 'Failed to sync user data';
    }
  }
  
  // Broadcast update to multiple users
  static Future<void> broadcastUpdate({
    required List<String> userIds,
    required RealtimeUpdate update,
  }) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (String userId in userIds) {
        DocumentReference docRef = updatesCollection.doc();
        RealtimeUpdate userUpdate = RealtimeUpdate(
          id: '',
          userId: userId,
          type: update.type,
          action: update.action,
          data: update.data,
          timestamp: DateTime.now(),
          source: update.source,
          metadata: {...update.metadata, 'broadcastId': docRef.id},
        );
        batch.set(docRef, userUpdate.toJson());
      }
      
      await batch.commit();
    } catch (e) {
      print('Error broadcasting update: $e');
      throw 'Failed to broadcast update';
    }
  }
  
  // Create system-wide update
  static Future<void> createSystemUpdate({
    required String type,
    required String action,
    required Map<String, dynamic> data,
    String? source,
  }) async {
    try {
      RealtimeUpdate systemUpdate = RealtimeUpdate(
        id: '',
        userId: 'system', // Special user ID for system updates
        type: type,
        action: action,
        data: data,
        timestamp: DateTime.now(),
        source: source ?? 'system',
        metadata: {'isSystemUpdate': true},
      );
      
      await publishUpdate(systemUpdate);
    } catch (e) {
      print('Error creating system update: $e');
      throw 'Failed to create system update';
    }
  }
  
  // Clean up old updates
  static Future<void> cleanupOldUpdates({int daysToKeep = 30}) async {
    try {
      DateTime cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      
      QuerySnapshot oldUpdates = await updatesCollection
          .where('timestamp', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();
      
      WriteBatch batch = _firestore.batch();
      
      for (DocumentSnapshot doc in oldUpdates.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      print('Error cleaning up old updates: $e');
    }
  }
  
  // Get real-time statistics
  static Future<Map<String, dynamic>> getRealtimeStatistics() async {
    try {
      // Get total updates in the last hour
      DateTime oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
      QuerySnapshot recentUpdates = await updatesCollection
          .where('timestamp', isGreaterThan: Timestamp.fromDate(oneHourAgo))
          .get();
      
      // Get active channels
      QuerySnapshot channelsSnapshot = await channelsCollection
          .where('isPrivate', isEqualTo: false)
          .get();
      
      // Get unsynced entities
      QuerySnapshot unsyncedSnapshot = await syncStatusCollection
          .where('isSynced', isEqualTo: false)
          .get();
      
      return {
        'updatesLastHour': recentUpdates.docs.length,
        'totalChannels': channelsSnapshot.docs.length,
        'unsyncedEntities': unsyncedSnapshot.docs.length,
        'averageUpdateRate': recentUpdates.docs.length / 60.0, // per minute
        'lastCleanup': oneHourAgo.toIso8601String(),
      };
    } catch (e) {
      print('Error getting realtime statistics: $e');
      return {};
    }
  }
  
  // Helper methods for common update types
  static Future<void> publishProgressUpdate(
    String userId,
    String courseId,
    String action,
    Map<String, dynamic> progressData,
  ) async {
    RealtimeUpdate update = RealtimeUpdate(
      id: '',
      userId: userId,
      type: 'progress',
      action: action,
      data: progressData,
      timestamp: DateTime.now(),
      source: 'progress_service',
      metadata: {'courseId': courseId},
    );
    
    await publishUpdate(update);
  }
  
  static Future<void> publishAssignmentUpdate(
    String userId,
    String assignmentId,
    String action,
    Map<String, dynamic> assignmentData,
  ) async {
    RealtimeUpdate update = RealtimeUpdate(
      id: '',
      userId: userId,
      type: 'assignment',
      action: action,
      data: assignmentData,
      timestamp: DateTime.now(),
      source: 'assignment_service',
      metadata: {'assignmentId': assignmentId},
    );
    
    await publishUpdate(update);
  }
  
  static Future<void> publishForumUpdate(
    String userId,
    String threadId,
    String action,
    Map<String, dynamic> forumData,
  ) async {
    RealtimeUpdate update = RealtimeUpdate(
      id: '',
      userId: userId,
      type: 'forum',
      action: action,
      data: forumData,
      timestamp: DateTime.now(),
      source: 'forum_service',
      metadata: {'threadId': threadId},
    );
    
    await publishUpdate(update);
  }
}