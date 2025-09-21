import 'package:flutter/material.dart';
import '../Animation/FadeAnimation.dart';
import 'quiz_death_screen.dart';

class SelectLevelScreen extends StatelessWidget {
  final String username;
  const SelectLevelScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Level'),
        elevation: 0,
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
                'Semakin tinggi level, semakin sedikit waktu per soal',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(
              5,
              (index) {
                final level = index + 1;
                final seconds = (6 - level).clamp(2, 5);
                return FadeAnimation(
                  delay: 0.4 + (index * 0.1),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.blue[100 * (index + 1)],
                      ),
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
                      child: Column(
                        children: [
                          Text(
                            'Level $level',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$seconds detik per soal',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
