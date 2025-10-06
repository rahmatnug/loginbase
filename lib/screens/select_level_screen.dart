import 'package:flutter/material.dart';
import '../Animation/FadeAnimation.dart';
import 'quiz_death_screen.dart';

class SelectLevelScreen extends StatelessWidget {
  final String username;
  const SelectLevelScreen({super.key, required this.username});

  String _getLevelDescription(int level) {
    switch (level) {
      case 1:
        return '20 detik per soal - Pemula';
      case 2:
        return '17 detik per soal - Menengah';
      case 3:
        return '14 detik per soal - Sulit';
      case 4:
        return '11 detik per soal - Expert';
      case 5:
        return '8 detik per soal - Master';
      default:
        return '';
    }
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Level'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FadeAnimation(
              delay: 0.2,
              child: Text(
                'Death Mode',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            const FadeAnimation(
              delay: 0.3,
              child: Text(
                'Satu kesalahan = Game Over!\nWaktu semakin cepat di level yang lebih tinggi',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  final level = index + 1;
                  return FadeAnimation(
                    delay: 0.4 + (index * 0.1),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizDeathScreen(
                                username: username,
                                level: level,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getLevelColor(level),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Level $level',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getLevelDescription(level),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
