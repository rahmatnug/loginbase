class User {
  String _username;
  String _password;
  DateTime _lastLogin;

  User({
    required String username,
    required String password,
  })  : _username = username,
        _password = password,
        _lastLogin = DateTime.now() {
    // Hanya validasi username tidak boleh kosong
    if (username.isEmpty) {
      throw ArgumentError('Username tidak boleh kosong');
    }
  }

  // Getters
  String get username => _username;
  String get password => _password;
  DateTime get lastLogin => _lastLogin;

  // Username setter dengan validasi
  set username(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Username tidak boleh kosong');
    }
    _username = value;
  }

  // Password setter tanpa validasi
  set password(String value) {
    _password = value;
  }

  // Method untuk validasi password
  bool validatePassword(String password) {
    return _password == password;
  }

  // Method untuk update last login
  void updateLastLogin() {
    _lastLogin = DateTime.now();
  }

  // Konversi ke Map untuk storage
  Map<String, dynamic> toMap() {
    return {
      'username': _username,
      'password': _password,
      'lastLogin': _lastLogin.toIso8601String(),
    };
  }

  // Konstruktor dari Map untuk storage
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
    ).._lastLogin = DateTime.parse(map['lastLogin']);
  }
}