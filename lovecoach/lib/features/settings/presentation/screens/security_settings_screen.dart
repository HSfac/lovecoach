import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/services/security_settings_service.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> 
    with WidgetsBindingObserver {
  bool _loginNotificationsEnabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSecuritySettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // 앱이 포그라운드로 돌아왔을 때 사용자 상태 새로고침
    if (state == AppLifecycleState.resumed) {
      ref.read(authNotifierProvider.notifier).reloadUser();
    }
  }

  Future<void> _loadSecuritySettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final loginNotificationsEnabled = await SecuritySettingsService.instance.getLoginNotificationsEnabled();
      
      setState(() {
        _loginNotificationsEnabled = loginNotificationsEnabled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _loginNotificationsEnabled = true; // 기본값
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkThemeProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : AppTheme.backgroundStart,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [AppTheme.backgroundStart, AppTheme.backgroundEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAccountSecurity(context, currentUser, isDark),
                            const SizedBox(height: 24),
                            _buildSecurityActions(context, isDark),
                            const SizedBox(height: 24),
                            _buildNotificationSettings(context, isDark),
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '보안 설정',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.security,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSecurity(BuildContext context, AsyncValue<dynamic> currentUser, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '계정 보안 상태',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: currentUser.when(
            data: (user) => user != null 
                ? Column(
                    children: [
                      _buildSecurityStatusItem(
                        icon: user.emailVerified ? Icons.verified_user : Icons.warning,
                        title: '이메일 인증',
                        subtitle: user.emailVerified ? '인증 완료' : '인증이 필요합니다',
                        status: user.emailVerified,
                        onTap: user.emailVerified ? null : () => _sendEmailVerification(),
                        isDark: isDark,
                      ),
                      if (!user.emailVerified) ...[
                        Divider(height: 1, color: isDark ? Colors.grey[600] : Colors.grey[300]),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.refresh,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            '인증 상태 새로고침',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppTheme.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            '이메일 인증 완료 후 클릭하세요',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _refreshEmailVerification(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        ),
                      ],
                    ],
                  )
                : const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }


  Widget _buildNotificationSettings(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '보안 알림',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SwitchListTile(
            title: Text(
              '로그인 알림',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            subtitle: Text(
              '새로운 기기에서 로그인 시 이메일로 알림',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
              ),
            ),
            value: _loginNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _loginNotificationsEnabled = value;
              });
              _saveSecuritySettings();
            },
            activeColor: AppTheme.primaryColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }


  Widget _buildSecurityActions(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '계정 관리',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.lock_reset,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              '비밀번호 변경',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            subtitle: Text(
              '이메일로 비밀번호 재설정 링크를 받으세요',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _changePassword(context),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityStatusItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool status,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: status 
              ? AppTheme.calmColor.withOpacity(0.1)
              : Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: status ? AppTheme.calmColor : Colors.orange,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status)
            Icon(
              Icons.check_circle,
              color: AppTheme.calmColor,
              size: 16,
            ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Future<void> _sendEmailVerification() async {
    try {
      await ref.read(authNotifierProvider.notifier).sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('인증 이메일을 발송했습니다. 이메일을 확인하신 후 새로고침 버튼을 눌러주세요.'),
          backgroundColor: AppTheme.calmColor,
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

  Future<void> _refreshEmailVerification() async {
    try {
      await ref.read(authNotifierProvider.notifier).reloadUser();
      
      final user = ref.read(currentUserProvider).value;
      final isVerified = user?.emailVerified ?? false;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isVerified ? '이메일 인증이 완료되었습니다 ✅' : '아직 인증이 완료되지 않았습니다 ⏳',
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

  Future<void> _saveSecuritySettings() async {
    try {
      await SecuritySettingsService.instance.setLoginNotificationsEnabled(_loginNotificationsEnabled);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('설정 저장 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _changePassword(BuildContext context) async {
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