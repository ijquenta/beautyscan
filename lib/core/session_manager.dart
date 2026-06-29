import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUserId = 'session_user_id';
  static const String _keyImageGeneration = 'image_generation_enabled';
  static const String _keyOnboardingDone = 'onboarding_done';

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_keyOnboardingDone) ?? false);
  }

  static Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingDone, true);
  }

  static Future<void> saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
  }

  static Future<int?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyImageGeneration);
  }

  static Future<bool> isLoggedIn() async {
    final userId = await getLoggedInUserId();
    return userId != null;
  }

  static Future<void> setImageGenerationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyImageGeneration, enabled);
  }

  static Future<bool> isImageGenerationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyImageGeneration) ?? true;
  }
}
