// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get languageSettings => '言語設定';

  @override
  String get languageSettingsMode => '言語設定モード';

  @override
  String get useSystemLanguage => 'システム言語を使用';

  @override
  String get useSystemLanguageDescription => 'デバイスの言語設定に従います';

  @override
  String get currentLanguage => '現在の言語';

  @override
  String get languageSelection => '言語選択';

  @override
  String get languageSettingsInfo => '言語設定情報';

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
  String get realTimeTranslation => 'リアルタイム翻訳';

  @override
  String get realTimeTranslationDescription => '選択した言語でAIカウンセラーとリアルタイムで会話できます';

  @override
  String get aiModelOptimization => 'AIモデル最適化';

  @override
  String get aiModelOptimizationDescription =>
      '各言語に特化したAIモデルが、より自然なカウンセリングを提供します';

  @override
  String get instantApplication => '即座に適用';

  @override
  String get instantApplicationDescription => '言語変更時にアプリ全体に即座に適用され、再起動は不要です';

  @override
  String get chatHistoryPreservation => '言語変更後も以前のチャット履歴は保持されます';

  @override
  String get home => 'ホーム';

  @override
  String get chat => 'チャット';

  @override
  String get community => 'コミュニティ';

  @override
  String get profile => 'プロフィール';

  @override
  String get settings => '設定';

  @override
  String welcomeMessage(String userName) {
    return 'こんにちは、$userNameさん！';
  }

  @override
  String get defaultUserName => 'ユーザー';

  @override
  String get chatGreeting => 'こんにちは！ 👋';

  @override
  String get crushChatWelcome =>
      'こんにちは！片思いのお悩みをお聞きするラブコーチです。💕 どのような状況か詳しくお聞かせください。';

  @override
  String get relationshipChatWelcome =>
      'こんにちは！恋愛中の方のお悩みを相談に乗るラブコーチです。❤️ どのようなことがありましたか？';

  @override
  String get breakupChatWelcome =>
      'こんにちは！別れた後の心を癒すラブコーチです。💙 辛い時間を過ごしていらっしゃいますね。ゆっくりとお話しください。';

  @override
  String get reunionChatWelcome =>
      'こんにちは！復縁に関する相談をサポートするラブコーチです。💚 複雑な気持ちでしょうが、状況を詳しくお聞かせください。';

  @override
  String get themePreviewMessage1 => 'こんにちは！今日の気分はいかがですか？';

  @override
  String get themePreviewMessage2 => 'こんにちは！あなたの恋愛カウンセラーです。今日一日はどのように過ごされましたか？';
}
