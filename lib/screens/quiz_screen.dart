import 'package:flutter/material.dart';
import '../Animation/FadeAnimation.dart';
import '../data/question_data.dart';
import '../models/quiz_mode.dart';
import '../utils/score_session.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String username;

  const QuizScreen({super.key, required this.username});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int correctAnswers = 0;
  bool showFeedback = false;
  bool isCorrect = false;
  final quizMode = PracticeMode();

  void _answerQuestion(int selectedIndex) {
    final isAnswerCorrect = sampleQuestions[currentIndex].correctIndex == selectedIndex;

    setState(() {
      showFeedback = true;
      isCorrect = isAnswerCorrect;
      if (isAnswerCorrect) correctAnswers++;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        showFeedback = false;
        if (currentIndex < sampleQuestions.length - 1) {
          currentIndex++;
        } else {
          _finishQuiz();
        }
      });
    });
  }

  Future<void> _finishQuiz() async {
    final score = quizMode.calculateScore(correctAnswers, sampleQuestions.length);
    await ScoreSession.addScore(widget.username, score, quizMode.modeName);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          username: widget.username,
          score: score,
          total: sampleQuestions.length,
          correct: correctAnswers,
          mode: quizMode.modeName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = sampleQuestions[currentIndex];

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
          title: const Text('Mode Latihan'),
          automaticallyImplyLeading: true,
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
                      value: (currentIndex + 1) / sampleQuestions.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeAnimation(
                    delay: 0.3,
                    child: Text(
                      'Soal ${currentIndex + 1} dari ${sampleQuestions.length}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
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
                          onPressed: showFeedback ? null : () => _answerQuestion(index),
                          child: Text(question.options[index]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showFeedback)
              FadeAnimation(
                delay: 0.1,
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          isCorrect ? 'assets/benar.png' : 'assets/salah.png',
                          height: 120,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isCorrect ? 'Benar!' : 'Salah!',
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