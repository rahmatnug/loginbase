abstract class QuizMode {
  String get modeName;
  Duration get timePerQuestion;
  int calculateScore(int correctAnswers, int totalQuestions);
  bool get isDeathMode => false;
}

class PracticeMode extends QuizMode {
  @override
  String get modeName => 'Mode Latihan';

  @override
  Duration get timePerQuestion => const Duration(seconds: 30);

  @override
  int calculateScore(int correctAnswers, int totalQuestions) {
    final baseScore = correctAnswers * 10; // 10 points per correct answer
    final completionBonus = correctAnswers == totalQuestions ? 50 : 0; // Bonus for perfect score
    return baseScore + completionBonus;
  }
}

class DeathMode extends QuizMode {
  final int level;

  DeathMode({required this.level});

  @override
  String get modeName => 'Death Mode Level $level';

  @override
  bool get isDeathMode => true;

  @override
  Duration get timePerQuestion {
    // Time decreases as level increases
    // Level 1: 20s, Level 2: 17s, Level 3: 14s, Level 4: 11s, Level 5: 8s
    final baseSeconds = 20 - ((level - 1) * 3);
    return Duration(seconds: baseSeconds.clamp(8, 20));
  }

  @override
  int calculateScore(int correctAnswers, int totalQuestions) {
    // Base score: 20 points per correct answer
    final baseScore = correctAnswers * 20;

    // Level bonus: higher levels get more points
    final levelBonus = level * 10;

    // Perfect score bonus: complete all questions gets a big bonus
    // Bonus increases with level
    final perfectBonus = correctAnswers == totalQuestions ? (100 * level) : 0;

    // Time bonus is handled in the quiz screen based on remaining time

    return baseScore + levelBonus + perfectBonus;
  }

  String getDifficultyDescription() {
    switch (level) {
      case 1:
        return 'Pemula - 20 detik per soal';
      case 2:
        return 'Menengah - 17 detik per soal';
      case 3:
        return 'Sulit - 14 detik per soal';
      case 4:
        return 'Expert - 11 detik per soal';
      case 5:
        return 'Master - 8 detik per soal';
      default:
        return 'Level Khusus - ${timePerQuestion.inSeconds} detik per soal';
    }
  }
}