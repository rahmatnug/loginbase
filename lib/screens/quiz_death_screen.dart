import 'dart:async';
import 'package:flutter/material.dart';
import '../Animation/FadeAnimation.dart';
import '../data/death_questions.dart';
import '../models/quiz_mode.dart';
import '../utils/score_session.dart';
import 'result_screen.dart';

class QuizDeathScreen extends StatefulWidget {
  final String username;
  final int level;

  const QuizDeathScreen({
    super.key,
    required this.username,
    required this.level,
  });

  @override
  State<QuizDeathScreen> createState() => _QuizDeathScreenState();
}

class _QuizDeathScreenState extends State<QuizDeathScreen> {
  int currentIndex = 0;
  bool showSplash = false;
  bool isCorrectSplash = false;
  String splashMessage = '';
  int remainingSeconds = 0;
  Timer? countdownTimer;
  int correctAnswers = 0;
  late final DeathMode quizMode;

  @override
  void initState() {
    super.initState();
    quizMode = DeathMode(level: widget.level);
    _startTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    countdownTimer?.cancel();
    remainingSeconds = quizMode.timePerQuestion.inSeconds;

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || showSplash) {
        timer.cancel();
        return;
      }

      setState(() {
        remainingSeconds--;
      });

      if (remainingSeconds <= 0) {
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    setState(() {
      showSplash = true;
      isCorrectSplash = false;
      splashMessage = 'Waktu Habis!';
    });

    _saveScoreAndExit();
  }

  void _answerQuestion(int selectedIndex) {
    final isCorrect = deathQuestions[currentIndex].correctIndex == selectedIndex;

    setState(() {
      showSplash = true;
      isCorrectSplash = isCorrect;
      splashMessage = isCorrect ? 'Benar!' : 'Game Over!';
    });

    if (isCorrect) {
      correctAnswers++;
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          showSplash = false;
          if (currentIndex < deathQuestions.length - 1) {
            currentIndex++;
            _startTimer();
          } else {
            _saveScoreAndExit();
          }
        });
      });
    } else {
      _saveScoreAndExit();
    }
  }

  Future<void> _saveScoreAndExit() async {
    final score = quizMode.calculateScore(correctAnswers, deathQuestions.length);
    await ScoreSession.addScore(widget.username, score, quizMode.modeName);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          username: widget.username,
          score: score,
          total: deathQuestions.length,
          correct: correctAnswers,
          mode: quizMode.modeName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = deathQuestions[currentIndex];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Level ${widget.level}'),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeAnimation(
                    delay: 0.2,
                    child: Text(
                      'Waktu: $remainingSeconds detik',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: remainingSeconds <= 3 ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeAnimation(
                    delay: 0.4,
                    child: Text(
                      question.questionText,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(
                    question.options.length,
                    (index) => FadeAnimation(
                      delay: 0.6 + (index * 0.1),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton(
                          onPressed: showSplash ? null : () => _answerQuestion(index),
                          child: Text(question.options[index]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showSplash)
              FadeAnimation(
                delay: 0.1,
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          isCorrectSplash ? 'assets/benar.png' : 'assets/salah.png',
                          height: 120,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          splashMessage,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
