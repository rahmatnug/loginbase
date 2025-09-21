import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _usernameKey = 'username';
  static const String _scoreKey = 'scores';

  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> clearUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
  }

  static Future<void> saveScores(List<String> scores) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_scoreKey, scores);
  }

  static Future<List<String>?> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_scoreKey);
  }

  static Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scoreKey);
  }
}
