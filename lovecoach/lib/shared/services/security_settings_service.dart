import 'package:shared_preferences/shared_preferences.dart';

class SecuritySettingsService {
  static const String _loginNotificationsKey = 'login_notifications_enabled';
  
  static SecuritySettingsService? _instance;
  static SecuritySettingsService get instance {
    _instance ??= SecuritySettingsService._internal();
    return _instance!;
  }
  
  SecuritySettingsService._internal();

  Future<bool> getLoginNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginNotificationsKey) ?? true; // 기본값은 true
  }

  Future<void> setLoginNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginNotificationsKey, enabled);
  }
}