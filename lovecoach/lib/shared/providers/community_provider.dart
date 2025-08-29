import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/community_post.dart';
import '../models/comment.dart';
import '../services/community_service.dart';

final communityServiceProvider = Provider<CommunityService>((ref) {
  return CommunityService();
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

final communityPostsProvider = StreamProvider.family<List<CommunityPost>, String>((ref, category) {
  final communityService = ref.watch(communityServiceProvider);
  return communityService.getPosts(category: category == 'all' ? null : category);
});

final postCommentsProvider = StreamProvider.family<List<Comment>, String>((ref, postId) {
  final communityService = ref.watch(communityServiceProvider);
  return communityService.getComments(postId);
});

class CommunityNotifier extends StateNotifier<AsyncValue<void>> {
  CommunityNotifier(this._communityService) : super(const AsyncValue.data(null));

  final CommunityService _communityService;

  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String title,
    required String content,
    required String category,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _communityService.createPost(
        authorId: authorId,
        authorName: authorName,
        title: title,
        content: content,
        category: category,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePost({
    required String postId,
    required String title,
    required String content,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _communityService.updatePost(
        postId: postId,
        title: title,
        content: content,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deletePost(String postId) async {
    state = const AsyncValue.loading();
    try {
      await _communityService.deletePost(postId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      await _communityService.toggleLike(postId, userId);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentId, // For replies
  }) async {
    try {
      await _communityService.addComment(
        postId: postId,
        authorId: authorId,
        authorName: authorName,
        content: content,
        parentId: parentId,
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteComment(String commentId, String postId) async {
    try {
      await _communityService.deleteComment(commentId, postId);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleCommentLike(String commentId, String userId) async {
    try {
      await _communityService.toggleCommentLike(commentId, userId);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final communityNotifierProvider = StateNotifierProvider<CommunityNotifier, AsyncValue<void>>((ref) {
  final communityService = ref.watch(communityServiceProvider);
  return CommunityNotifier(communityService);
});