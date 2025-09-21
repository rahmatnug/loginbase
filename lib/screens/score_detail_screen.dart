import 'package:flutter/material.dart';
import '../utils/score_session.dart';

class ScoreDetailScreen extends StatelessWidget {
  final ScoreEntry score;
  const ScoreDetailScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Skor ${score.username}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${score.username}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Skor: ${score.score}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Mode: ${score.mode}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Waktu: ${score.timestamp}', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}