import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/auth_provider.dart';

// 전역 상태로 네비게이션 완료 여부 관리
bool _globalHasNavigated = false;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    
    // 로고 애니메이션
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // 텍스트 애니메이션
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    // 디버깅을 위해 애니메이션 건너뛰고 바로 네비게이션
    await Future.delayed(const Duration(milliseconds: 2000));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    print('DEBUG SPLASH: _navigateToNextScreen called, mounted=$mounted, _hasNavigated=$_hasNavigated, _globalHasNavigated=$_globalHasNavigated');
    if (!mounted || _hasNavigated || _globalHasNavigated) return;
    
    print('DEBUG SPLASH: Setting both flags = true');
    _hasNavigated = true;
    _globalHasNavigated = true;
    
    final authState = ref.read(authStateProvider);
    final currentUser = ref.read(currentUserProvider);
    
    authState.when(
      data: (user) {
        if (!mounted) return;
        if (user != null) {
          currentUser.when(
            data: (userData) {
              if (!mounted) return;
              if (userData != null && userData.hasCompletedSurvey) {
                context.go('/category');
              } else {
                context.go('/survey');
              }
            },
            loading: () {
              if (!mounted) return;
              context.go('/survey');
            },
            error: (error, stackTrace) {
              if (!mounted) return;
              context.go('/survey');
            },
          );
        } else {
          context.go('/login');
        }
      },
      loading: () {
        if (!mounted) return;
        context.go('/login');
      },
      error: (error, stackTrace) {
        if (!mounted) return;
        context.go('/login');
      },
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG SPLASH: build called, _hasNavigated=$_hasNavigated, _globalHasNavigated=$_globalHasNavigated');
    
    // 이미 네비게이션이 완료된 경우 빈 컨테이너 반환
    if (_globalHasNavigated) {
      print('DEBUG SPLASH: Already navigated, returning empty container');
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.favorite,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '러브코치',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AI와 함께하는 연애 상담',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 80),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}