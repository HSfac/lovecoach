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

  // Update user activity and recalculate rank
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

      final newPostCount = currentPostCount + postCount;
      final newCommentCount = currentCommentCount + commentCount;
      final newLikeReceived = currentLikeReceived + likeReceived;
      final newLikeGiven = currentLikeGiven + likeGiven;

      // Calculate new rank
      final points = (newPostCount * 10) + (newCommentCount * 5) + 
                    (newLikeReceived * 2) + (newLikeGiven * 1);
      
      String newRank = 'newbie';
      if (points >= 1200) newRank = 'master';
      else if (points >= 800) newRank = 'diamond';
      else if (points >= 500) newRank = 'platinum';
      else if (points >= 300) newRank = 'gold';
      else if (points >= 150) newRank = 'silver';
      else if (points >= 50) newRank = 'bronze';

      // Check for rank up notification
      final oldRank = userData['communityRank'] as String? ?? 'newbie';
      if (newRank != oldRank) {
        await _createRankUpNotification(userId, oldRank, newRank);
      }

      transaction.update(userRef, {
        'communityPostCount': newPostCount,
        'communityCommentCount': newCommentCount,
        'communityLikeReceived': newLikeReceived,
        'communityLikeGiven': newLikeGiven,
        'communityRank': newRank,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Create rank up notification
  Future<void> _createRankUpNotification(String userId, String oldRank, String newRank) async {
    final rankNames = {
      'newbie': '새싹',
      'bronze': '브론즈',
      'silver': '실버',
      'gold': '골드',
      'platinum': '플래티넘',
      'diamond': '다이아몬드',
      'master': '마스터',
    };

    await _firebaseService.createNotification(
      userId: userId,
      title: '🎉 등급 상승!',
      message: '축하합니다! ${rankNames[oldRank]}에서 ${rankNames[newRank]}로 등급이 올랐어요! 커뮤니티 활동을 더욱 활발히 해보세요.',
      type: 'rank_up',
      data: {
        'oldRank': oldRank,
        'newRank': newRank,
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