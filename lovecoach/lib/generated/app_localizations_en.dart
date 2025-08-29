// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get languageSettingsMode => 'Language Settings Mode';

  @override
  String get useSystemLanguage => 'Use System Language';

  @override
  String get useSystemLanguageDescription =>
      'Follow the device\'s language settings';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get languageSelection => 'Language Selection';

  @override
  String get languageSettingsInfo => 'Language Settings Information';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get chinese => '中文';

  @override
  String get englishSubtitle => 'English (US)';

  @override
  String get japaneseSubtitle => '日本語 (Japanese)';

  @override
  String get chineseSubtitle => '中文简体 (Simplified Chinese)';

  @override
  String get realTimeTranslation => 'Real-time Translation';

  @override
  String get realTimeTranslationDescription =>
      'Chat with AI counselor in real-time in your selected language';

  @override
  String get aiModelOptimization => 'AI Model Optimization';

  @override
  String get aiModelOptimizationDescription =>
      'Language-specific AI models provide more natural counseling experiences';

  @override
  String get instantApplication => 'Instant Application';

  @override
  String get instantApplicationDescription =>
      'Language changes are applied instantly across the app without restart';

  @override
  String get chatHistoryPreservation =>
      'Previous chat history is preserved even after language changes';

  @override
  String get home => 'Home';

  @override
  String get chat => 'Chat';

  @override
  String get community => 'Community';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';
}
