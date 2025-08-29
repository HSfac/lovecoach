import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/ai_model_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/survey_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final selectedAI = ref.watch(selectedAIModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: user.when(
        data: (userData) => userData != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 프로필 헤더
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: userData.photoUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      userData.photoUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userData.displayName ?? '사용자',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 구독 상태
                    _ProfileItem(
                      icon: Icons.star,
                      title: '구독 상태',
                      subtitle: userData.isSubscribed ? '프리미엄 구독중' : '무료 플랜',
                      trailing: userData.isSubscribed 
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : TextButton(
                              onPressed: () => context.push('/subscription'),
                              child: const Text('업그레이드'),
                            ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 무료 상담 횟수
                    if (!userData.isSubscribed) ...[
                      _ProfileItem(
                        icon: Icons.chat_bubble_outline,
                        title: '무료 상담 현황',
                        subtitle: userData.consultationStatusMessage,
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${userData.freeConsultationsUsed}/${userData.freeConsultationsLimit}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '하루 1회',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // 설문조사 결과 메뉴 (임시 비활성화)
                    _ProfileItem(
                      icon: Icons.assignment_outlined,
                      title: '설문조사 하기',
                      subtitle: '맞춤형 상담을 위한 설문조사',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '미완료',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () => context.push('/survey'),
                    ),
                    const SizedBox(height: 16),
                    
                    // AI 설정 메뉴
                    _ProfileItem(
                      icon: Icons.psychology,
                      title: 'AI 설정',
                      subtitle: '현재: ${selectedAI.displayName}',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(selectedAI.icon, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () => context.push('/ai-settings'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 메인 설정 메뉴
                    _ProfileItem(
                      icon: Icons.settings,
                      title: '설정',
                      subtitle: '알림, 테마, 개인정보 등 모든 설정',
                      onTap: () => context.push('/settings'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 설정 메뉴
                    _ProfileItem(
                      icon: Icons.help_outline,
                      title: '고객센터',
                      subtitle: '문의사항이 있으시면 연락주세요',
                      onTap: () => context.push('/support'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _ProfileItem(
                      icon: Icons.info_outline,
                      title: '앱 정보',
                      subtitle: '버전 1.0.0',
                      onTap: () {
                        // 앱 정보 기능
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 계정 관리
                    _ProfileItem(
                      icon: Icons.manage_accounts,
                      title: '계정 관리',
                      subtitle: '계정 삭제, 데이터 관리',
                      onTap: () => _showAccountManagementDialog(context, ref),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 로그아웃 버튼
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await ref.read(authNotifierProvider.notifier).signOut();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          '로그아웃',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(child: Text('사용자 정보를 찾을 수 없습니다')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
      ),
    );
  }

  void _showAccountManagementDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '계정 관리',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email, color: AppTheme.accentColor),
              title: const Text('이메일 인증 확인'),
              subtitle: const Text('이메일 인증 상태를 확인합니다'),
              onTap: () {
                Navigator.pop(context);
                _checkEmailVerification(context, ref);
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_reset, color: AppTheme.primaryColor),
              title: const Text('비밀번호 변경'),
              subtitle: const Text('비밀번호 재설정 메일을 발송합니다'),
              onTap: () {
                Navigator.pop(context);
                _sendPasswordReset(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('계정 삭제'),
              subtitle: const Text('모든 데이터가 영구 삭제됩니다'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteAccountDialog(context, ref);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _checkEmailVerification(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authNotifierProvider.notifier).reloadUser();
      final isVerified = ref.read(authNotifierProvider.notifier).isEmailVerified;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isVerified ? '이메일 인증이 완료되었습니다 ✅' : '이메일 인증이 필요합니다 ⚠️',
          ),
          backgroundColor: isVerified ? AppTheme.calmColor : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('확인 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Text(
          '계정을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.\n\n• 채팅 기록\n• 구독 정보\n• 프로필 정보\n\n이 작업은 되돌릴 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteAccount(context, ref);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('계정을 삭제하는 중...'),
            ],
          ),
        ),
      );

      final success = await ref.read(authNotifierProvider.notifier).deleteAccount();
      
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('계정이 성공적으로 삭제되었습니다.'),
            backgroundColor: AppTheme.calmColor,
          ),
        );
        context.go('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('계정 삭제에 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSurveyResultDialog(BuildContext context, SurveyModel survey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.assignment, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            const Text('설문조사 결과'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SurveyResultItem(
                label: '성별',
                value: survey.genderDisplayText,
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _SurveyResultItem(
                label: '연령대',
                value: survey.ageDisplayText,
                icon: Icons.cake,
              ),
              const SizedBox(height: 16),
              _SurveyResultItem(
                label: '연애 상태',
                value: survey.relationshipStatusDisplayText,
                icon: Icons.favorite,
              ),
              const SizedBox(height: 16),
              _SurveyResultItem(
                label: '관심 주제',
                value: survey.interestsDisplayText,
                icon: Icons.interests,
                isMultiLine: true,
              ),
              const SizedBox(height: 16),
              _SurveyResultItem(
                label: '대화 스타일',
                value: survey.communicationStyleDisplayText,
                icon: Icons.chat_bubble,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.calmColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppTheme.calmColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '설문조사 완료: ${_formatDateTime(survey.completedAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.calmColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/survey');
            },
            child: const Text('수정하기'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일';
  }
}

class _SurveyResultItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isMultiLine;

  const _SurveyResultItem({
    required this.label,
    required this.value,
    required this.icon,
    this.isMultiLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: isMultiLine ? null : 1,
                overflow: isMultiLine ? null : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}