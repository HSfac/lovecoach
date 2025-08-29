import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/config/env_config.dart';
import 'shared/services/notification_service.dart';
import 'shared/services/daily_reset_service.dart';
import 'shared/services/user_migration_service.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/providers/locale_provider.dart';
import 'generated/app_localizations.dart';
import 'firebase_options.dart';

// 백그라운드 메시지 핸들러
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('백그라운드 메시지 처리: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 환경변수 초기화
    await EnvConfig.init();
  } catch (e) {
    print('환경변수 초기화 실패: $e');
  }
  
  try {
    // Firebase 초기화 (테스트 환경에서는 실패할 수 있음)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // FCM 백그라운드 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
    // 알림 서비스 초기화
    await NotificationService().initialize();
    
    // 일일 리셋 서비스 시작
    DailyResetService().startDailyResetTimer();
    
    // 사용자 데이터 마이그레이션 실행 (한 번만)
    try {
      await UserMigrationService.migrateUserLimits();
    } catch (e) {
      print('사용자 데이터 마이그레이션 실패: $e');
    }
    
    print('Firebase 초기화 성공');
  } catch (e) {
    // Firebase 설정이 없으면 무시하고 계속 진행 (개발/테스트용)
    print('Firebase 초기화 실패 (테스트 모드): $e');
  }
  
  runApp(
    const ProviderScope(
      child: LoveCoachApp(),
    ),
  );
}

class LoveCoachApp extends ConsumerWidget {
  const LoveCoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final currentLocale = ref.watch(currentLocaleProvider);
    
    return MaterialApp.router(
      title: 'Love Coach',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
      locale: currentLocale,
      supportedLocales: ref.watch(supportedLocalesProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: AppRouter.router(ref),
      debugShowCheckedModeBanner: false,
    );
  }
}
