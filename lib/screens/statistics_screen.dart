import 'package:flutter/material.dart';
import '../utils/score_session.dart';

class StatisticsScreen extends StatefulWidget {
  final String username;
  const StatisticsScreen({super.key, required this.username});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _isLoading = true;
  List<ScoreEntry> _userScores = [];
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    setState(() => _isLoading = true);
    try {
      await ScoreSession.loadScores(); // Load all scores first
      setState(() {
        _userScores = ScoreSession.getScoresForUser(widget.username);
        _stats = ScoreSession.getUserStats(widget.username);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading scores: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  String _getScoreColor(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    return 'Keep Practicing';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadScores,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadScores,
              child: Column(
                children: [
                  // Stats Summary Card
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ringkasan',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Divider(),
                          _buildStatRow('Total Quiz', _stats['total_quizzes'].toString()),
                          _buildStatRow('Rata-rata Skor', '${_stats['average_score']}%'),
                          _buildStatRow('Skor Tertinggi', '${_stats['best_score']}%'),
                          _buildStatRow(
                            'Total Benar',
                            '${_stats['total_correct']}/${_stats['total_questions']}',
                          ),
                          _buildStatRow(
                            'Rata-rata Waktu',
                            '${(_stats['average_time'] / 60).floor()}m ${_stats['average_time'] % 60}s',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Score List
                  Expanded(
                    child: _userScores.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.quiz,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Belum ada riwayat quiz',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _userScores.length,
                            itemBuilder: (context, index) {
                              final score = _userScores[index];
                              final percentage = (score.correctAnswers / score.totalQuestions * 100).round();
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: percentage >= 80
                                        ? Colors.green
                                        : percentage >= 60
                                            ? Colors.blue
                                            : Colors.orange,
                                    child: Text(
                                      '$percentage%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        score.mode,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Score: ${score.score}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    '${score.correctAnswers}/${score.totalQuestions} benar • ${(score.durationSeconds / 60).floor()}:${(score.durationSeconds % 60).toString().padLeft(2, '0')}\n'
                                    '${_getScoreColor(percentage)}',
                                  ),
                                  isThreeLine: true,
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

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}