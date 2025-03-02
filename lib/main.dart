import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_page.dart';
import 'utils/goal_archiver.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Archive old goals
  final archivedCount = await GoalArchiver.archiveOldGoals();
  if (archivedCount > 0) {
    print('Archived $archivedCount old goals');
  }
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
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F2937),
          brightness: Brightness.dark,
          surface: Colors.black54,
          error: Colors.red,
          onPrimary: const Color(0xFFF3F4F6),
          secondary: const Color(0xFF66E0FF),
          tertiary: const Color.fromARGB(255, 255, 206, 82),
        ),
        textTheme: GoogleFonts.poppinsTextTheme()
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
