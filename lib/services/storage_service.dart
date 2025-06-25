import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isFirstTime => _prefs?.getBool('first_time') ?? true;
  static set isFirstTime(bool value) => _prefs?.setBool('first_time', value);

  static bool get isLoggedIn => _prefs?.getBool('is_logged_in') ?? false;
  static set isLoggedIn(bool value) => _prefs?.setBool('is_logged_in', value);

  static String get userEmail => _prefs?.getString('user_email') ?? '';
  static set userEmail(String value) => _prefs?.setString('user_email', value);

  static Future<void> clearAll() async {
    await _prefs?.clear();
    isFirstTime = false; // Keep first time status
  }
}
