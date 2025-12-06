import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon_design/moon_design.dart';
import 'screens/home_page.dart';
import 'utils/goal_archiver.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Archive old goals
  final archivedCount = await GoalArchiver.archiveOldGoals();
  if (archivedCount > 0) {
    debugPrint('Archived $archivedCount old goals');
  }
  runApp(const GoalGettersApp());
}

class GoalGettersApp extends StatelessWidget {
  const GoalGettersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Getters',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF66E0FF),
          secondary: Color.fromARGB(255, 255, 206, 82),
          surface: Color(0xFF111827),
          error: Color(0xFFEF4444),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        extensions: <ThemeExtension<dynamic>>[
          MoonTokens.dark.copyWith(
            colors: MoonColors.dark.copyWith(
              goku: const Color(0xFF0A0E1A),
              gohan: const Color(0xFF111827),
              piccolo: const Color(0xFF1F2937),
              hit: const Color(0xFF374151),
              beerus: const Color(0xFF4B5563),
              goten: const Color(0xFF6B7280),
              bulma: const Color(0xFF66E0FF),
              trunks: const Color.fromARGB(255, 255, 206, 82),
              chichi: const Color(0xFFEF4444),
              roshi: const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
