import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF9D5FD4), // Purple
      scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Zinc 50
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF9D5FD4),
        secondary: Color(0xFF18181B),
        surface: Colors.white,
        error: Color(0xFFEF4444), // Red 500
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF09090B),
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF09090B)),
        titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF09090B)),
        bodyLarge: GoogleFonts.inter(color: const Color(0xFF09090B)),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFF3F3F46)), // Zinc 700
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF09090B),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF09090B)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9D5FD4),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)), // Zinc 200
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF9D5FD4), width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.inter(color: const Color(0xFFA1A1AA)), // Zinc 400
        labelStyle: GoogleFonts.inter(color: const Color(0xFF3F3F46)),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE4E4E7),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF9D5FD4), // Purple
      scaffoldBackgroundColor: const Color(0xFF09090B), // Zinc 950
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9D5FD4),
        secondary: Color(0xFFF4F4F5),
        surface: Color(0xFF18181B), // Dark Grey for surfaces
        error: Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Color(0xFF09090B),
        onSurface: Color(0xFFFAFAFA),
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFFFAFAFA)),
        titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFFFAFAFA)),
        bodyLarge: GoogleFonts.inter(color: const Color(0xFFFAFAFA)),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFFA1A1AA)), // Zinc 400
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF09090B),
        foregroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFFAFAFA)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9D5FD4),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF27272A)), // Zinc 800
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF27272A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF9D5FD4), width: 1.5),
        ),
        filled: true,
        fillColor: const Color(0xFF18181B),
        hintStyle: GoogleFonts.inter(color: const Color(0xFFA1A1AA)), // Zinc 400
        labelStyle: GoogleFonts.inter(color: const Color(0xFFE4E4E7)), // Zinc 200
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[800]!),
        ),
        elevation: 0,
        color: const Color(0xFF18181B),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF27272A),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
