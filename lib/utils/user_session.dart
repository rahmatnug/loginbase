// lib/utils/user_session.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserSession {
  static final List<User> _users = [];
  static const String _userKey = 'users_data';

  static List<User> get users => List.unmodifiable(_users);

  // Load users dari SharedPreferences saat startup
  static Future<void> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_userKey);
    if (usersJson != null) {
      _users.clear();
      for (final userJson in usersJson) {
        final userData = json.decode(userJson);
        _users.add(User.fromMap(userData));
      }
    }
  }

  // Simpan users ke SharedPreferences
  static Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = _users.map((user) => json.encode(user.toMap())).toList();
    await prefs.setStringList(_userKey, usersJson);
  }

  static bool usernameExists(String username) {
    return _users.any((u) => u.username == username);
  }

  static void addUser(User user) {
    _users.add(user);
    _saveUsers(); // Simpan setelah menambah user
  }

  static User? findUser(String username, String password) {
    try {
      return _users.firstWhere(
        (u) => u.username == username && u.validatePassword(password),
      );
    } catch (_) {
      return null;
    }
  }

  static bool updateUsername(String oldName, String newName) {
    final index = _users.indexWhere((u) => u.username == oldName);
    if (index == -1) return false;

    final user = _users[index];
    final currentPassword = user.password;
    _users[index] = User(username: newName, password: currentPassword);
    _saveUsers(); // Simpan setelah update username
    return true;
  }

  static void clearUsers() {
    _users.clear();
    _saveUsers(); // Simpan setelah clear
  }
}