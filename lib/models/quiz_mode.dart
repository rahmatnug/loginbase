abstract class QuizMode {
  String get modeName;
  Duration get timePerQuestion;
  int calculateScore(int correctAnswers, int totalQuestions);
  bool get isDeathMode => false;
}

class PracticeMode extends QuizMode {
  @override
  String get modeName => 'Latihan';

  @override
  Duration get timePerQuestion => const Duration(seconds: 30);

  @override
  int calculateScore(int correctAnswers, int totalQuestions) {
    return correctAnswers * 10; // 10 poin per jawaban benar
  }
}

class DeathMode extends QuizMode {
  final int level;

  DeathMode({this.level = 1});

  @override
  String get modeName => 'Death Mode Level $level';

  @override
  Duration get timePerQuestion {
    // Semakin tinggi level, semakin sedikit waktu
    final seconds = (6 - level).clamp(2, 5);
    return Duration(seconds: seconds);
  }

  @override
  int calculateScore(int correctAnswers, int totalQuestions) {
    if (correctAnswers == totalQuestions) {
      // Bonus jika semua benar
      return (correctAnswers * 10) + (level * 20);
    }
    return correctAnswers * 10;
  }

  @override
  bool get isDeathMode => true;
}