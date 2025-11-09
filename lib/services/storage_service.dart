import 'package:shared_preferences/shared_preferences.dart';

class StorageKeys {
  static const savedLocation = 'saved_location_text';
  static const profileImagePath = 'profile_image_path';
  static const authToken = 'auth_token';
}

class StorageService {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
