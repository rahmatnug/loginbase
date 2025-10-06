import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../Animation/FadeAnimation.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final String username;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final Duration duration;
  final String mode;

  const ResultScreen({
    super.key,
    required this.username,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.duration,
    required this.mode,
  });

  String _formatDuration() {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (correctAnswers / totalQuestions * 100).round();
    final isExcellent = percentage >= 80;
    final isGood = percentage >= 60 && percentage < 80;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isExcellent
                    ? Colors.green.shade200
                    : isGood
                        ? Colors.blue.shade200
                        : Colors.orange.shade200,
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                FadeAnimation(
                  delay: 0.2,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      isExcellent
                          ? 'assets/benar.png'
                          : 'assets/quiz_screen.jpg',
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeAnimation(
                  delay: 0.3,
                  child: Text(
                    mode,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeAnimation(
                  delay: 0.4,
                  child: Text(
                    'Skor Akhir: $score',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeAnimation(
                  delay: 0.5,
                  child: Column(
                    children: [
                      Text(
                        'Benar $correctAnswers dari $totalQuestions soal ($percentage%)',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Waktu: ${_formatDuration()}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FadeAnimation(
                  delay: 0.6,
                  child: Text(
                    isExcellent
                        ? 'Luar Biasa! 🎉'
                        : isGood
                            ? 'Bagus! 👏'
                            : 'Ayo Belajar Lagi! 💪',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                FadeAnimation(
                  delay: 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(username: username),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Kembali ke Home'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
