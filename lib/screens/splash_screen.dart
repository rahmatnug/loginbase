import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 1500),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images.jpg',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  duration: const Duration(milliseconds: 1500),
                  child: Text(
                    'Aplikasi Quiz',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 1500),
                  child: Text(
                    'Dibuat oleh Rht',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}