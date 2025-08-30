import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @languageSettings.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get languageSettings;

  /// No description provided for @languageSettingsMode.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정 모드'**
  String get languageSettingsMode;

  /// No description provided for @useSystemLanguage.
  ///
  /// In ko, this message translates to:
  /// **'시스템 언어 사용'**
  String get useSystemLanguage;

  /// No description provided for @useSystemLanguageDescription.
  ///
  /// In ko, this message translates to:
  /// **'기기의 언어 설정을 따릅니다'**
  String get useSystemLanguageDescription;

  /// No description provided for @currentLanguage.
  ///
  /// In ko, this message translates to:
  /// **'현재 언어'**
  String get currentLanguage;

  /// No description provided for @languageSelection.
  ///
  /// In ko, this message translates to:
  /// **'언어 선택'**
  String get languageSelection;

  /// No description provided for @languageSettingsInfo.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정 정보'**
  String get languageSettingsInfo;

  /// No description provided for @korean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @english.
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In ko, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @chinese.
  ///
  /// In ko, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @englishSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'English (US)'**
  String get englishSubtitle;

  /// No description provided for @japaneseSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'日本語 (일본어)'**
  String get japaneseSubtitle;

  /// No description provided for @chineseSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'中文简体 (중국어 간체)'**
  String get chineseSubtitle;

  /// No description provided for @realTimeTranslation.
  ///
  /// In ko, this message translates to:
  /// **'실시간 번역'**
  String get realTimeTranslation;

  /// No description provided for @realTimeTranslationDescription.
  ///
  /// In ko, this message translates to:
  /// **'선택한 언어로 AI 상담사와 실시간 대화가 가능합니다'**
  String get realTimeTranslationDescription;

  /// No description provided for @aiModelOptimization.
  ///
  /// In ko, this message translates to:
  /// **'AI 모델 최적화'**
  String get aiModelOptimization;

  /// No description provided for @aiModelOptimizationDescription.
  ///
  /// In ko, this message translates to:
  /// **'각 언어에 특화된 AI 모델이 더 자연스러운 상담을 제공합니다'**
  String get aiModelOptimizationDescription;

  /// No description provided for @instantApplication.
  ///
  /// In ko, this message translates to:
  /// **'즉시 적용'**
  String get instantApplication;

  /// No description provided for @instantApplicationDescription.
  ///
  /// In ko, this message translates to:
  /// **'언어 변경 시 앱 전체에 즉시 적용되며 재시작이 필요없습니다'**
  String get instantApplicationDescription;

  /// No description provided for @chatHistoryPreservation.
  ///
  /// In ko, this message translates to:
  /// **'언어 변경 후에도 이전 대화 기록은 그대로 유지됩니다'**
  String get chatHistoryPreservation;

  /// No description provided for @home.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get home;

  /// No description provided for @chat.
  ///
  /// In ko, this message translates to:
  /// **'채팅'**
  String get chat;

  /// No description provided for @community.
  ///
  /// In ko, this message translates to:
  /// **'커뮤니티'**
  String get community;

  /// No description provided for @profile.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @welcomeMessage.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요, {userName}님!'**
  String welcomeMessage(String userName);

  /// No description provided for @defaultUserName.
  ///
  /// In ko, this message translates to:
  /// **'사용자'**
  String get defaultUserName;

  /// No description provided for @chatGreeting.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! 👋'**
  String get chatGreeting;

  /// No description provided for @crushChatWelcome.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! 썸 관련 고민을 들어드릴 러브코치입니다. 💕 어떤 상황인지 자세히 말씀해 주세요.'**
  String get crushChatWelcome;

  /// No description provided for @relationshipChatWelcome.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! 연애 중인 분들의 고민을 상담해드리는 러브코치입니다. ❤️ 어떤 일이 있으셨나요?'**
  String get relationshipChatWelcome;

  /// No description provided for @breakupChatWelcome.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! 이별 후의 마음을 치료해드리는 러브코치입니다. 💙 힘든 시간을 겪고 계시는군요. 천천히 이야기해 주세요.'**
  String get breakupChatWelcome;

  /// No description provided for @reunionChatWelcome.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! 재회에 관한 상담을 도와드리는 러브코치입니다. 💚 복잡한 마음일 텐데, 상황을 자세히 들려주세요.'**
  String get reunionChatWelcome;

  /// No description provided for @themePreviewMessage1.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! 오늘 기분이 어떠신가요?'**
  String get themePreviewMessage1;

  /// No description provided for @themePreviewMessage2.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! 저는 당신의 연애 상담사입니다. 오늘 하루 어떻게 보내셨는지 궁금해요.'**
  String get themePreviewMessage2;

  /// No description provided for @appName.
  ///
  /// In ko, this message translates to:
  /// **'러브코치'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'AI와 함께하는 연애 상담'**
  String get appSubtitle;

  /// No description provided for @forgotPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 잊으셨나요?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In ko, this message translates to:
  /// **'등록하신 이메일 주소를 입력해주세요.\\n비밀번호 재설정 링크를 보내드립니다.'**
  String get forgotPasswordDescription;

  /// No description provided for @emailAddress.
  ///
  /// In ko, this message translates to:
  /// **'이메일 주소'**
  String get emailAddress;

  /// No description provided for @enterEmail.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요'**
  String get enterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일 형식을 입력해주세요'**
  String get enterValidEmail;

  /// No description provided for @sendResetEmail.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 재설정 메일 발송'**
  String get sendResetEmail;

  /// No description provided for @backToLogin.
  ///
  /// In ko, this message translates to:
  /// **'로그인으로 돌아가기'**
  String get backToLogin;

  /// No description provided for @login.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get login;

  /// No description provided for @register.
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get register;

  /// No description provided for @password.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get confirmPassword;

  /// No description provided for @email.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get email;

  /// No description provided for @enterPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력해주세요'**
  String get enterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 6자리 이상이어야 합니다'**
  String get passwordMinLength;

  /// No description provided for @signInWithGoogle.
  ///
  /// In ko, this message translates to:
  /// **'Google로 로그인'**
  String get signInWithGoogle;

  /// No description provided for @testAccountLogin.
  ///
  /// In ko, this message translates to:
  /// **'테스트 계정으로 바로 입장'**
  String get testAccountLogin;

  /// No description provided for @noAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정이 없으신가요?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get signUp;

  /// No description provided for @loginFailed.
  ///
  /// In ko, this message translates to:
  /// **'로그인에 실패했습니다. 다시 시도해주세요.'**
  String get loginFailed;

  /// No description provided for @googleSignInFailed.
  ///
  /// In ko, this message translates to:
  /// **'Google 로그인에 실패했습니다.'**
  String get googleSignInFailed;

  /// No description provided for @testAccountSuccess.
  ///
  /// In ko, this message translates to:
  /// **'테스트 계정으로 로그인되었습니다.'**
  String get testAccountSuccess;

  /// No description provided for @testAccountFailed.
  ///
  /// In ko, this message translates to:
  /// **'테스트 계정 로그인에 실패했습니다.'**
  String get testAccountFailed;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ko, this message translates to:
  /// **'이미 계정이 있으신가요?'**
  String get alreadyHaveAccount;

  /// No description provided for @name.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해주세요'**
  String get enterName;

  /// No description provided for @nameMinLength.
  ///
  /// In ko, this message translates to:
  /// **'이름은 2자리 이상이어야 합니다'**
  String get nameMinLength;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인을 입력해주세요'**
  String get enterConfirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않습니다'**
  String get passwordMismatch;

  /// No description provided for @agreeToTerms.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용약관에 동의합니다'**
  String get agreeToTerms;

  /// No description provided for @agreeToTermsRequired.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용약관에 동의해주세요.'**
  String get agreeToTermsRequired;

  /// No description provided for @signUpFailed.
  ///
  /// In ko, this message translates to:
  /// **'회원가입에 실패했습니다. 다시 시도해주세요.'**
  String get signUpFailed;

  /// No description provided for @user.
  ///
  /// In ko, this message translates to:
  /// **'사용자'**
  String get user;

  /// No description provided for @premium.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄'**
  String get premium;

  /// No description provided for @freePlan.
  ///
  /// In ko, this message translates to:
  /// **'무료 플랜'**
  String get freePlan;

  /// No description provided for @aiModelSettings.
  ///
  /// In ko, this message translates to:
  /// **'AI 모델 설정'**
  String get aiModelSettings;

  /// No description provided for @current.
  ///
  /// In ko, this message translates to:
  /// **'현재'**
  String get current;

  /// No description provided for @notificationSettings.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get notificationSettings;

  /// No description provided for @chatHistoryManagement.
  ///
  /// In ko, this message translates to:
  /// **'채팅 기록 관리'**
  String get chatHistoryManagement;

  /// No description provided for @accountAndSecurity.
  ///
  /// In ko, this message translates to:
  /// **'계정 및 보안'**
  String get accountAndSecurity;

  /// No description provided for @changePassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경'**
  String get changePassword;

  /// No description provided for @securitySettings.
  ///
  /// In ko, this message translates to:
  /// **'보안 설정'**
  String get securitySettings;

  /// No description provided for @appSettings.
  ///
  /// In ko, this message translates to:
  /// **'앱 설정'**
  String get appSettings;

  /// No description provided for @themeSettings.
  ///
  /// In ko, this message translates to:
  /// **'테마 설정'**
  String get themeSettings;

  /// No description provided for @storageManagement.
  ///
  /// In ko, this message translates to:
  /// **'저장소 관리'**
  String get storageManagement;

  /// No description provided for @supportAndInfo.
  ///
  /// In ko, this message translates to:
  /// **'지원 및 정보'**
  String get supportAndInfo;

  /// No description provided for @customerSupport.
  ///
  /// In ko, this message translates to:
  /// **'고객센터'**
  String get customerSupport;

  /// No description provided for @logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In ko, this message translates to:
  /// **'정말 로그아웃 하시겠습니까?'**
  String get confirmLogout;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @subscriptionStatus.
  ///
  /// In ko, this message translates to:
  /// **'구독 상태'**
  String get subscriptionStatus;

  /// No description provided for @premiumSubscribed.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 구독중'**
  String get premiumSubscribed;

  /// No description provided for @upgrade.
  ///
  /// In ko, this message translates to:
  /// **'업그레이드'**
  String get upgrade;

  /// No description provided for @freeConsultationStatus.
  ///
  /// In ko, this message translates to:
  /// **'무료 상담 현황'**
  String get freeConsultationStatus;

  /// No description provided for @surveyResults.
  ///
  /// In ko, this message translates to:
  /// **'설문조사 결과'**
  String get surveyResults;

  /// No description provided for @takeSurvey.
  ///
  /// In ko, this message translates to:
  /// **'설문조사 하기'**
  String get takeSurvey;

  /// No description provided for @completed.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get completed;

  /// No description provided for @incomplete.
  ///
  /// In ko, this message translates to:
  /// **'미완료'**
  String get incomplete;

  /// No description provided for @aiSettings.
  ///
  /// In ko, this message translates to:
  /// **'AI 설정'**
  String get aiSettings;

  /// No description provided for @support.
  ///
  /// In ko, this message translates to:
  /// **'고객지원'**
  String get support;

  /// No description provided for @faq.
  ///
  /// In ko, this message translates to:
  /// **'자주 묻는 질문'**
  String get faq;

  /// No description provided for @oneToOneInquiry.
  ///
  /// In ko, this message translates to:
  /// **'1:1 문의하기'**
  String get oneToOneInquiry;

  /// No description provided for @inquiryContent.
  ///
  /// In ko, this message translates to:
  /// **'문의 내용'**
  String get inquiryContent;

  /// No description provided for @inquire.
  ///
  /// In ko, this message translates to:
  /// **'문의하기'**
  String get inquire;

  /// No description provided for @contactInfo.
  ///
  /// In ko, this message translates to:
  /// **'연락처 정보'**
  String get contactInfo;

  /// No description provided for @responseTime.
  ///
  /// In ko, this message translates to:
  /// **'응답 시간'**
  String get responseTime;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
