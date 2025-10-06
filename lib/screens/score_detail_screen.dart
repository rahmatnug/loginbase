import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScoreDetailScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ScoreDetailScreen({
    super.key,
    required this.result,
  });

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd MMMM yyyy\nHH:mm:ss').format(date);
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '$minutes min $remainingSeconds sec';
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (result['correct_answers'] / result['total_questions'] * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Skor'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: percentage >= 80
                          ? Colors.green
                          : percentage >= 60
                              ? Colors.blue
                              : Colors.orange,
                      child: Text(
                        '$percentage%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${result['score']} Points',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              'Quiz Information',
              [
                _buildDetailRow('Mode', result['mode']),
                _buildDetailRow('Questions', '${result['correct_answers']}/${result['total_questions']} correct'),
                if (result['duration_seconds'] != null)
                  _buildDetailRow('Duration', _formatDuration(result['duration_seconds'])),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              'Player Information',
              [
                _buildDetailRow('Username', result['username']),
                _buildDetailRow('Date', _formatDate(result['date'])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}