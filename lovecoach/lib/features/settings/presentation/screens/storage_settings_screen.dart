import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/storage_provider.dart';
import '../../../../shared/providers/theme_provider.dart';

class StorageSettingsScreen extends ConsumerWidget {
  const StorageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageState = ref.watch(storageProvider);
    final autoClearSettings = ref.watch(autoClearSettingsProvider);
    final isDark = ref.watch(isDarkThemeProvider);

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
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(storageProvider.notifier).calculateStorageSize();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStorageOverview(context, ref, storageState, isDark),
                        const SizedBox(height: 32),
                        _buildCacheManagement(context, ref, storageState, isDark),
                        const SizedBox(height: 32),
                        _buildAutoCleanSettings(context, ref, autoClearSettings, isDark),
                        const SizedBox(height: 32),
                        _buildDataBackupInfo(context, isDark),
                      ],
                    ),
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
            '저장소 관리',
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
              Icons.storage,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageOverview(BuildContext context, WidgetRef ref, StorageState storageState, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '저장소 사용량',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
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
          child: storageState.isLoading
              ? const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('저장소 정보를 계산하는 중...'),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildStorageItem(
                      icon: Icons.folder,
                      title: '전체 캐시',
                      size: storageState.totalCacheSizeFormatted,
                      color: AppTheme.primaryColor,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildStorageItem(
                      icon: Icons.image,
                      title: '이미지 캐시',
                      size: storageState.imageCacheSizeFormatted,
                      color: AppTheme.secondaryColor,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildStorageItem(
                      icon: Icons.chat_bubble,
                      title: '채팅 데이터',
                      size: storageState.chatCacheSizeFormatted,
                      color: AppTheme.accentColor,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildStorageItem(
                      icon: Icons.file_present,
                      title: '임시 파일',
                      size: storageState.tempFileSizeFormatted,
                      color: AppTheme.calmColor,
                      isDark: isDark,
                    ),
                    if (storageState.error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        storageState.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildStorageItem({
    required IconData icon,
    required String title,
    required String size,
    required Color color,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppTheme.textPrimary,
            ),
          ),
        ),
        Text(
          size,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[300] : AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCacheManagement(BuildContext context, WidgetRef ref, StorageState storageState, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '캐시 관리',
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
          child: Column(
            children: [
              _buildCacheAction(
                icon: Icons.clear_all,
                title: '전체 캐시 삭제',
                subtitle: '모든 캐시를 삭제합니다',
                color: Colors.red,
                onTap: () => _showClearAllDialog(context, ref),
                isDark: isDark,
              ),
              Divider(height: 1, color: isDark ? Colors.grey[600] : Colors.grey[300]),
              _buildCacheAction(
                icon: Icons.image,
                title: '이미지 캐시 삭제',
                subtitle: '저장된 이미지 파일을 삭제합니다',
                color: AppTheme.secondaryColor,
                onTap: () => _showClearImageDialog(context, ref),
                isDark: isDark,
              ),
              Divider(height: 1, color: isDark ? Colors.grey[600] : Colors.grey[300]),
              _buildCacheAction(
                icon: Icons.chat_bubble,
                title: '채팅 캐시 삭제',
                subtitle: '대화 관련 임시 데이터를 삭제합니다',
                color: AppTheme.accentColor,
                onTap: () => _showClearChatDialog(context, ref),
                isDark: isDark,
              ),
              Divider(height: 1, color: isDark ? Colors.grey[600] : Colors.grey[300]),
              _buildCacheAction(
                icon: Icons.file_present,
                title: '임시 파일 삭제',
                subtitle: '앱에서 생성한 임시 파일을 삭제합니다',
                color: AppTheme.calmColor,
                onTap: () => _showClearTempDialog(context, ref),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCacheAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
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
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildAutoCleanSettings(BuildContext context, WidgetRef ref, AutoClearSettings settings, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '자동 정리 설정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                  '자동 캐시 정리',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
                subtitle: Text(
                  '설정된 주기마다 자동으로 캐시를 정리합니다',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
                  ),
                ),
                value: settings.enableAutoClearing,
                onChanged: (value) {
                  ref.read(autoClearSettingsProvider.notifier).setAutoClearing(value);
                },
                activeColor: AppTheme.primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
              if (settings.enableAutoClearing) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '정리 주기',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppTheme.textPrimary,
                      ),
                    ),
                    DropdownButton<int>(
                      value: settings.autoClearDays,
                      items: [1, 3, 7, 14, 30].map((days) {
                        return DropdownMenuItem(
                          value: days,
                          child: Text('$days일'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(autoClearSettingsProvider.notifier).setAutoClearDays(value);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('앱 시작시 정리'),
                  value: settings.clearOnAppStart,
                  onChanged: (value) {
                    ref.read(autoClearSettingsProvider.notifier).setClearOnAppStart(value ?? false);
                  },
                  activeColor: AppTheme.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: const Text('이미지 캐시 포함'),
                  value: settings.clearImages,
                  onChanged: (value) {
                    ref.read(autoClearSettingsProvider.notifier).setClearImages(value ?? false);
                  },
                  activeColor: AppTheme.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: const Text('임시 파일 포함'),
                  value: settings.clearTempFiles,
                  onChanged: (value) {
                    ref.read(autoClearSettingsProvider.notifier).setClearTempFiles(value ?? false);
                  },
                  activeColor: AppTheme.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataBackupInfo(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '데이터 백업 정보',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.cloud_done,
                    color: AppTheme.calmColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '클라우드 백업 상태: 활성화됨',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '• 채팅 기록은 자동으로 클라우드에 백업됩니다\n• 캐시 삭제 시 백업된 데이터는 영향받지 않습니다\n• 앱 재설치 시 백업된 데이터가 복원됩니다',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 캐시 삭제'),
        content: const Text('모든 캐시를 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없으며, 앱의 성능에 일시적으로 영향을 줄 수 있습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(storageProvider.notifier).clearAllCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? '전체 캐시가 삭제되었습니다' : '캐시 삭제에 실패했습니다'),
                    backgroundColor: success ? AppTheme.calmColor : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showClearImageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이미지 캐시 삭제'),
        content: const Text('저장된 이미지 캐시를 삭제하시겠습니까?\n\n이미지가 다시 로드될 때 시간이 걸릴 수 있습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(storageProvider.notifier).clearImageCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? '이미지 캐시가 삭제되었습니다' : '캐시 삭제에 실패했습니다'),
                    backgroundColor: success ? AppTheme.calmColor : Colors.red,
                  ),
                );
              }
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('채팅 캐시 삭제'),
        content: const Text('채팅 관련 임시 데이터를 삭제하시겠습니까?\n\n채팅 기록은 클라우드 백업으로 보호됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(storageProvider.notifier).clearChatCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? '채팅 캐시가 삭제되었습니다' : '캐시 삭제에 실패했습니다'),
                    backgroundColor: success ? AppTheme.calmColor : Colors.red,
                  ),
                );
              }
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showClearTempDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('임시 파일 삭제'),
        content: const Text('앱에서 생성한 임시 파일을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(storageProvider.notifier).clearTempFiles();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? '임시 파일이 삭제되었습니다' : '파일 삭제에 실패했습니다'),
                    backgroundColor: success ? AppTheme.calmColor : Colors.red,
                  ),
                );
              }
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}