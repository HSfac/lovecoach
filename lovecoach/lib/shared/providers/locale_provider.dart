import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 지원하는 언어 목록
enum SupportedLocale {
  korean(Locale('ko', 'KR'), '한국어', '🇰🇷'),
  english(Locale('en', 'US'), 'English', '🇺🇸'),
  japanese(Locale('ja', 'JP'), '日本語', '🇯🇵'),
  chinese(Locale('zh', 'CN'), '中文', '🇨🇳');

  const SupportedLocale(this.locale, this.displayName, this.flag);

  final Locale locale;
  final String displayName;
  final String flag;

  static SupportedLocale fromLocale(Locale locale) {
    return values.firstWhere(
      (supportedLocale) => 
          supportedLocale.locale.languageCode == locale.languageCode &&
          supportedLocale.locale.countryCode == locale.countryCode,
      orElse: () => SupportedLocale.korean, // 기본값
    );
  }

  static SupportedLocale fromLanguageCode(String languageCode) {
    return values.firstWhere(
      (supportedLocale) => supportedLocale.locale.languageCode == languageCode,
      orElse: () => SupportedLocale.korean, // 기본값
    );
  }
}

// 언어 설정 상태 관리
final localeProvider = StateNotifierProvider<LocaleNotifier, LocaleState>((ref) {
  return LocaleNotifier();
});

class LocaleState {
  final SupportedLocale currentLocale;
  final bool useSystemLocale;
  final bool isLoading;

  const LocaleState({
    required this.currentLocale,
    this.useSystemLocale = true,
    this.isLoading = false,
  });

  LocaleState copyWith({
    SupportedLocale? currentLocale,
    bool? useSystemLocale,
    bool? isLoading,
  }) {
    return LocaleState(
      currentLocale: currentLocale ?? this.currentLocale,
      useSystemLocale: useSystemLocale ?? this.useSystemLocale,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LocaleNotifier extends StateNotifier<LocaleState> {
  static const String _localeKey = 'selected_locale';
  static const String _useSystemLocaleKey = 'use_system_locale';

  LocaleNotifier() : super(const LocaleState(
    currentLocale: SupportedLocale.korean,
    useSystemLocale: true,
  )) {
    _loadLocaleSettings();
  }

  Future<void> _loadLocaleSettings() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final useSystemLocale = prefs.getBool(_useSystemLocaleKey) ?? true;
      
      SupportedLocale currentLocale;
      
      if (useSystemLocale) {
        // 시스템 언어 감지
        final systemLocale = _getSystemLocale();
        currentLocale = SupportedLocale.fromLanguageCode(systemLocale.languageCode);
      } else {
        final savedLocaleCode = prefs.getString(_localeKey);
        if (savedLocaleCode != null) {
          currentLocale = SupportedLocale.values.firstWhere(
            (locale) => locale.name == savedLocaleCode,
            orElse: () => SupportedLocale.korean,
          );
        } else {
          currentLocale = SupportedLocale.korean;
        }
      }
      
      state = LocaleState(
        currentLocale: currentLocale,
        useSystemLocale: useSystemLocale,
        isLoading: false,
      );
    } catch (e) {
      // SharedPreferences 오류시 기본값 유지
      state = state.copyWith(isLoading: false);
    }
  }

  Locale _getSystemLocale() {
    final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
    if (systemLocales.isNotEmpty) {
      return systemLocales.first;
    }
    return const Locale('ko', 'KR'); // 기본값
  }

  Future<void> setLocale(SupportedLocale locale) async {
    state = state.copyWith(
      currentLocale: locale,
      useSystemLocale: false,
    );
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.name);
      await prefs.setBool(_useSystemLocaleKey, false);
    } catch (e) {
      // SharedPreferences 저장 실패는 무시
    }
  }

  Future<void> setUseSystemLocale(bool useSystem) async {
    if (useSystem) {
      final systemLocale = _getSystemLocale();
      final supportedLocale = SupportedLocale.fromLanguageCode(systemLocale.languageCode);
      
      state = LocaleState(
        currentLocale: supportedLocale,
        useSystemLocale: true,
      );
    } else {
      state = state.copyWith(useSystemLocale: false);
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_useSystemLocaleKey, useSystem);
      if (!useSystem) {
        await prefs.setString(_localeKey, state.currentLocale.name);
      }
    } catch (e) {
      // SharedPreferences 저장 실패는 무시
    }
  }

  // 시스템 언어 변경 감지 (앱이 포그라운드로 돌아올 때 호출)
  Future<void> checkSystemLocaleChange() async {
    if (state.useSystemLocale) {
      final systemLocale = _getSystemLocale();
      final newSupportedLocale = SupportedLocale.fromLanguageCode(systemLocale.languageCode);
      
      if (newSupportedLocale != state.currentLocale) {
        state = state.copyWith(currentLocale: newSupportedLocale);
      }
    }
  }
}

// 현재 로케일을 직접 반환하는 편의 Provider
final currentLocaleProvider = Provider<Locale>((ref) {
  final localeState = ref.watch(localeProvider);
  return localeState.currentLocale.locale;
});

// 지원되는 모든 로케일 목록 Provider
final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  return SupportedLocale.values.map((e) => e.locale).toList();
});