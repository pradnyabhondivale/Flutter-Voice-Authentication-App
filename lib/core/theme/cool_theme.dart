import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoolTheme {
  // 🔥 COOL COLORS
  static const Color primaryGlow = Color(0xFF8B5CF6);     // Violet glow
  static const Color secondaryGlow = Color(0xFF06B6D4);   // Cyan glow
  static const Color accentGlow = Color(0xFFEC4899);      // Pink glow
  static const Color bgDark = Color(0xFF0A0A1A);
  static const Color glassBg = Color(0x22FFFFFF);

  static const gradientGlow = LinearGradient(
    colors: [
      Color(0xFF1E1E3F),
      Color(0xFF0A0A1A),
      Color(0xFF1A1A2E),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4), Color(0xFFEC4899)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData coolDark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: primaryGlow,
        secondary: secondaryGlow,
        tertiary: accentGlow,
      ),
      scaffoldBackgroundColor: bgDark,
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
            ],
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGlow,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 12,
          shadowColor: primaryGlow.withOpacity(0.4),
        ),
      ),
    );
  }
}
