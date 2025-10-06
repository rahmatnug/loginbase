import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreEntry {
  final String username;
  final int score;
  final String mode;
  final DateTime timestamp;
  final int correctAnswers;
  final int totalQuestions;
  final int durationSeconds;

  ScoreEntry({
    required this.username,
    required this.score,
    required this.mode,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.durationSeconds,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'score': score,
      'mode': mode,
      'timestamp': timestamp.toIso8601String(),
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
      'duration_seconds': durationSeconds,
    };
  }

  factory ScoreEntry.fromMap(Map<String, dynamic> map) {
    return ScoreEntry(
      username: map['username'] as String,
      score: map['score'] as int,
      mode: map['mode'] as String,
      correctAnswers: map['correct_answers'] as int? ?? 0,
      totalQuestions: map['total_questions'] as int? ?? 0,
      durationSeconds: map['duration_seconds'] as int? ?? 0,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String get formattedTimestamp {
    final minutes = (durationSeconds / 60).floor();
    final seconds = durationSeconds % 60;
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}\n'
        'Duration: ${minutes}m ${seconds}s';
  }
}

class ScoreSession {
  static const String _scoreKey = 'quiz_scores';
  static final List<ScoreEntry> _scores = [];

  static List<ScoreEntry> get scores => List.unmodifiable(_scores);

  static Future<void> loadScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scoresJson = prefs.getStringList(_scoreKey);
      if (scoresJson != null) {
        _scores.clear();
        for (final scoreJson in scoresJson) {
          final scoreMap = json.decode(scoreJson);
          _scores.add(ScoreEntry.fromMap(scoreMap));
        }
        // Sort scores by timestamp, newest first
        _scores.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
    } catch (e) {
      print('Error loading scores: $e');
      // If loading fails, ensure scores list is empty
      _scores.clear();
    }
  }

  static Future<void> addScore(
    String username,
    int score,
    String mode, {
    required int correctAnswers,
    required int totalQuestions,
    required int durationSeconds,
  }) async {
    try {
      final entry = ScoreEntry(
        username: username,
        score: score,
        mode: mode,
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
        durationSeconds: durationSeconds,
      );

      _scores.insert(0, entry); // Add at beginning for newest first
      await _saveScores();
    } catch (e) {
      print('Error adding score: $e');
      rethrow; // Rethrow to handle in UI
    }
  }

  static Future<void> _saveScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scoresJson = _scores.map((score) => json.encode(score.toMap())).toList();
      await prefs.setStringList(_scoreKey, scoresJson);
    } catch (e) {
      print('Error saving scores: $e');
      rethrow;
    }
  }

  static Future<void> clearScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_scoreKey);
      _scores.clear();
    } catch (e) {
      print('Error clearing scores: $e');
      rethrow;
    }
  }

  static List<ScoreEntry> getScoresForUser(String username) {
    return _scores
        .where((score) => score.username == username)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static Map<String, dynamic> getUserStats(String username) {
    final userScores = getScoresForUser(username);
    if (userScores.isEmpty) {
      return {
        'total_quizzes': 0,
        'average_score': 0,
        'best_score': 0,
        'total_correct': 0,
        'total_questions': 0,
        'average_time': 0,
      };
    }

    final totalQuizzes = userScores.length;
    final averageScore = userScores.map((s) => s.score).reduce((a, b) => a + b) / totalQuizzes;
    final bestScore = userScores.map((s) => s.score).reduce((a, b) => a > b ? a : b);
    final totalCorrect = userScores.map((s) => s.correctAnswers).reduce((a, b) => a + b);
    final totalQuestions = userScores.map((s) => s.totalQuestions).reduce((a, b) => a + b);
    final averageTime = userScores.map((s) => s.durationSeconds).reduce((a, b) => a + b) / totalQuizzes;

    return {
      'total_quizzes': totalQuizzes,
      'average_score': averageScore.round(),
      'best_score': bestScore,
      'total_correct': totalCorrect,
      'total_questions': totalQuestions,
      'average_time': averageTime.round(),
    };
  }
}
