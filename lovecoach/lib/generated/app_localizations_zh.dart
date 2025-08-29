// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get languageSettings => '语言设置';

  @override
  String get languageSettingsMode => '语言设置模式';

  @override
  String get useSystemLanguage => '使用系统语言';

  @override
  String get useSystemLanguageDescription => '跟随设备的语言设置';

  @override
  String get currentLanguage => '当前语言';

  @override
  String get languageSelection => '语言选择';

  @override
  String get languageSettingsInfo => '语言设置信息';

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
  String get realTimeTranslation => '实时翻译';

  @override
  String get realTimeTranslationDescription => '可以用您选择的语言与AI咨询师实时对话';

  @override
  String get aiModelOptimization => 'AI模型优化';

  @override
  String get aiModelOptimizationDescription => '针对各种语言优化的AI模型提供更自然的咨询体验';

  @override
  String get instantApplication => '即时应用';

  @override
  String get instantApplicationDescription => '语言更改时会立即应用到整个应用，无需重启';

  @override
  String get chatHistoryPreservation => '语言更改后之前的聊天记录会被保留';

  @override
  String get home => '首页';

  @override
  String get chat => '聊天';

  @override
  String get community => '社区';

  @override
  String get profile => '个人资料';

  @override
  String get settings => '设置';

  @override
  String welcomeMessage(String userName) {
    return '您好，$userName！';
  }

  @override
  String get defaultUserName => '用户';

  @override
  String get chatGreeting => '您好！ 👋';

  @override
  String get crushChatWelcome => '您好！我是专门倾听暗恋烦恼的恋爱教练。💕 请详细告诉我您的情况。';

  @override
  String get relationshipChatWelcome => '您好！我是为恋爱中的朋友们提供咨询的恋爱教练。❤️ 发生了什么事？';

  @override
  String get breakupChatWelcome => '您好！我是治愈分手后心灵的恋爱教练。💙 您正在经历困难的时光。请慢慢告诉我。';

  @override
  String get reunionChatWelcome => '您好！我是帮助复合咨询的恋爱教练。💚 心情一定很复杂，请详细告诉我情况。';

  @override
  String get themePreviewMessage1 => '您好！今天心情怎么样？';

  @override
  String get themePreviewMessage2 => '您好！我是您的恋爱咨询师。今天过得怎么样呢？';
}
