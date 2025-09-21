// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/user_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSession.loadUsers(); // Load data user saat startup
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
        colorSchemeSeed: const Color(0xFFefda9b),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        fontFamily: 'Roboto',
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}