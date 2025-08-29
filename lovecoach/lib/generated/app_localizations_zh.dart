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

  @override
  String get appName => '恋爱教练';

  @override
  String get appSubtitle => 'AI陪伴的恋爱咨询';

  @override
  String get forgotPassword => '忘记密码了吗？';

  @override
  String get forgotPasswordDescription => '请输入您注册的邮箱地址。\\n我们将发送密码重置链接给您。';

  @override
  String get emailAddress => '邮箱地址';

  @override
  String get enterEmail => '请输入邮箱';

  @override
  String get enterValidEmail => '请输入正确的邮箱格式';

  @override
  String get sendResetEmail => '发送密码重置邮件';

  @override
  String get backToLogin => '返回登录';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get email => '邮箱';

  @override
  String get enterPassword => '请输入密码';

  @override
  String get passwordMinLength => '密码至少需要6位字符';

  @override
  String get signInWithGoogle => '使用Google登录';

  @override
  String get testAccountLogin => '使用测试账户进入';

  @override
  String get noAccount => '没有账户吗？';

  @override
  String get signUp => '注册';

  @override
  String get loginFailed => '登录失败，请重试。';

  @override
  String get googleSignInFailed => 'Google登录失败。';

  @override
  String get alreadyHaveAccount => '已有账户吗？';

  @override
  String get name => '姓名';

  @override
  String get enterName => '请输入姓名';

  @override
  String get nameMinLength => '姓名至少需要2个字符';

  @override
  String get enterConfirmPassword => '请输入确认密码';

  @override
  String get passwordMismatch => '密码不匹配';

  @override
  String get agreeToTerms => '我同意服务条款';

  @override
  String get agreeToTermsRequired => '请同意服务条款。';

  @override
  String get signUpFailed => '注册失败，请重试。';

  @override
  String get user => '用户';

  @override
  String get premium => '高级版';

  @override
  String get freePlan => '免费套餐';

  @override
  String get aiModelSettings => 'AI模型设置';

  @override
  String get current => '当前';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get chatHistoryManagement => '聊天记录管理';

  @override
  String get accountAndSecurity => '账户与安全';

  @override
  String get changePassword => '修改密码';

  @override
  String get securitySettings => '安全设置';

  @override
  String get appSettings => '应用设置';

  @override
  String get themeSettings => '主题设置';

  @override
  String get storageManagement => '存储管理';

  @override
  String get supportAndInfo => '支持与信息';

  @override
  String get customerSupport => '客服中心';

  @override
  String get logout => '退出登录';

  @override
  String get confirmLogout => '确定要退出登录吗？';

  @override
  String get cancel => '取消';

  @override
  String get subscriptionStatus => '订阅状态';

  @override
  String get premiumSubscribed => '已订阅高级版';

  @override
  String get upgrade => '升级';

  @override
  String get freeConsultationStatus => '免费咨询状态';

  @override
  String get surveyResults => '调查结果';

  @override
  String get takeSurvey => '参与调查';

  @override
  String get completed => '已完成';

  @override
  String get incomplete => '未完成';

  @override
  String get aiSettings => 'AI设置';

  @override
  String get support => '支持';

  @override
  String get faq => '常见问题';

  @override
  String get oneToOneInquiry => '1对1咨询';

  @override
  String get inquiryContent => '咨询内容';

  @override
  String get inquire => '咨询';

  @override
  String get contactInfo => '联系信息';

  @override
  String get responseTime => '回复时间';
}
