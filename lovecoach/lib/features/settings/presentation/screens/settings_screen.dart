import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/ai_model_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final selectedAI = ref.watch(selectedAIModelProvider);

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
        child: SafeArea(
          child: Column(
            children: [
              // 커스텀 헤더
              _buildHeader(context),
              
              // 설정 메뉴들
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // 사용자 정보 카드
                      _buildUserInfoCard(context, user),
                      
                      const SizedBox(height: 24),
                      
                      // AI 설정 섹션
                      _buildSectionHeader('AI 및 상담 설정'),
                      _buildSettingsCard([
                        _SettingItem(
                          icon: Icons.psychology,
                          title: 'AI 모델 설정',
                          subtitle: '현재: ${selectedAI.displayName}',
                          trailing: Text(selectedAI.icon, style: const TextStyle(fontSize: 16)),
                          onTap: () => context.push('/ai-settings'),
                        ),
                        _SettingItem(
                          icon: Icons.notifications_outlined,
                          title: '알림 설정',
                          subtitle: '푸시 알림, 이메일 알림 관리',
                          onTap: () => context.push('/notification-settings'),
                        ),
                        _SettingItem(
                          icon: Icons.history,
                          title: '채팅 기록 관리',
                          subtitle: '대화 내용 백업 및 삭제',
                          onTap: () => context.push('/chat-history'),
                        ),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      // 계정 및 보안 섹션
                      _buildSectionHeader('계정 및 보안'),
                      _buildSettingsCard([
                        _SettingItem(
                          icon: Icons.lock_reset,
                          title: '비밀번호 변경',
                          subtitle: '새로운 비밀번호로 변경하기',
                          onTap: () => _sendPasswordReset(context, ref),
                        ),
                        _SettingItem(
                          icon: Icons.security,
                          title: '보안 설정',
                          subtitle: '계정 보안 관리',
                          onTap: () => context.push('/security-settings'),
                        ),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      // 앱 설정 섹션
                      _buildSectionHeader('앱 설정'),
                      _buildSettingsCard([
                        _SettingItem(
                          icon: Icons.palette_outlined,
                          title: '테마 설정',
                          subtitle: '다크모드, 폰트 크기',
                          onTap: () => context.push('/theme-settings'),
                        ),
                        _SettingItem(
                          icon: Icons.language,
                          title: '언어 설정',
                          subtitle: '한국어',
                          onTap: () => context.push('/language-settings'),
                        ),
                        _SettingItem(
                          icon: Icons.storage,
                          title: '저장소 관리',
                          subtitle: '캐시 삭제, 데이터 사용량',
                          onTap: () => context.push('/storage-settings'),
                        ),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      // 지원 및 정보 섹션
                      _buildSectionHeader('지원 및 정보'),
                      _buildSettingsCard([
                        _SettingItem(
                          icon: Icons.help_outline,
                          title: '고객센터',
                          subtitle: 'FAQ, 문의하기',
                          onTap: () => context.push('/support'),
                        ),
                        _SettingItem(
                          icon: Icons.history,
                          title: '내 문의 내역',
                          subtitle: '이전 문의 내용 및 답변 확인',
                          onTap: () => context.push('/inquiry-history'),
                        ),
                        _SettingItem(
                          icon: Icons.article_outlined,
                          title: '이용약관',
                          subtitle: '서비스 이용약관 확인',
                          onTap: () => context.push('/terms-of-service'),
                        ),
                        _SettingItem(
                          icon: Icons.policy_outlined,
                          title: '개인정보 처리방침',
                          subtitle: '개인정보 보호 정책',
                          onTap: () => context.push('/privacy-policy'),
                        ),
                        _SettingItem(
                          icon: Icons.info_outline,
                          title: '앱 정보',
                          subtitle: '버전 1.0.0',
                          onTap: () => context.push('/app-info'),
                        ),
                      ]),
                      
                      const SizedBox(height: 40),
                      
                      // 로그아웃 버튼
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showLogoutDialog(context, ref),
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text(
                            '로그아웃',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '설정',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, AsyncValue<dynamic> user) {
    return user.when(
      data: (userData) => userData != null
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryColor,
                    child: userData.photoUrl != null
                        ? ClipOval(
                            child: Image.network(
                              userData.photoUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.displayName ?? '사용자',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: userData.isSubscribed ? AppTheme.calmColor : AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            userData.isSubscribed ? '프리미엄' : '무료 플랜',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/profile'),
                    icon: const Icon(
                      Icons.chevron_right,
                      color: AppTheme.textHint,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<_SettingItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          
          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    color: AppTheme.accentColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                subtitle: Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                trailing: item.trailing ?? const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textHint,
                ),
                onTap: item.onTap,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 68,
                  endIndent: 20,
                  color: Colors.grey[200],
                ),
            ],
          );
        }).toList(),
      ),
    );
  }


  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('로그아웃', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  void _sendPasswordReset(BuildContext context, WidgetRef ref) async {
    final user = ref.read(currentUserProvider).value;
    if (user?.email == null) return;

    try {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .sendPasswordResetEmail(user!.email);
          
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success 
                ? '비밀번호 재설정 메일을 발송했습니다'
                : '메일 발송에 실패했습니다',
          ),
          backgroundColor: success ? AppTheme.calmColor : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });
}