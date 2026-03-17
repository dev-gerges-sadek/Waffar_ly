// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sh_colors.dart';

abstract class SHTheme {
  // ============ LIGHT THEME ============
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: SHColors.lightPrimaryColor,
      brightness: Brightness.light,
      primary: SHColors.lightPrimaryColor,
      secondary: SHColors.lightSecondaryColor,
      background: SHColors.lightBackgroundColor,
      surface: SHColors.lightSurfaceColor,
      error: SHColors.lightErrorColor,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: SHColors.lightTextColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: SHColors.lightTextColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: SHColors.lightHintColor,
      ),
      displayLarge: GoogleFonts.poppins(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        color: SHColors.lightTextColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: SHColors.lightTextColor,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: SHColors.lightTextColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: SHColors.lightTextColor,
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: SHColors.lightTextColor),
    ),
    iconTheme: const IconThemeData(
      color: SHColors.lightTextColor,
      size: 24,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: SHColors.lightPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SHColors.lightPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: SHColors.lightPrimaryColor,
      inactiveTrackColor: SHColors.lightTrackColor,
      thumbColor: SHColors.lightPrimaryColor,
      trackHeight: 4,
      overlayColor: Color.fromARGB(32, 14, 165, 233),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: SHColors.lightCardColor,
      elevation: 8,
      selectedIconTheme:
          const IconThemeData(size: 28, color: SHColors.lightPrimaryColor),
      unselectedIconTheme:
          const IconThemeData(size: 24, color: SHColors.lightHintColor),
      selectedItemColor: SHColors.lightPrimaryColor,
      unselectedItemColor: SHColors.lightHintColor,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: SHColors.lightPrimaryColor,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: SHColors.lightHintColor,
      ),
    ),
    scaffoldBackgroundColor: SHColors.lightBackgroundColor,
    cardTheme: CardThemeData(
      color: SHColors.lightCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: const Color.fromARGB(20, 0, 0, 0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SHColors.lightSurfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SHColors.lightBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SHColors.lightBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: SHColors.lightPrimaryColor, width: 2),
      ),
    ),
  );

  // ============ DARK THEME ============
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: SHColors.darkPrimaryColor,
      brightness: Brightness.dark,
      primary: SHColors.darkPrimaryColor,
      secondary: SHColors.darkSecondaryColor,
      background: SHColors.darkBackgroundColor,
      surface: SHColors.darkSurfaceColor,
      error: SHColors.darkErrorColor,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: SHColors.darkTextColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: SHColors.darkTextColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: SHColors.darkHintColor,
      ),
      displayLarge: GoogleFonts.poppins(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        color: SHColors.darkTextColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: SHColors.darkTextColor,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: SHColors.darkTextColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: SHColors.darkTextColor,
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: SHColors.darkTextColor),
    ),
    iconTheme: const IconThemeData(
      color: SHColors.darkTextColor,
      size: 24,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: SHColors.darkPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SHColors.darkPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: SHColors.darkPrimaryColor,
      inactiveTrackColor: SHColors.darkTrackColor,
      thumbColor: SHColors.darkPrimaryColor,
      trackHeight: 4,
      overlayColor: Color.fromARGB(32, 6, 217, 255),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: SHColors.darkCardColor,
      elevation: 8,
      selectedIconTheme:
          const IconThemeData(size: 28, color: SHColors.darkPrimaryColor),
      unselectedIconTheme:
          const IconThemeData(size: 24, color: SHColors.darkHintColor),
      selectedItemColor: SHColors.darkPrimaryColor,
      unselectedItemColor: SHColors.darkHintColor,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: SHColors.darkPrimaryColor,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: SHColors.darkHintColor,
      ),
    ),
    scaffoldBackgroundColor: SHColors.darkBackgroundColor,
    cardTheme: CardThemeData(
      color: SHColors.darkCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: const Color.fromARGB(40, 0, 0, 0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SHColors.darkSurfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SHColors.darkBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SHColors.darkBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: SHColors.darkPrimaryColor, width: 2),
      ),
    ),
  );
}
