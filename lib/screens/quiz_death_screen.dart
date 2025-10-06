import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
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
      if (!mounted || showSplash) return;

      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _handleTimeout();
        }
      });
    });
  }

  void _handleTimeout() {
    countdownTimer?.cancel();
    setState(() {
      showSplash = true;
      isCorrectSplash = false;
      splashMessage = 'Waktu Habis!';
    });

    _saveAndFinish();
  }

  void _answerQuestion(int selectedIndex) {
    final isAnswerCorrect = deathQuestions[currentIndex].correctIndex == selectedIndex;
    countdownTimer?.cancel();

    setState(() {
      showSplash = true;
      isCorrectSplash = isAnswerCorrect;
      splashMessage = isAnswerCorrect ? 'Benar!' : 'Game Over!';
    });

    if (isAnswerCorrect) {
      correctAnswers++;
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() {
          showSplash = false;
          if (currentIndex < deathQuestions.length - 1) {
            currentIndex++;
            _startTimer();
          } else {
            _saveAndFinish();
          }
        });
      });
    } else {
      _saveAndFinish();
    }
  }

  Future<void> _saveAndFinish() async {
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime!);
    final score = quizMode.calculateScore(correctAnswers, deathQuestions.length);

    // Save score with additional info
    await ScoreSession.addScore(
      widget.username,
      score,
      'Death Mode Level ${widget.level}',
      correctAnswers: correctAnswers,
      totalQuestions: deathQuestions.length,
      durationSeconds: duration.inSeconds,
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          username: widget.username,
          score: score,
          totalQuestions: deathQuestions.length,
          correctAnswers: correctAnswers,
          duration: duration,
          mode: 'Death Mode Level ${widget.level}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = deathQuestions[currentIndex];

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Keluar Kuis?'),
            content: const Text('Progress akan hilang jika keluar sekarang.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('TIDAK'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('YA'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Level ${widget.level}'),
          centerTitle: true,
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
                    child: LinearProgressIndicator(
                      value: (currentIndex + 1) / deathQuestions.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        remainingSeconds <= 3 ? Colors.red : Colors.blue,
                      ),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeAnimation(
                    delay: 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Soal ${currentIndex + 1}/${deathQuestions.length}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Waktu: $remainingSeconds detik',
                          style: TextStyle(
                            fontSize: 16,
                            color: remainingSeconds <= 3 ? Colors.red : null,
                            fontWeight: remainingSeconds <= 3 ? FontWeight.bold : null,
                          ),
                        ),
                      ],
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
                      delay: 0.5 + (index * 0.1),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton(
                          onPressed: showSplash ? null : () => _answerQuestion(index),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: showSplash
                                ? (index == question.correctIndex
                                    ? Colors.green
                                    : Colors.red)
                                : null,
                          ),
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
