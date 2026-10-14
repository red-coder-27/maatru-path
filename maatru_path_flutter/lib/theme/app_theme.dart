import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand color palette
  static const Color primaryNavy = Color(0xFF0F172A); // Slate 900
  static const Color brandIndigo = Color(0xFF312E81); // Indigo 900
  static const Color brandBlue = Color(0xFF2563EB); // Blue 600
  static const Color accentTeal = Color(0xFF0D9488); // Teal 600
  static const Color accentTealLight = Color(0xFFCCFBF1); // Teal 100

  // Neutral palette
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400

  // Status Colors
  static const Color statusOpenText = Color(0xFFB45309); // Amber 700
  static const Color statusOpenBg = Color(0xFFFEF3C7); // Amber 100
  static const Color statusProgressText = Color(0xFF0369A1); // Sky 700
  static const Color statusProgressBg = Color(0xFFE0F2FE); // Sky 100
  static const Color statusResolvedText = Color(0xFF047857); // Emerald 700
  static const Color statusResolvedBg = Color(0xFFD1FAE5); // Emerald 100

  // Priority Colors
  static const Color priorityHighText = Color(0xFFBE123C); // Rose 700
  static const Color priorityHighBg = Color(0xFFFFE4E6); // Rose 100
  static const Color priorityMedText = Color(0xFFB45309); // Amber 700
  static const Color priorityMedBg = Color(0xFFFEF3C7); // Amber 100
  static const Color priorityLowText = Color(0xFF475569); // Slate 600
  static const Color priorityLowBg = Color(0xFFF1F5F9); // Slate 100

  static ThemeData lightTheme() {
    final baseTextTheme = Typography.material2021().black;
    TextTheme textTheme;
    try {
      textTheme = GoogleFonts.interTextTheme(baseTextTheme);
    } catch (_) {
      textTheme = baseTextTheme;
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: brandIndigo,
        secondary: accentTeal,
        surface: surfaceCard,
        error: const Color(0xFFDC2626),
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: textTheme.copyWith(
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: textPrimary,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceCard,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        shape: Border(
          bottom: BorderSide(color: borderLight, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: brandBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        labelStyle: const TextStyle(color: textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandIndigo,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderLight),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
