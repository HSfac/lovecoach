import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      appBar: AppBar(
        title: const Text('앱 정보'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 앱 로고 및 기본 정보
              _buildAppHeader(context),
              
              const SizedBox(height: 32),
              
              // 버전 정보
              _buildVersionInfo(),
              
              const SizedBox(height: 24),
              
              // 개발 정보
              _buildDeveloperInfo(),
              
              const SizedBox(height: 24),
              
              // 라이선스 정보
              _buildLicenseInfo(context),
              
              const SizedBox(height: 24),
              
              // 오픈소스 라이브러리
              _buildOpenSourceLibraries(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 앱 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 앱 이름
          const Text(
            '러브코치',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 앱 설명
          const Text(
            'AI와 함께하는 연애 상담',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 앱 스토어 링크 (버튼)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStoreButton(
                icon: Icons.phone_iphone,
                label: 'App Store',
                onTap: () => _showComingSoon(context, 'App Store'),
              ),
              _buildStoreButton(
                icon: Icons.android,
                label: 'Play Store',
                onTap: () => _showComingSoon(context, 'Play Store'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.backgroundStart,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.accentColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return _buildInfoCard(
      title: '버전 정보',
      icon: Icons.info_outline,
      children: [
        _buildInfoRow('앱 버전', '1.0.0'),
        _buildInfoRow('빌드 번호', '1'),
        _buildInfoRow('Flutter 버전', '3.29.3'),
        _buildInfoRow('마지막 업데이트', '2024.08.24'),
      ],
    );
  }

  Widget _buildDeveloperInfo() {
    return _buildInfoCard(
      title: '개발 정보',
      icon: Icons.code,
      children: [
        _buildInfoRow('개발자', 'LoveCoach Team'),
        _buildInfoRow('이메일', 'dev@lovecoach.app'),
        _buildInfoRow('웹사이트', 'www.lovecoach.app'),
        _buildInfoRow('저작권', '© 2024 LoveCoach. All rights reserved.'),
      ],
    );
  }

  Widget _buildLicenseInfo(BuildContext context) {
    return _buildInfoCard(
      title: '라이선스',
      icon: Icons.assignment,
      children: [
        ListTile(
          title: const Text('오픈소스 라이선스'),
          subtitle: const Text('사용된 오픈소스 라이브러리 정보'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLicensePage(context),
          contentPadding: EdgeInsets.zero,
        ),
        ListTile(
          title: const Text('서드파티 서비스'),
          subtitle: const Text('Firebase, OpenAI, Claude API'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThirdPartyInfo(context),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildOpenSourceLibraries(BuildContext context) {
    final libraries = [
      LibraryInfo('Flutter', 'Google', 'BSD-3-Clause'),
      LibraryInfo('Firebase SDK', 'Google', 'Apache-2.0'),
      LibraryInfo('Riverpod', 'Remi Rousselet', 'MIT'),
      LibraryInfo('Go Router', 'Flutter Team', 'BSD-3-Clause'),
      LibraryInfo('Dio HTTP Client', 'cfug', 'MIT'),
    ];

    return _buildInfoCard(
      title: '주요 오픈소스 라이브러리',
      icon: Icons.library_books,
      children: libraries.map((lib) => 
        ListTile(
          title: Text(lib.name),
          subtitle: Text('${lib.author} • ${lib.license}'),
          trailing: IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: () => _copyToClipboard(context, '${lib.name} by ${lib.author}'),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ).toList(),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showLicensePage(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: '러브코치',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.accentColor],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.favorite, color: Colors.white, size: 24),
      ),
    );
  }

  void _showThirdPartyInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('서드파티 서비스'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('본 앱은 다음 서드파티 서비스를 사용합니다:\n'),
              Text('• Firebase (Google): 백엔드 서비스'),
              Text('• OpenAI: AI 상담 서비스'),
              Text('• Anthropic Claude: AI 상담 서비스'),
              Text('• Apple/Google: 인앱 결제'),
              Text('\n각 서비스는 해당 업체의 개인정보 처리방침을 따릅니다.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String store) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$store 출시 준비 중입니다'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('클립보드에 복사되었습니다'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

class LibraryInfo {
  final String name;
  final String author;
  final String license;

  LibraryInfo(this.name, this.author, this.license);
}