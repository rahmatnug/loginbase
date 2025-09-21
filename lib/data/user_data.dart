import '../models/user.dart';

/// Data user simulasi untuk login
/// Bisa kamu tambah/ubah sesuai kebutuhan
class UserData {
  static final List<User> users = [
    User(username: 'putra', password: '123456'),
    User(username: 'admin', password: 'password'),
    User(username: 'guest', password: 'guest123'),
  ];

  /// Fungsi untuk validasi login
  static User? login(String username, String password) {
    try {
      return users.firstWhere(
        (user) => user.username == username && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}