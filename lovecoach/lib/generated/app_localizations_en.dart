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

  @override
  String welcomeMessage(String userName) {
    return 'Hello, $userName!';
  }

  @override
  String get defaultUserName => 'User';

  @override
  String get chatGreeting => 'Hello! 👋';

  @override
  String get crushChatWelcome =>
      'Hello! I\'m Love Coach here to help with your crush concerns. 💕 Please tell me about your situation in detail.';

  @override
  String get relationshipChatWelcome =>
      'Hello! I\'m Love Coach for those in relationships. ❤️ What\'s going on?';

  @override
  String get breakupChatWelcome =>
      'Hello! I\'m Love Coach here to heal hearts after breakups. 💙 You\'re going through a tough time. Please share your story.';

  @override
  String get reunionChatWelcome =>
      'Hello! I\'m Love Coach specializing in reconciliation. 💚 Your feelings must be complex. Please tell me about your situation.';

  @override
  String get themePreviewMessage1 => 'Hello! How are you feeling today?';

  @override
  String get themePreviewMessage2 =>
      'Hello! I\'m your relationship counselor. I\'m curious about how your day went.';
}
