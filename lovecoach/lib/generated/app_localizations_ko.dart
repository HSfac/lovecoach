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

  @override
  String get appName => '러브코치';

  @override
  String get appSubtitle => 'AI와 함께하는 연애 상담';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get forgotPasswordDescription =>
      '등록하신 이메일 주소를 입력해주세요.\\n비밀번호 재설정 링크를 보내드립니다.';

  @override
  String get emailAddress => '이메일 주소';

  @override
  String get enterEmail => '이메일을 입력해주세요';

  @override
  String get enterValidEmail => '올바른 이메일 형식을 입력해주세요';

  @override
  String get sendResetEmail => '비밀번호 재설정 메일 발송';

  @override
  String get backToLogin => '로그인으로 돌아가기';

  @override
  String get login => '로그인';

  @override
  String get register => '회원가입';

  @override
  String get password => '비밀번호';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get email => '이메일';

  @override
  String get enterPassword => '비밀번호를 입력해주세요';

  @override
  String get passwordMinLength => '비밀번호는 6자리 이상이어야 합니다';

  @override
  String get signInWithGoogle => 'Google로 로그인';

  @override
  String get testAccountLogin => '테스트 계정으로 바로 입장';

  @override
  String get noAccount => '계정이 없으신가요?';

  @override
  String get signUp => '회원가입';

  @override
  String get loginFailed => '로그인에 실패했습니다. 다시 시도해주세요.';

  @override
  String get googleSignInFailed => 'Google 로그인에 실패했습니다.';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요?';

  @override
  String get name => '이름';

  @override
  String get enterName => '이름을 입력해주세요';

  @override
  String get nameMinLength => '이름은 2자리 이상이어야 합니다';

  @override
  String get enterConfirmPassword => '비밀번호 확인을 입력해주세요';

  @override
  String get passwordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get agreeToTerms => '서비스 이용약관에 동의합니다';

  @override
  String get agreeToTermsRequired => '서비스 이용약관에 동의해주세요.';

  @override
  String get signUpFailed => '회원가입에 실패했습니다. 다시 시도해주세요.';

  @override
  String get user => '사용자';

  @override
  String get premium => '프리미엄';

  @override
  String get freePlan => '무료 플랜';

  @override
  String get aiModelSettings => 'AI 모델 설정';

  @override
  String get current => '현재';

  @override
  String get notificationSettings => '알림 설정';

  @override
  String get chatHistoryManagement => '채팅 기록 관리';

  @override
  String get accountAndSecurity => '계정 및 보안';

  @override
  String get changePassword => '비밀번호 변경';

  @override
  String get securitySettings => '보안 설정';

  @override
  String get appSettings => '앱 설정';

  @override
  String get themeSettings => '테마 설정';

  @override
  String get storageManagement => '저장소 관리';

  @override
  String get supportAndInfo => '지원 및 정보';

  @override
  String get customerSupport => '고객센터';

  @override
  String get logout => '로그아웃';

  @override
  String get confirmLogout => '정말 로그아웃 하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get subscriptionStatus => '구독 상태';

  @override
  String get premiumSubscribed => '프리미엄 구독중';

  @override
  String get upgrade => '업그레이드';

  @override
  String get freeConsultationStatus => '무료 상담 현황';

  @override
  String get surveyResults => '설문조사 결과';

  @override
  String get takeSurvey => '설문조사 하기';

  @override
  String get completed => '완료';

  @override
  String get incomplete => '미완료';

  @override
  String get aiSettings => 'AI 설정';

  @override
  String get support => '고객지원';

  @override
  String get faq => '자주 묻는 질문';

  @override
  String get oneToOneInquiry => '1:1 문의하기';

  @override
  String get inquiryContent => '문의 내용';

  @override
  String get inquire => '문의하기';

  @override
  String get contactInfo => '연락처 정보';

  @override
  String get responseTime => '응답 시간';
}
