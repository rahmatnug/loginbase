import 'package:flutter/material.dart';
import '../Animation/FadeAnimation.dart';
import 'statistics_screen.dart';
import 'select_level_screen.dart';
import 'quiz_screen.dart';
import 'login_screen.dart';
import 'edit_name_screen.dart';
import '../utils/user_session.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  void _logout(BuildContext context) {
    // Hanya navigasi ke login screen tanpa menghapus data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, $username'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditNameScreen(currentUsername: username),
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar di tengah dengan animasi
            Expanded(
              child: FadeAnimation(
                delay: 0.2,
                child: Center(
                  child: Image.asset(
                    'assets/quiz_screen.jpg',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Tombol menu dengan animasi
            FadeAnimation(
              delay: 0.4,
              child: ElevatedButton.icon(
                onPressed: () => _navigateWithFade(
                  context,
                  const StatisticsScreen(),
                ),
                icon: const Icon(Icons.bar_chart),
                label: const Text('Lihat Statistik'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeAnimation(
              delay: 0.5,
              child: ElevatedButton.icon(
                onPressed: () => _navigateWithFade(
                  context,
                  SelectLevelScreen(username: username),
                ),
                icon: const Icon(Icons.flash_on),
                label: const Text('Death Mode (Pilih Level)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red[400],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeAnimation(
              delay: 0.6,
              child: ElevatedButton(
                onPressed: () => _navigateWithFade(
                  context,
                  QuizScreen(username: username),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green[400],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images.jpg',
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Mode Latihan'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}