import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../Animation/FadeAnimation.dart';
import 'statistics_screen.dart';
import 'select_level_screen.dart';
import 'quiz_screen.dart';
import 'login_screen.dart';
import 'edit_name_screen.dart';
import 'help_resources_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _lastLogin = '';
  String _deviceInfo = '';

  @override
  void initState() {
    super.initState();
    _loadLastLogin();
    _loadDeviceInfo();
  }

  Future<void> _loadLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getString('last_login');
    if (lastLogin != null) {
      setState(() {
        _lastLogin = lastLogin;
      });
    }
  }

  Future<void> _loadDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceInfo = prefs.getString('last_device');
    if (deviceInfo != null) {
      setState(() {
        _deviceInfo = deviceInfo;
      });
    }
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_logout', DateFormat('dd MMMM yyyy, HH:mm:ss').format(DateTime.now()));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _navigateWithFade(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${widget.username}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditNameScreen(currentUsername: widget.username),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_lastLogin.isNotEmpty)
              _buildInfoCard('Last Login', _lastLogin),
            if (_deviceInfo.isNotEmpty)
              _buildInfoCard('Device', _deviceInfo),
            const SizedBox(height: 16),
            const Text(
              'Quiz Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildMenuButton(
              onPressed: () => _navigateWithFade(
                context,
                StatisticsScreen(username: widget.username),
              ),
              text: 'Lihat Statistik',
              icon: Icons.bar_chart,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildMenuButton(
              onPressed: () => _navigateWithFade(
                context,
                SelectLevelScreen(username: widget.username),
              ),
              text: 'Death Mode (Pilih Level)',
              icon: Icons.flash_on,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            _buildMenuButton(
              onPressed: () => _navigateWithFade(
                context,
                QuizScreen(username: widget.username),
              ),
              text: 'Mode Latihan',
              icon: Icons.school,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Help & Resources',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildMenuButton(
              onPressed: () => _navigateWithFade(
                context,
                HelpResourcesScreen(username: widget.username),
              ),
              text: 'Sumber Belajar',
              icon: Icons.library_books,
              color: Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildMenuButton(
              onPressed: () => _navigateWithFade(
                context,
                SettingsScreen(username: widget.username),
              ),
              text: 'Pengaturan & Info Device',
              icon: Icons.settings,
              color: Colors.grey[700]!,
            ),
          ],
        ),
      ),
    );
  }
}