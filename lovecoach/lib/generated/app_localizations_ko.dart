// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get languageSettings => '언어 설정';

  @override
  String get languageSettingsMode => '언어 설정 모드';

  @override
  String get useSystemLanguage => '시스템 언어 사용';

  @override
  String get useSystemLanguageDescription => '기기의 언어 설정을 따릅니다';

  @override
  String get currentLanguage => '현재 언어';

  @override
  String get languageSelection => '언어 선택';

  @override
  String get languageSettingsInfo => '언어 설정 정보';

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
  String get japaneseSubtitle => '日本語 (일본어)';

  @override
  String get chineseSubtitle => '中文简体 (중국어 간체)';

  @override
  String get realTimeTranslation => '실시간 번역';

  @override
  String get realTimeTranslationDescription => '선택한 언어로 AI 상담사와 실시간 대화가 가능합니다';

  @override
  String get aiModelOptimization => 'AI 모델 최적화';

  @override
  String get aiModelOptimizationDescription =>
      '각 언어에 특화된 AI 모델이 더 자연스러운 상담을 제공합니다';

  @override
  String get instantApplication => '즉시 적용';

  @override
  String get instantApplicationDescription =>
      '언어 변경 시 앱 전체에 즉시 적용되며 재시작이 필요없습니다';

  @override
  String get chatHistoryPreservation => '언어 변경 후에도 이전 대화 기록은 그대로 유지됩니다';

  @override
  String get home => '홈';

  @override
  String get chat => '채팅';

  @override
  String get community => '커뮤니티';

  @override
  String get profile => '프로필';

  @override
  String get settings => '설정';

  @override
  String welcomeMessage(String userName) {
    return '안녕하세요, $userName님!';
  }

  @override
  String get defaultUserName => '사용자';

  @override
  String get chatGreeting => '안녕하세요! 👋';

  @override
  String get crushChatWelcome =>
      '안녕하세요! 썸 관련 고민을 들어드릴 러브코치입니다. 💕 어떤 상황인지 자세히 말씀해 주세요.';

  @override
  String get relationshipChatWelcome =>
      '안녕하세요! 연애 중인 분들의 고민을 상담해드리는 러브코치입니다. ❤️ 어떤 일이 있으셨나요?';

  @override
  String get breakupChatWelcome =>
      '안녕하세요! 이별 후의 마음을 치료해드리는 러브코치입니다. 💙 힘든 시간을 겪고 계시는군요. 천천히 이야기해 주세요.';

  @override
  String get reunionChatWelcome =>
      '안녕하세요! 재회에 관한 상담을 도와드리는 러브코치입니다. 💚 복잡한 마음일 텐데, 상황을 자세히 들려주세요.';

  @override
  String get themePreviewMessage1 => '안녕하세요! 오늘 기분이 어떠신가요?';

  @override
  String get themePreviewMessage2 =>
      '안녕하세요! 저는 당신의 연애 상담사입니다. 오늘 하루 어떻게 보내셨는지 궁금해요.';
}
