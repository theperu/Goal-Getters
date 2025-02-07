import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const GoalGettersApp());
}

class GoalGettersApp extends StatelessWidget {
  const GoalGettersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Getters',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4AB5F7),
          brightness: Brightness.dark,
          surface: const Color(0xFF1F2429),
          error: Colors.red,
          onPrimary: Colors.white,
          secondary: const Color(0xFF66E0FF),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontSize: 30
          ),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
