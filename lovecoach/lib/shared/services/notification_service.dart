import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _fcmToken;

  // FCM 토큰 getter
  String? get fcmToken => _fcmToken;

  // 알림 서비스 초기화
  Future<void> initialize() async {
    try {
      // 알림 권한 요청
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('알림 권한이 승인되었습니다');
        
        // FCM 토큰 가져오기
        _fcmToken = await _messaging.getToken();
        debugPrint('FCM Token: $_fcmToken');
        
        // 토큰 새로고침 리스너
        _messaging.onTokenRefresh.listen((token) {
          _fcmToken = token;
          debugPrint('FCM Token 새로고침: $token');
          // TODO: 서버에 새 토큰 업데이트
        });

        // 포그라운드 메시지 처리
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
        
        // 백그라운드에서 앱 열기 처리
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
        
        // 앱이 종료된 상태에서 알림으로 열기 처리
        final initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          _handleMessageOpenedApp(initialMessage);
        }

      } else {
        debugPrint('알림 권한이 거부되었습니다');
      }
    } catch (e) {
      debugPrint('알림 서비스 초기화 실패: $e');
    }
  }

  // 포그라운드 메시지 처리
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('포그라운드 메시지 수신: ${message.messageId}');
    
    // 사용자 설정 확인
    _checkNotificationSettings().then((settings) {
      if (settings['push_notifications'] == true) {
        _showLocalNotification(message);
      }
    });
  }

  // 백그라운드에서 앱 열기 처리
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('백그라운드에서 앱 열기: ${message.messageId}');
    
    // 알림 타입에 따른 네비게이션 처리
    final data = message.data;
    if (data['type'] == 'chat') {
      // 채팅 화면으로 이동
      // TODO: 글로벌 네비게이션 구현 필요
    } else if (data['type'] == 'subscription') {
      // 구독 화면으로 이동
    }
  }

  // 로컬 알림 표시 (웹에서는 브라우저 알림)
  void _showLocalNotification(RemoteMessage message) {
    // TODO: 로컬 알림 구현 (flutter_local_notifications)
    debugPrint('로컬 알림 표시: ${message.notification?.title}');
  }

  // 사용자 알림 설정 확인
  Future<Map<String, bool>> _checkNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'push_notifications': prefs.getBool('push_notifications') ?? true,
      'chat_notifications': prefs.getBool('chat_notifications') ?? true,
      'system_notifications': prefs.getBool('system_notifications') ?? true,
      'email_notifications': prefs.getBool('email_notifications') ?? true,
      'promotion_notifications': prefs.getBool('promotion_notifications') ?? false,
    };
  }

  // 특정 주제 구독
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('주제 구독: $topic');
    } catch (e) {
      debugPrint('주제 구독 실패: $e');
    }
  }

  // 특정 주제 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('주제 구독 해제: $topic');
    } catch (e) {
      debugPrint('주제 구독 해제 실패: $e');
    }
  }

  // 사용자별 구독 설정
  Future<void> updateSubscriptionSettings(String userId, bool isSubscribed) async {
    try {
      if (isSubscribed) {
        await subscribeToTopic('premium_users');
        await subscribeToTopic('user_$userId');
      } else {
        await subscribeToTopic('free_users');
        await subscribeToTopic('user_$userId');
      }
    } catch (e) {
      debugPrint('구독 설정 업데이트 실패: $e');
    }
  }

  // 알림 권한 상태 확인
  Future<bool> isNotificationEnabled() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // 디바이스 정보 수집 (분석용)
  Future<Map<String, String>> getDeviceInfo() async {
    return {
      'platform': defaultTargetPlatform.name,
      'fcm_token': _fcmToken ?? 'none',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

// 백그라운드 메시지 핸들러 (main.dart에서 등록 필요)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('백그라운드 메시지 처리: ${message.messageId}');
  // 백그라운드에서 수신된 메시지 처리
}