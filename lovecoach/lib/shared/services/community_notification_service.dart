import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/notification_widget.dart';

class FirebaseCommunityNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get notifications for a user
  Stream<List<NotificationItem>> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => _notificationFromFirestore(doc)).toList());
  }

  // Create notification
  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'data': data ?? {},
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  // Mark all notifications as read for a user
  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    
    final notifications = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  // Clear all notifications for a user
  Future<void> clearAllNotifications(String userId) async {
    final batch = _firestore.batch();
    
    final notifications = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .get();

    for (final doc in notifications.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // Create like notification
  Future<void> createLikeNotification({
    required String targetUserId,
    required String likerUserId,
    required String likerName,
    required String postId,
    required String postTitle,
  }) async {
    // Don't create notification if user likes their own post
    if (targetUserId == likerUserId) return;

    await createNotification(
      userId: targetUserId,
      title: '새로운 좋아요',
      message: '$likerName님이 "$postTitle" 게시글을 좋아합니다.',
      type: 'like',
      data: {
        'postId': postId,
        'likerUserId': likerUserId,
        'likerName': likerName,
      },
    );
  }

  // Create comment notification
  Future<void> createCommentNotification({
    required String targetUserId,
    required String commenterUserId,
    required String commenterName,
    required String postId,
    required String postTitle,
    required String commentContent,
  }) async {
    // Don't create notification if user comments on their own post
    if (targetUserId == commenterUserId) return;

    await createNotification(
      userId: targetUserId,
      title: '새로운 댓글',
      message: '$commenterName님이 "$postTitle" 게시글에 댓글을 남겼습니다: "${commentContent.length > 30 ? '${commentContent.substring(0, 30)}...' : commentContent}"',
      type: 'comment',
      data: {
        'postId': postId,
        'commenterUserId': commenterUserId,
        'commenterName': commenterName,
      },
    );
  }

  // Create comment like notification
  Future<void> createCommentLikeNotification({
    required String targetUserId,
    required String likerUserId,
    required String likerName,
    required String commentId,
    required String commentContent,
  }) async {
    // Don't create notification if user likes their own comment
    if (targetUserId == likerUserId) return;

    await createNotification(
      userId: targetUserId,
      title: '댓글 좋아요',
      message: '$likerName님이 회원님의 댓글을 좋아합니다: "${commentContent.length > 30 ? '${commentContent.substring(0, 30)}...' : commentContent}"',
      type: 'comment_like',
      data: {
        'commentId': commentId,
        'likerUserId': likerUserId,
        'likerName': likerName,
      },
    );
  }

  NotificationItem _notificationFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return NotificationItem(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? 'system',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      data: data['data'] as Map<String, dynamic>?,
    );
  }
}

// Enhanced notification service that integrates with community actions
class CommunityNotificationService {
  final FirebaseCommunityNotificationService _firebaseService = FirebaseCommunityNotificationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Handle post like with notification
  Future<void> handlePostLike({
    required String postId,
    required String likerUserId,
    required String likerName,
  }) async {
    try {
      // Get post info to find author
      final postDoc = await _firestore.collection('community_posts').doc(postId).get();
      if (!postDoc.exists) return;

      final postData = postDoc.data()!;
      final authorId = postData['authorId'] as String;
      final postTitle = postData['title'] as String;

      // Create notification
      await _firebaseService.createLikeNotification(
        targetUserId: authorId,
        likerUserId: likerUserId,
        likerName: likerName,
        postId: postId,
        postTitle: postTitle,
      );

      // Update user activity points
      await _updateUserActivity(likerUserId, likeGiven: 1);
      await _updateUserActivity(authorId, likeReceived: 1);
    } catch (e) {
      print('Error handling post like notification: $e');
    }
  }

  // Handle comment creation with notification
  Future<void> handleNewComment({
    required String postId,
    required String commenterUserId,
    required String commenterName,
    required String commentContent,
  }) async {
    try {
      // Get post info to find author
      final postDoc = await _firestore.collection('community_posts').doc(postId).get();
      if (!postDoc.exists) return;

      final postData = postDoc.data()!;
      final authorId = postData['authorId'] as String;
      final postTitle = postData['title'] as String;

      // Create notification
      await _firebaseService.createCommentNotification(
        targetUserId: authorId,
        commenterUserId: commenterUserId,
        commenterName: commenterName,
        postId: postId,
        postTitle: postTitle,
        commentContent: commentContent,
      );

      // Update user activity points
      await _updateUserActivity(commenterUserId, commentCount: 1);
    } catch (e) {
      print('Error handling comment notification: $e');
    }
  }

  // Handle comment like with notification
  Future<void> handleCommentLike({
    required String commentId,
    required String likerUserId,
    required String likerName,
  }) async {
    try {
      // Get comment info to find author
      final commentDoc = await _firestore.collection('comments').doc(commentId).get();
      if (!commentDoc.exists) return;

      final commentData = commentDoc.data()!;
      final authorId = commentData['authorId'] as String;
      final commentContent = commentData['content'] as String;

      // Create notification
      await _firebaseService.createCommentLikeNotification(
        targetUserId: authorId,
        likerUserId: likerUserId,
        likerName: likerName,
        commentId: commentId,
        commentContent: commentContent,
      );

      // Update user activity points
      await _updateUserActivity(likerUserId, likeGiven: 1);
      await _updateUserActivity(authorId, likeReceived: 1);
    } catch (e) {
      print('Error handling comment like notification: $e');
    }
  }

  // Handle new post creation
  Future<void> handleNewPost({
    required String authorUserId,
  }) async {
    try {
      // Update user activity points
      await _updateUserActivity(authorUserId, postCount: 1);
    } catch (e) {
      print('Error handling new post: $e');
    }
  }

  // Update user activity and add experience points
  Future<void> _updateUserActivity(
    String userId, {
    int postCount = 0,
    int commentCount = 0,
    int likeReceived = 0,
    int likeGiven = 0,
  }) async {
    final userRef = _firestore.collection('users').doc(userId);
    
    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);
      if (!userDoc.exists) return;

      final userData = userDoc.data()!;
      final currentPostCount = userData['communityPostCount'] as int? ?? 0;
      final currentCommentCount = userData['communityCommentCount'] as int? ?? 0;
      final currentLikeReceived = userData['communityLikeReceived'] as int? ?? 0;
      final currentLikeGiven = userData['communityLikeGiven'] as int? ?? 0;
      final currentExp = userData['experiencePoints'] as int? ?? 0;

      final newPostCount = currentPostCount + postCount;
      final newCommentCount = currentCommentCount + commentCount;
      final newLikeReceived = currentLikeReceived + likeReceived;
      final newLikeGiven = currentLikeGiven + likeGiven;

      // Calculate experience points to add
      int expToAdd = (postCount * 20) +      // 포스트 작성: +20 EXP
                    (commentCount * 10) +    // 댓글 작성: +10 EXP
                    (likeReceived * 5) +     // 좋아요 받기: +5 EXP
                    (likeGiven * 2);         // 좋아요 주기: +2 EXP

      final newExp = currentExp + expToAdd;
      
      // Check for level up
      final oldLevel = _calculateLevel(currentExp);
      final newLevel = _calculateLevel(newExp);
      
      if (newLevel > oldLevel && expToAdd > 0) {
        await _createLevelUpNotification(userId, oldLevel, newLevel, newExp);
      }

      transaction.update(userRef, {
        'communityPostCount': newPostCount,
        'communityCommentCount': newCommentCount,
        'communityLikeReceived': newLikeReceived,
        'communityLikeGiven': newLikeGiven,
        'experiencePoints': newExp,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Calculate user level from experience points
  int _calculateLevel(int experiencePoints) {
    if (experiencePoints < 100) return 1;
    if (experiencePoints < 300) return 2;
    if (experiencePoints < 600) return 3;
    if (experiencePoints < 1000) return 4;
    if (experiencePoints < 1500) return 5;
    if (experiencePoints < 2100) return 6;
    if (experiencePoints < 2800) return 7;
    if (experiencePoints < 3600) return 8;
    if (experiencePoints < 4500) return 9;
    if (experiencePoints < 5500) return 10;
    return (experiencePoints ~/ 1000).clamp(10, 50);
  }

  // Get rank name from level
  String _getRankFromLevel(int level) {
    if (level == 1) return '풋사랑';
    if (level <= 3) return '설레임';
    if (level <= 5) return '첫키스';
    if (level <= 7) return '달콤한사랑';
    if (level <= 10) return '열정적사랑';
    if (level <= 15) return '진실한사랑';
    if (level <= 25) return '운명적사랑';
    if (level <= 35) return '영원한사랑';
    return '사랑의전설';
  }

  // Create level up notification
  Future<void> _createLevelUpNotification(String userId, int oldLevel, int newLevel, int newExp) async {
    final oldRank = _getRankFromLevel(oldLevel);
    final newRank = _getRankFromLevel(newLevel);
    
    await _firebaseService.createNotification(
      userId: userId,
      title: '🎉 레벨 업!',
      message: '축하합니다! Lv.$newLevel $newRank 등급이 되었어요! 현재 경험치: $newExp EXP',
      type: 'level_up',
      data: {
        'oldLevel': oldLevel,
        'newLevel': newLevel,
        'oldRank': oldRank,
        'newRank': newRank,
        'newExp': newExp,
      },
    );
  }

  // Get notification stream for user
  Stream<List<NotificationItem>> getUserNotifications(String userId) {
    return _firebaseService.getUserNotifications(userId);
  }

  // Mark as read
  Future<void> markAsRead(String notificationId) {
    return _firebaseService.markAsRead(notificationId);
  }

  // Mark all as read
  Future<void> markAllAsRead(String userId) {
    return _firebaseService.markAllAsRead(userId);
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) {
    return _firebaseService.deleteNotification(notificationId);
  }
}