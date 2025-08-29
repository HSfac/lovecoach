import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  // AI API Keys
  static String get openaiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static String get claudeApiKey => dotenv.env['CLAUDE_API_KEY'] ?? '';
  
  // AI 설정
  static String get defaultAiModel => dotenv.env['DEFAULT_AI_MODEL'] ?? 'openai';

  // Firebase
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAuthDomain => dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';
  static String get firebaseStorageBucket => dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  // Toss Payments
  static String get tossClientKey => dotenv.env['TOSS_CLIENT_KEY'] ?? '';
  static String get tossSecretKey => dotenv.env['TOSS_SECRET_KEY'] ?? '';

  // Environment
  static String get environment => dotenv.env['ENV'] ?? 'development';
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
}