import 'package:flutter/material.dart';
import '../utils/score_session.dart';
import 'score_detail_screen.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scores = ScoreSession.scores;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Kuis')),
      body: scores.isEmpty
          ? const Center(child: Text('Belum ada data kuis'))
          : ListView.builder(
        itemCount: scores.length,
        itemBuilder: (context, index) {
          final score = scores[index];
          return Card(
            child: ListTile(
              title: Text(score.username),
              subtitle: Text('Skor: ${score.score}'),
              trailing: Text(score.mode),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScoreDetailScreen(score: score),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}