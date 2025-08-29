import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../generated/app_localizations.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(localeProvider);
    final isDark = ref.watch(isDarkThemeProvider);
    final l10n = AppLocalizations.of(context);

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
              _buildHeader(context, l10n!, isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSystemLanguageSection(context, ref, localeState, l10n, isDark),
                      const SizedBox(height: 32),
                      if (!localeState.useSystemLocale)
                        _buildLanguageSelection(context, ref, localeState, l10n, isDark),
                      const SizedBox(height: 32),
                      _buildLanguageInfo(context, l10n!, isDark),
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isDark) {
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
            l10n.languageSettings,
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
              Icons.language,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemLanguageSection(BuildContext context, WidgetRef ref, LocaleState localeState, AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.languageSettingsMode,
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
              SwitchListTile(
                title: Text(
                  l10n.useSystemLanguage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
                subtitle: Text(
                  l10n.useSystemLanguageDescription,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
                  ),
                ),
                value: localeState.useSystemLocale,
                onChanged: (value) {
                  ref.read(localeProvider.notifier).setUseSystemLocale(value);
                },
                activeColor: AppTheme.primaryColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              if (localeState.useSystemLocale) ...[
                Divider(height: 1, color: isDark ? Colors.grey[600] : Colors.grey[300]),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          localeState.currentLocale.flag,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.currentLanguage,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey[400] : AppTheme.textHint,
                            ),
                          ),
                          Text(
                            localeState.currentLocale.displayName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.calmColor,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelection(BuildContext context, WidgetRef ref, LocaleState localeState, AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.languageSelection,
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
            children: SupportedLocale.values.asMap().entries.map((entry) {
              final index = entry.key;
              final supportedLocale = entry.value;
              final isSelected = localeState.currentLocale == supportedLocale;
              final isLast = index == SupportedLocale.values.length - 1;
              
              return Column(
                children: [
                  _buildLanguageOption(
                    context: context,
                    ref: ref,
                    supportedLocale: supportedLocale,
                    isSelected: isSelected,
                    isDark: isDark,
                  ),
                  if (!isLast)
                    Divider(height: 1, color: isDark ? Colors.grey[600] : Colors.grey[300]),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required WidgetRef ref,
    required SupportedLocale supportedLocale,
    required bool isSelected,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor.withOpacity(0.1)
              : (isDark ? Colors.grey[700] : AppTheme.accentColor.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          supportedLocale.flag,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(
        supportedLocale.displayName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected 
              ? AppTheme.primaryColor
              : (isDark ? Colors.white : AppTheme.textPrimary),
        ),
      ),
      subtitle: Text(
        _getLanguageSubtitle(supportedLocale, AppLocalizations.of(context)),
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: AppTheme.primaryColor,
            )
          : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(supportedLocale);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  String _getLanguageSubtitle(SupportedLocale locale, AppLocalizations? l10n) {
    if (l10n == null) {
      // Fallback values when l10n is null
      switch (locale) {
        case SupportedLocale.korean:
          return '한국어';
        case SupportedLocale.english:
          return 'English (US)';
        case SupportedLocale.japanese:
          return '日本語 (일본어)';
        case SupportedLocale.chinese:
          return '中文简体 (중국어 간체)';
      }
    }
    
    switch (locale) {
      case SupportedLocale.korean:
        return l10n.korean;
      case SupportedLocale.english:
        return l10n.englishSubtitle;
      case SupportedLocale.japanese:
        return l10n.japaneseSubtitle;
      case SupportedLocale.chinese:
        return l10n.chineseSubtitle;
    }
  }

  Widget _buildLanguageInfo(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.languageSettingsInfo,
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
              _buildInfoItem(
                icon: Icons.translate,
                title: '실시간 번역',
                description: '선택한 언어로 AI 상담사와 실시간 대화가 가능합니다',
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                icon: Icons.psychology,
                title: 'AI 모델 최적화',
                description: '각 언어에 특화된 AI 모델이 더 자연스러운 상담을 제공합니다',
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                icon: Icons.update,
                title: '즉시 적용',
                description: '언어 변경 시 앱 전체에 즉시 적용되며 재시작이 필요없습니다',
                isDark: isDark,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.chatHistoryPreservation,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[300] : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: AppTheme.accentColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : AppTheme.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}