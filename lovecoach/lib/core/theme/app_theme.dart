import 'package:flutter/material.dart';

class AppTheme {
  // 더 감성적이고 부드러운 컬러 팔레트
  static const Color primaryColor = Color(0xFFE91E63);      // 깊은 핑크 (Material Pink)
  static const Color primaryLight = Color(0xFFF8BBD9);      // 연한 핑크
  static const Color secondaryColor = Color(0xFFFF7043);    // 따뜻한 오렌지
  static const Color accentColor = Color(0xFF9C27B0);       // 보라색 (상담사 컬러)
  
  // 배경 그라데이션 색상
  static const Color backgroundStart = Color(0xFFFFF5F5);   // 매우 연한 핑크
  static const Color backgroundEnd = Color(0xFFFFF0F5);     // 연한 핑크
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFEFEFE);
  
  // 텍스트 컬러
  static const Color textPrimary = Color(0xFF1A1A1A);       // 거의 블랙
  static const Color textSecondary = Color(0xFF666666);     // 미디엄 그레이
  static const Color textHint = Color(0xFF999999);          // 라이트 그레이
  
  // AI 상담사 컬러
  static const Color aiMessageColor = Color(0xFFF3E5F5);    // 연한 보라
  static const Color userMessageColor = Color(0xFFE1F5FE);  // 연한 블루
  
  // 감정 상태 컬러
  static const Color happyColor = Color(0xFFFFC107);        // 노랑 (행복)
  static const Color sadColor = Color(0xFF2196F3);          // 블루 (슬픔)
  static const Color angryColor = Color(0xFFF44336);        // 빨강 (분노)
  static const Color calmColor = Color(0xFF4CAF50);         // 그린 (평온)

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),
      fontFamily: 'Pretendard',
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundStart,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      fontFamily: 'Pretendard',
    );
  }
}