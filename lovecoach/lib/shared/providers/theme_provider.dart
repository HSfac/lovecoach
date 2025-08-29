import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 테마 모드 상태 관리
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

// 폰트 크기 상태 관리
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  return FontSizeNotifier();
});

class ThemeState {
  final ThemeMode themeMode;
  final bool useSystemTheme;

  const ThemeState({
    required this.themeMode,
    required this.useSystemTheme,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? useSystemTheme,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeModeKey = 'theme_mode';
  static const String _useSystemThemeKey = 'use_system_theme';

  ThemeNotifier() : super(const ThemeState(
    themeMode: ThemeMode.system,
    useSystemTheme: true,
  )) {
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final useSystemTheme = prefs.getBool(_useSystemThemeKey) ?? true;
      final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0;
      
      final themeMode = ThemeMode.values[themeModeIndex];
      
      state = ThemeState(
        themeMode: themeMode,
        useSystemTheme: useSystemTheme,
      );
    } catch (e) {
      // SharedPreferences 오류시 기본값 유지
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final newState = state.copyWith(
      themeMode: mode,
      useSystemTheme: mode == ThemeMode.system,
    );
    
    state = newState;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);
      await prefs.setBool(_useSystemThemeKey, mode == ThemeMode.system);
    } catch (e) {
      // SharedPreferences 저장 실패는 무시
    }
  }

  Future<void> toggleSystemTheme(bool useSystem) async {
    if (useSystem) {
      await setThemeMode(ThemeMode.system);
    }
  }
}

class FontSizeNotifier extends StateNotifier<double> {
  static const String _fontSizeKey = 'font_size_scale';
  static const double _defaultFontSize = 1.0;
  static const double _minFontSize = 0.8;
  static const double _maxFontSize = 1.5;

  FontSizeNotifier() : super(_defaultFontSize) {
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fontSize = prefs.getDouble(_fontSizeKey) ?? _defaultFontSize;
      state = fontSize.clamp(_minFontSize, _maxFontSize);
    } catch (e) {
      // SharedPreferences 오류시 기본값 유지
    }
  }

  Future<void> setFontSize(double size) async {
    final clampedSize = size.clamp(_minFontSize, _maxFontSize);
    state = clampedSize;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, clampedSize);
    } catch (e) {
      // SharedPreferences 저장 실패는 무시
    }
  }

  Future<void> resetFontSize() async {
    await setFontSize(_defaultFontSize);
  }

  double get minFontSize => _minFontSize;
  double get maxFontSize => _maxFontSize;
  double get defaultFontSize => _defaultFontSize;
}

// 다크 테마 여부 확인을 위한 편의 Provider
final isDarkThemeProvider = Provider<bool>((ref) {
  final themeState = ref.watch(themeProvider);
  
  if (themeState.useSystemTheme) {
    // 시스템 테마 사용시 현재 시스템 설정을 따름
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
  
  return themeState.themeMode == ThemeMode.dark;
});