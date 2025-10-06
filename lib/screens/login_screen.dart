import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../data/user_data.dart';
import '../utils/user_session.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _deviceInfo = '';
  bool _rememberMe = false;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeLogin();
  }

  Future<void> _initializeLogin() async {
    setState(() => _isLoading = true);
    await UserSession.initialize(); // Ensure user session is initialized
    await _loadSavedCredentials();
    await _getDeviceInfo();
    setState(() => _isLoading = false);
  }

  Future<void> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _deviceInfo = '${androidInfo.brand} ${androidInfo.model}';
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _deviceInfo = '${iosInfo.name} ${iosInfo.model}';
        });
      } else {
        final webInfo = await deviceInfo.webBrowserInfo;
        setState(() {
          _deviceInfo = '${webInfo.browserName} on ${webInfo.platform}';
        });
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
    }
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('saved_username');
      final savedPassword = prefs.getString('saved_password');
      final rememberMe = prefs.getBool('remember_me') ?? false;

      if (savedUsername != null && savedPassword != null && rememberMe) {
        setState(() {
          _usernameController.text = savedUsername;
          _passwordController.text = savedPassword;
          _rememberMe = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved credentials: $e');
    }
  }

  Future<void> _saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('saved_username', _usernameController.text);
        await prefs.setString('saved_password', _passwordController.text);
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('saved_username');
        await prefs.remove('saved_password');
        await prefs.remove('remember_me');
      }
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Username dan password harus diisi';
          _isLoading = false;
        });
        return;
      }

      // Try to find user
      final user = UserData.login(username, password) ?? UserSession.findUser(username, password);

      if (user != null) {
        await _saveCredentials();
        await UserSession.setCurrentUser(user);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(username: username),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Username atau password salah';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    const Text(
                      'Login',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (_deviceInfo.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Device: $_deviceInfo',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 32),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value ?? false),
                        ),
                        const Text('Remember me'),
                      ],
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Login'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignupScreen()),
                              );
                            },
                      child: const Text('Belum punya akun? Daftar'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}