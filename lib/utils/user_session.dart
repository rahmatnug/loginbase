// lib/utils/user_session.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../data/user_data.dart';

class UserSession {
  static final List<User> _users = [];
  static const String _userKey = 'users_data';
  static const String _currentUserKey = 'current_user';
  static User? _currentUser;

  static List<User> get users => List.unmodifiable(_users);
  static User? get currentUser => _currentUser;

  static Future<void> initialize() async {
    await loadUsers();
    await _loadCurrentUser();

    // Add default users if no users exist
    if (_users.isEmpty) {
      _users.addAll(UserData.users);
      await _saveUsers();
    }
  }

  // Load users dari SharedPreferences saat startup
  static Future<void> loadUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_userKey);
      if (usersJson != null) {
        _users.clear();
        for (final userJson in usersJson) {
          final userData = json.decode(userJson);
          _users.add(User.fromMap(userData));
        }
      }
    } catch (e) {
      print('Error loading users: $e');
      // If loading fails, use default users
      _users.clear();
      _users.addAll(UserData.users);
    }
  }

  static Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUsername = prefs.getString(_currentUserKey);
      if (currentUsername != null) {
        _currentUser = _users.firstWhere((user) => user.username == currentUsername);
      }
    } catch (e) {
      print('Error loading current user: $e');
      _currentUser = null;
    }
  }

  // Simpan users ke SharedPreferences
  static Future<void> _saveUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = _users.map((user) => json.encode(user.toMap())).toList();
      await prefs.setStringList(_userKey, usersJson);
    } catch (e) {
      print('Error saving users: $e');
    }
  }

  static Future<bool> addUser(User user) async {
    if (!_users.any((u) => u.username == user.username)) {
      _users.add(user);
      await _saveUsers();
      return true;
    }
    return false;
  }

  static User? findUser(String username, String password) {
    try {
      final user = _users.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      user.updateLastLogin();
      _saveUsers(); // Update last login time
      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateUsername(String oldUsername, String newUsername) async {
    if (_users.any((u) => u.username == newUsername)) {
      return false;
    }

    final userIndex = _users.indexWhere((u) => u.username == oldUsername);
    if (userIndex != -1) {
      final user = _users[userIndex];
      user.username = newUsername;
      await _saveUsers();

      // Update current user key if needed
      if (_currentUser?.username == oldUsername) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, newUsername);
      }
      return true;
    }
    return false;
  }

  static Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, user.username);
  }

  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  static bool isLoggedIn() {
    return _currentUser != null;
  }

  static bool usernameExists(String username) {
    return _users.any((user) => user.username == username);
  }
}