import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/chat_message.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/notification_widget.dart';

class CategorySelectScreen extends ConsumerWidget {
  const CategorySelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundStart,
              AppTheme.backgroundEnd,
            ],
          ),
        ),
        child: Column(
          children: [
            // 새로운 헤더 (프리미엄 구독 + 알림)
            _buildNewHeader(context, ref),
            
            // 스크롤 가능한 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
              
                    // 환영 메시지
                    user.when(
                      data: (userData) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '안녕하세요, ${userData?.displayName ?? '사용자'}님!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '어떤 고민을 상담받고 싶으신가요?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (userData != null && !userData.isSubscribed)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData.consultationStatusMessage,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (!userData.canUseTodayConsultation) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            '내일 자정에 새로운 상담이 가능해집니다',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('오류가 발생했습니다: $error'),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 카테고리 목록
                    SizedBox(
                      height: 500, // 고정 높이
                      child: _buildCategoryGrid(context),
                    ),
                    
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 80, // 하단 네비게이션 바 + 여백
                    ),
                  ],
                ),
              ),
            ),
            
            // 하단 네비게이션 바
            _buildBottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNewHeader(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      child: Row(
        children: [
          // 로고
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '러브코치',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          
          const Spacer(),
          
          // 프리미엄 구독 버튼
          user.when(
            data: (userData) => userData != null && !userData.isSubscribed
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red[400]!, Colors.red[600]!],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.push('/subscription'),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '구독하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          
          // 알림 벨
          NotificationBell(
            onTap: () => showNotificationPanel(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: 12,
        left: 24,
        right: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.psychology,
            label: 'AI 설정',
            onTap: () => context.push('/ai-settings'),
          ),
          _buildNavItem(
            context,
            icon: Icons.forum_outlined,
            label: '커뮤니티',
            onTap: () => context.push('/community'),
          ),
          _buildNavItem(
            context,
            icon: Icons.settings,
            label: '설정',
            onTap: () => context.push('/settings'),
          ),
          _buildNavItem(
            context,
            icon: Icons.person_outline,
            label: '프로필',
            onTap: () => context.push('/profile'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.accentColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 0.85,
      children: [
        _EnhancedCategoryCard(
          icon: Icons.favorite_border,
          title: '썸',
          subtitle: '설레는 시작',
          description: '썸 타는 상황의 고민을\n전문가와 상담해보세요',
          gradient: LinearGradient(
            colors: [Colors.pink[300]!, Colors.pink[100]!],
          ),
          onTap: () => _navigateToChat(context, ConsultationCategory.flirting),
        ),
        _EnhancedCategoryCard(
          icon: Icons.favorite,
          title: '연애중',
          subtitle: '달콤한 관계',
          description: '연인과의 관계 고민을\n함께 해결해보세요',
          gradient: LinearGradient(
            colors: [Colors.red[400]!, Colors.red[200]!],
          ),
          onTap: () => _navigateToChat(context, ConsultationCategory.dating),
        ),
        _EnhancedCategoryCard(
          icon: Icons.healing,
          title: '이별후',
          subtitle: '마음의 치유',
          description: '이별 후의 마음 정리를\n전문가와 함께해요',
          gradient: LinearGradient(
            colors: [Colors.blue[400]!, Colors.blue[200]!],
          ),
          onTap: () => _navigateToChat(context, ConsultationCategory.breakup),
        ),
        _EnhancedCategoryCard(
          icon: Icons.refresh,
          title: '재회',
          subtitle: '새로운 기회',
          description: '관계 회복과 재회에\n대한 조언을 받아보세요',
          gradient: LinearGradient(
            colors: [Colors.green[400]!, Colors.green[200]!],
          ),
          onTap: () => _navigateToChat(context, ConsultationCategory.reconciliation),
        ),
      ],
    );
  }


  void _navigateToChat(BuildContext context, ConsultationCategory category) {
    context.push('/chat?category=${category.name}');
  }
}

class _EnhancedCategoryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _EnhancedCategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_EnhancedCategoryCard> createState() => _EnhancedCategoryCardState();
}

class _EnhancedCategoryCardState extends State<_EnhancedCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        _animationController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.colors.first.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            size: 28,
                            color: widget.gradient.colors.first,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.8),
                          size: 16,
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}