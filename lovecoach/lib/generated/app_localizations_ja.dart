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

  @override
  String get appName => 'ラブコーチ';

  @override
  String get appSubtitle => 'AIと一緒に恋愛相談';

  @override
  String get forgotPassword => 'パスワードを忘れましたか？';

  @override
  String get forgotPasswordDescription =>
      '登録されたメールアドレスを入力してください。\\nパスワードリセットリンクをお送りします。';

  @override
  String get emailAddress => 'メールアドレス';

  @override
  String get enterEmail => 'メールアドレスを入力してください';

  @override
  String get enterValidEmail => '正しいメールアドレスの形式を入力してください';

  @override
  String get sendResetEmail => 'パスワードリセットメール送信';

  @override
  String get backToLogin => 'ログインに戻る';

  @override
  String get login => 'ログイン';

  @override
  String get register => '会員登録';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワード確認';

  @override
  String get email => 'メール';

  @override
  String get enterPassword => 'パスワードを入力してください';

  @override
  String get passwordMinLength => 'パスワードは6文字以上である必要があります';

  @override
  String get signInWithGoogle => 'Googleでログイン';

  @override
  String get testAccountLogin => 'テストアカウントで入場';

  @override
  String get noAccount => 'アカウントをお持ちでないですか？';

  @override
  String get signUp => '会員登録';

  @override
  String get loginFailed => 'ログインに失敗しました。再度お試しください。';

  @override
  String get googleSignInFailed => 'Googleログインに失敗しました。';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get name => '名前';

  @override
  String get enterName => '名前を入力してください';

  @override
  String get nameMinLength => '名前は2文字以上である必要があります';

  @override
  String get enterConfirmPassword => 'パスワード確認を入力してください';

  @override
  String get passwordMismatch => 'パスワードが一致しません';

  @override
  String get agreeToTerms => '利用規約に同意します';

  @override
  String get agreeToTermsRequired => '利用規約に同意してください。';

  @override
  String get signUpFailed => '会員登録に失敗しました。再度お試しください。';

  @override
  String get user => 'ユーザー';

  @override
  String get premium => 'プレミアム';

  @override
  String get freePlan => '無料プラン';

  @override
  String get aiModelSettings => 'AIモデル設定';

  @override
  String get current => '現在';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get chatHistoryManagement => 'チャット履歴管理';

  @override
  String get accountAndSecurity => 'アカウント・セキュリティ';

  @override
  String get changePassword => 'パスワード変更';

  @override
  String get securitySettings => 'セキュリティ設定';

  @override
  String get appSettings => 'アプリ設定';

  @override
  String get themeSettings => 'テーマ設定';

  @override
  String get storageManagement => 'ストレージ管理';

  @override
  String get supportAndInfo => 'サポート・情報';

  @override
  String get customerSupport => 'カスタマーサポート';

  @override
  String get logout => 'ログアウト';

  @override
  String get confirmLogout => '本当にログアウトしますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get subscriptionStatus => '購読状況';

  @override
  String get premiumSubscribed => 'プレミアム購読中';

  @override
  String get upgrade => 'アップグレード';

  @override
  String get freeConsultationStatus => '無料相談状況';

  @override
  String get surveyResults => 'アンケート結果';

  @override
  String get takeSurvey => 'アンケートに答える';

  @override
  String get completed => '完了';

  @override
  String get incomplete => '未完了';

  @override
  String get aiSettings => 'AI設定';

  @override
  String get support => 'サポート';

  @override
  String get faq => 'FAQ';

  @override
  String get oneToOneInquiry => '1：1お問い合わせ';

  @override
  String get inquiryContent => 'お問い合わせ内容';

  @override
  String get inquire => 'お問い合わせ';

  @override
  String get contactInfo => '連絡先情報';

  @override
  String get responseTime => '応答時間';
}
