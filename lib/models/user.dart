class User {
  String _username;
  String _password;
  DateTime _lastLogin;

  User({
    required String username,
    required String password,
    DateTime? lastLogin,
  })  : _username = username,
        _password = password,
        _lastLogin = lastLogin ?? DateTime.now() {
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

  // Password setter
  set password(String value) {
    _password = value;
  }

  // Update last login
  void updateLastLogin() {
    _lastLogin = DateTime.now();
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'username': _username,
      'password': _password,
      'lastLogin': _lastLogin.toIso8601String(),
    };
  }

  // Create from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      password: map['password'] as String,
      lastLogin: DateTime.parse(map['lastLogin'] as String),
    );
  }
}