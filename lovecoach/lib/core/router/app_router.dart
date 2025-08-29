import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/survey_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/email_verification_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/category_select_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/rank_guide_screen.dart';
import '../../features/settings/presentation/screens/ai_settings_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/notification_settings_screen.dart';
import '../../features/settings/presentation/screens/app_info_screen.dart';
import '../../features/settings/presentation/screens/chat_history_screen.dart';
import '../../features/settings/presentation/screens/theme_settings_screen.dart';
import '../../features/settings/presentation/screens/language_settings_screen.dart';
import '../../features/settings/presentation/screens/storage_settings_screen.dart';
import '../../features/settings/presentation/screens/security_settings_screen.dart';
import '../../features/legal/presentation/screens/privacy_policy_screen.dart';
import '../../features/legal/presentation/screens/terms_of_service_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/support/presentation/screens/inquiry_history_screen.dart';
import '../../features/community/presentation/screens/community_screen.dart';
import '../../features/community/presentation/screens/write_post_screen.dart';
import '../../features/community/presentation/screens/post_detail_screen.dart';
import '../../shared/providers/auth_provider.dart';

class AppRouter {
  static final routerProvider = Provider<GoRouter>((ref) {
    // watch 대신 read를 사용하여 불필요한 리빌드 방지
    final authState = ref.read(authStateProvider);
    final currentUser = ref.read(currentUserProvider);
    
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/survey',
          builder: (context, state) => const SurveyScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/category',
          builder: (context, state) => const CategorySelectScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) {
            final category = state.uri.queryParameters['category'] ?? 'general';
            final sessionId = state.uri.queryParameters['sessionId'];
            return ChatScreen(category: category, sessionId: sessionId);
          },
        ),
        GoRoute(
          path: '/subscription',
          builder: (context, state) => const SubscriptionScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/ai-settings',
          builder: (context, state) => const AISettingsScreen(),
        ),
        GoRoute(
          path: '/notification-settings',
          builder: (context, state) => const NotificationSettingsScreen(),
        ),
        GoRoute(
          path: '/chat-history',
          builder: (context, state) => const ChatHistoryScreen(),
        ),
        GoRoute(
          path: '/app-info',
          builder: (context, state) => const AppInfoScreen(),
        ),
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: '/terms-of-service',
          builder: (context, state) => const TermsOfServiceScreen(),
        ),
        GoRoute(
          path: '/support',
          builder: (context, state) => const SupportScreen(),
        ),
        GoRoute(
          path: '/inquiry-history',
          builder: (context, state) => const InquiryHistoryScreen(),
        ),
        GoRoute(
          path: '/community',
          builder: (context, state) => const CommunityScreen(),
        ),
        GoRoute(
          path: '/community/write',
          builder: (context, state) => const WritePostScreen(),
        ),
        GoRoute(
          path: '/community/post/:postId',
          builder: (context, state) {
            final postId = state.pathParameters['postId']!;
            return PostDetailScreen(postId: postId);
          },
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/email-verification',
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return EmailVerificationScreen(email: email);
          },
        ),
        GoRoute(
          path: '/theme-settings',
          builder: (context, state) => const ThemeSettingsScreen(),
        ),
        GoRoute(
          path: '/language-settings',
          builder: (context, state) => const LanguageSettingsScreen(),
        ),
        GoRoute(
          path: '/storage-settings',
          builder: (context, state) => const StorageSettingsScreen(),
        ),
        GoRoute(
          path: '/security-settings',
          builder: (context, state) => const SecuritySettingsScreen(),
        ),
        GoRoute(
          path: '/rank-guide',
          builder: (context, state) => const RankGuideScreen(),
        ),
      ],
      // redirect 로직을 완전히 제거하여 불필요한 리다이렉트 방지
    );
  });
  
  static GoRouter router(WidgetRef ref) => ref.watch(routerProvider);
}