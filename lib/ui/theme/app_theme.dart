import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/style.dart';

class AppTheme {
  static final _textTheme = GoogleFonts.plusJakartaSansTextTheme(
    const TextTheme(
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: textMain),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textMain),
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textMain),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textMain),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textMain),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textMain),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textMain),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textMain),
      bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary),
      labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textMain),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textMuted),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      foregroundColor: textMain,
      surfaceTintColor: Colors.transparent,
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryLavender,
      secondary: mint,
      tertiary: peach,
      surface: surface,
      error: errorColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLavender,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        padding: const EdgeInsets.symmetric(horizontal: spacingXXL, vertical: spacingM),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: const TextStyle(color: textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderSoft, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderSoft, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryLavender, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: 14),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(surface),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primaryLavender,
      unselectedItemColor: textMuted,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        side: const BorderSide(color: borderSoft, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surface,
      side: const BorderSide(color: borderSoft, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusRound),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: textMain,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),
  );

  // Dark theme kept for backwards compatibility — mirrors light structure
  // with inverted values. Lavender Logic is primarily light.
  static ThemeData darkTheme = lightTheme;
}
