// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'utils/user_session.dart';
import 'utils/score_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize user session before running app
    await UserSession.initialize();
  } catch (e) {
    print('Error initializing app: $e');
    // Continue with app launch even if initialization fails
    // Default users will be used
  }

  // Initialize both user and score data
  await Future.wait([
    UserSession.loadUsers(),
    ScoreSession.loadScores(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuis Edukatif',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFefda9b),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown[200],
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF795548),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[400],
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.brown.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.brown),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          labelStyle: const TextStyle(color: Colors.brown),
          prefixIconColor: Colors.brown,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}