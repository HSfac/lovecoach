import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/notification_widget.dart';

class NotificationUtils {
  static void addLikeNotification(WidgetRef ref, {
    required String postId,
    required String likerName,
    required String postTitle,
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '새로운 좋아요',
      message: '$likerName님이 "$postTitle" 게시글을 좋아합니다.',
      type: 'like',
      timestamp: DateTime.now(),
      data: {'postId': postId},
    );
    
    // TODO: 실제 알림 저장 로직 구현 필요
  }

  static void addCommentNotification(WidgetRef ref, {
    required String postId,
    required String commenterName,
    required String postTitle,
    required String commentContent,
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '새로운 댓글',
      message: '$commenterName님이 "$postTitle" 게시글에 댓글을 남겼습니다: "$commentContent"',
      type: 'comment',
      timestamp: DateTime.now(),
      data: {'postId': postId},
    );
    
    // TODO: 실제 알림 저장 로직 구현 필요
  }

  static void addReplyNotification(WidgetRef ref, {
    required String commentId,
    required String replierName,
    required String originalComment,
    required String replyContent,
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '새로운 답글',
      message: '$replierName님이 회원님의 댓글에 답글을 남겼습니다: "$replyContent"',
      type: 'reply',
      timestamp: DateTime.now(),
      data: {'commentId': commentId},
    );
    
    // TODO: 실제 알림 저장 로직 구현 필요
  }

  static void addSystemNotification(WidgetRef ref, {
    required String title,
    required String message,
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: 'system',
      timestamp: DateTime.now(),
    );
    
    // TODO: 실제 알림 저장 로직 구현 필요
  }

  // Demo notifications for testing
  static void addDemoNotifications(WidgetRef ref) {
    // TODO: 데모 알림 기능 구현 필요
  }
}