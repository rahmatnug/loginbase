import 'dart:convert';
import 'storage_helper.dart';

class ScoreEntry {
  final String username;
  final int score;
  final String mode;
  final DateTime timestamp;

  ScoreEntry({
    required this.username,
    required this.score,
    required this.mode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'score': score,
      'mode': mode,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ScoreEntry.fromMap(Map<String, dynamic> map) {
    return ScoreEntry(
      username: map['username'],
      score: map['score'],
      mode: map['mode'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';
  }
}

class ScoreSession {
  static final List<ScoreEntry> _scores = [];

  static List<ScoreEntry> get scores => List.unmodifiable(_scores);

  static Future<void> loadScores() async {
    final savedScores = await StorageHelper.getScores();
    if (savedScores != null) {
      _scores.clear();
      for (final scoreJson in savedScores) {
        final scoreMap = json.decode(scoreJson);
        _scores.add(ScoreEntry.fromMap(scoreMap));
      }
    }
  }

  static Future<void> addScore(String username, int score, String mode) async {
    final entry = ScoreEntry(
      username: username,
      score: score,
      mode: mode,
    );
    _scores.add(entry);

    // Simpan ke storage
    final scoresJson = _scores.map((s) => json.encode(s.toMap())).toList();
    await StorageHelper.saveScores(scoresJson);
  }

  static Future<void> clearScores() async {
    _scores.clear();
    await StorageHelper.clearScores();
  }

  static List<ScoreEntry> getScoresByUsername(String username) {
    return _scores.where((score) => score.username == username).toList();
  }
}
