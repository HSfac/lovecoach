import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/community_post.dart';
import '../models/comment.dart';
import '../models/user_model.dart';
import 'community_notification_service.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CommunityNotificationService _notificationService = CommunityNotificationService();

  Stream<List<CommunityPost>> getPosts({String? category}) {
    Query query = _firestore.collection('community_posts')
        .orderBy('createdAt', descending: true);
    
    if (category != null && category != 'all') {
      query = query.where('category', isEqualTo: category);
    }
    
    return query.snapshots().asyncMap((snapshot) async {
      List<CommunityPost> posts = [];
      
      for (final doc in snapshot.docs) {
        final post = CommunityPost.fromFirestore(doc);
        
        // Fetch author info
        UserModel? author;
        try {
          final userDoc = await _firestore.collection('users').doc(post.authorId).get();
          if (userDoc.exists) {
            author = UserModel.fromFirestore(userDoc.data()!, userDoc.id);
          }
        } catch (e) {
          // Handle error silently, post will show without author info
        }
        
        posts.add(post.copyWith(author: author));
      }
      
      return posts;
    });
  }

  Future<String> createPost({
    required String authorId,
    required String authorName,
    required String title,
    required String content,
    required String category,
  }) async {
    final now = DateTime.now();
    final post = CommunityPost(
      id: '',
      authorId: authorId,
      authorName: authorName,
      title: title,
      content: content,
      category: category,
      createdAt: now,
      updatedAt: now,
    );

    final docRef = await _firestore.collection('community_posts').add(post.toFirestore());
    
    // Handle new post notification and update user activity
    await _notificationService.handleNewPost(authorUserId: authorId);
    
    return docRef.id;
  }

  Future<void> updatePost({
    required String postId,
    required String title,
    required String content,
  }) async {
    await _firestore.collection('community_posts').doc(postId).update({
      'title': title,
      'content': content,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deletePost(String postId) async {
    final batch = _firestore.batch();
    
    batch.delete(_firestore.collection('community_posts').doc(postId));
    
    final comments = await _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .get();
    
    for (final comment in comments.docs) {
      batch.delete(comment.reference);
    }
    
    await batch.commit();
  }

  Future<void> toggleLike(String postId, String userId) async {
    final postRef = _firestore.collection('community_posts').doc(postId);
    
    await _firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);
      final post = CommunityPost.fromFirestore(postDoc);
      
      final likedBy = List<String>.from(post.likedBy);
      final wasLiked = likedBy.contains(userId);
      
      if (wasLiked) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }
      
      transaction.update(postRef, {
        'likedBy': likedBy,
        'likeCount': likedBy.length,
      });
      
      // Handle like notification only when liking (not unliking)
      if (!wasLiked) {
        // Get user info for notification
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final likerName = userData['displayName'] ?? '익명';
          
          await _notificationService.handlePostLike(
            postId: postId,
            likerUserId: userId,
            likerName: likerName,
          );
        }
      }
    });
  }

  Stream<List<Comment>> getComments(String postId) {
    return _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      List<Comment> allComments = [];
      
      // Simply convert all comments without complex processing for now
      for (final doc in snapshot.docs) {
        try {
          final comment = Comment.fromFirestore(doc);
          allComments.add(comment);
        } catch (e) {
          // Handle parsing errors silently
        }
      }
      
      // Separate top-level comments and replies
      List<Comment> topLevelComments = [];
      Map<String, List<Comment>> repliesMap = {};
      
      for (final comment in allComments) {
        if (comment.parentId == null) {
          topLevelComments.add(comment);
        } else {
          if (!repliesMap.containsKey(comment.parentId)) {
            repliesMap[comment.parentId!] = [];
          }
          repliesMap[comment.parentId!]!.add(comment);
        }
      }
      
      // Attach replies to parent comments
      for (int i = 0; i < topLevelComments.length; i++) {
        final parentId = topLevelComments[i].id;
        if (repliesMap.containsKey(parentId)) {
          topLevelComments[i] = topLevelComments[i].copyWith(replies: repliesMap[parentId]!);
        }
      }
      
      return topLevelComments;
    });
  }

  Future<String> addComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentId, // For replies
  }) async {
    final comment = Comment(
      id: '',
      postId: postId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: DateTime.now(),
      parentId: parentId,
    );

    final docRef = await _firestore.collection('comments').add(comment.toFirestore());
    
    await _firestore.collection('community_posts').doc(postId).update({
      'commentCount': FieldValue.increment(1),
    });
    
    // Handle comment notification
    await _notificationService.handleNewComment(
      postId: postId,
      commenterUserId: authorId,
      commenterName: authorName,
      commentContent: content,
    );
    
    return docRef.id;
  }

  Future<void> deleteComment(String commentId, String postId) async {
    await _firestore.collection('comments').doc(commentId).delete();
    await _firestore.collection('community_posts').doc(postId).update({
      'commentCount': FieldValue.increment(-1),
    });
  }

  Future<void> toggleCommentLike(String commentId, String userId) async {
    final commentRef = _firestore.collection('comments').doc(commentId);
    
    await _firestore.runTransaction((transaction) async {
      final commentDoc = await transaction.get(commentRef);
      final comment = Comment.fromFirestore(commentDoc);
      
      final likedBy = List<String>.from(comment.likedBy);
      final wasLiked = likedBy.contains(userId);
      
      if (wasLiked) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }
      
      transaction.update(commentRef, {
        'likedBy': likedBy,
        'likeCount': likedBy.length,
      });
      
      // Handle comment like notification only when liking (not unliking)
      if (!wasLiked) {
        // Get user info for notification
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final likerName = userData['displayName'] ?? '익명';
          
          await _notificationService.handleCommentLike(
            commentId: commentId,
            likerUserId: userId,
            likerName: likerName,
          );
        }
      }
    });
  }
}