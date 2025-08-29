import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../generated/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.profile),
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
                            userData.displayName ?? AppLocalizations.of(context)!.defaultUserName,
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
                    
                    const SizedBox(height: 24),
                    
                    // 사용자 레벨 카드
                    _buildUserLevelCard(userData),
                    
                    const SizedBox(height: 24),
                    
                    // 구독 상태
                    _ProfileItem(
                      icon: Icons.star,
                      title: AppLocalizations.of(context)!.subscriptionStatus,
                      subtitle: userData.isSubscribed ? AppLocalizations.of(context)!.premiumSubscribed : AppLocalizations.of(context)!.freePlan,
                      trailing: userData.isSubscribed 
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : TextButton(
                              onPressed: () => context.push('/subscription'),
                              child: Text(AppLocalizations.of(context)!.upgrade),
                            ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 무료 상담 횟수
                    if (!userData.isSubscribed) ...[
                      _ProfileItem(
                        icon: Icons.chat_bubble_outline,
                        title: AppLocalizations.of(context)!.freeConsultationStatus,
                        subtitle: userData.consultationStatusMessage,
                        trailing: Text(
                          '${userData.dailyConsultationsUsed}/${userData.dailyConsultationsLimit}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // 설문조사 상태
                    _ProfileItem(
                      icon: Icons.assignment_outlined,
                      title: userData.hasCompletedSurvey ? AppLocalizations.of(context)!.surveyResults : AppLocalizations.of(context)!.takeSurvey,
                      subtitle: userData.hasCompletedSurvey 
                          ? '맞춤형 상담을 위한 설문조사 완료'
                          : '맞춤형 상담을 위한 설문조사',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: userData.hasCompletedSurvey
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              userData.hasCompletedSurvey ? AppLocalizations.of(context)!.completed : AppLocalizations.of(context)!.incomplete,
                              style: TextStyle(
                                fontSize: 12,
                                color: userData.hasCompletedSurvey 
                                    ? Colors.green 
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () {
                        if (userData.hasCompletedSurvey) {
                          _showSurveyResult(context, ref, userData.id);
                        } else {
                          context.push('/survey');
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // AI 설정 메뉴
                    _ProfileItem(
                      icon: Icons.psychology,
                      title: AppLocalizations.of(context)!.aiSettings,
                      subtitle: '${AppLocalizations.of(context)!.current}: ${selectedAI.displayName}',
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
                      title: AppLocalizations.of(context)!.settings,
                      subtitle: '알림, 테마, 개인정보 등 모든 설정',
                      onTap: () => context.push('/settings'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 설정 메뉴
                    _ProfileItem(
                      icon: Icons.help_outline,
                      title: AppLocalizations.of(context)!.support,
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
                        label: Text(
                          AppLocalizations.of(context)!.logout,
                          style: const TextStyle(color: Colors.red),
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

  void _showSurveyResult(BuildContext context, WidgetRef ref, String userId) async {
    try {
      final authService = ref.read(authServiceProvider);
      final surveyData = await authService.getSurveyData(userId);
      
      if (surveyData != null && context.mounted) {
        _showSurveyResultDialog(context, surveyData);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('설문조사 결과를 찾을 수 없습니다.'),
            backgroundColor: Colors.orange,
          ),
        );
        context.push('/survey');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('설문조사 결과를 불러오는 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              title: Text(AppLocalizations.of(context)!.changePassword),
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
            child: Text(AppLocalizations.of(context)!.cancel),
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
            Text(AppLocalizations.of(context)!.surveyResults),
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
          TextButton(
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

  Widget _buildUserLevelCard(userData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _getLevelIcon(userData.userLevel),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Lv.${userData.userLevel}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            userData.userRank,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${userData.experiencePoints} EXP',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 경험치 바
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '다음 레벨까지',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHint,
                    ),
                  ),
                  Text(
                    userData.levelProgressText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: userData.levelProgress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
                minHeight: 6,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 통계 정보
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '총 상담',
                  '${userData.totalConsultations}회',
                  Icons.chat_bubble_outline,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildStatItem(
                  '연속 접속',
                  '${userData.currentStreak}일',
                  Icons.local_fire_department,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildStatItem(
                  '활동 일수',
                  '${userData.consecutiveDays}일',
                  Icons.calendar_today,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.accentColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textHint,
          ),
        ),
      ],
    );
  }

  IconData _getLevelIcon(int level) {
    if (level <= 3) return Icons.emoji_events;
    if (level <= 7) return Icons.military_tech;
    if (level <= 15) return Icons.diamond;
    if (level <= 25) return Icons.auto_awesome;
    return Icons.emoji_objects;
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