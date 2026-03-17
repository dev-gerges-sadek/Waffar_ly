import 'package:flutter/material.dart';

abstract class SHColors {
  // ============ LIGHT MODE ============
  static const Color lightTextColor       = Color(0xFF0F172A);
  static const Color lightHintColor       = Color(0xFF64748B);
  static const Color lightSecondaryText   = Color(0xFF78716C);

  static const Color lightBackgroundColor = Color(0xFFF8FAFC);
  static const Color lightCardColor       = Color(0xFFFFFFFF);
  static const Color lightSurfaceColor    = Color(0xFFF1F5F9);

  static const Color lightPrimaryColor    = Color(0xFF0EA5E9);
  static const Color lightSecondaryColor  = Color(0xFF06B6D4);
  static const Color lightAccentColor     = Color(0xFF3B82F6);
  static const Color lightSuccessColor    = Color(0xFF10B981);
  static const Color lightWarningColor    = Color(0xFFF59E0B);
  static const Color lightErrorColor      = Color(0xFFEF4444);

  static const Color lightTrackColor      = Color(0xFFE2E8F0);
  static const Color lightBorderColor     = Color(0xFFCBD5E1);
  static const Color lightDividerColor    = Color(0xFFE0E7FF);

  // ============ DARK MODE ============
  static const Color darkTextColor        = Color(0xFFF1F5F9);
  static const Color darkHintColor        = Color(0xFFCBD5E1);
  static const Color darkSecondaryText    = Color(0xFFCBD5E1);

  static const Color darkBackgroundColor  = Color(0xFF0F172A);
  static const Color darkCardColor        = Color(0xFF1E293B);
  static const Color darkSurfaceColor     = Color(0xFF334155);

  static const Color darkPrimaryColor     = Color(0xFF06D9FF);
  static const Color darkSecondaryColor   = Color(0xFF10EFFF);
  static const Color darkAccentColor      = Color(0xFF60A5FA);
  static const Color darkSuccessColor     = Color(0xFF34D399);
  static const Color darkWarningColor     = Color(0xFFFCD34D);
  static const Color darkErrorColor       = Color(0xFFF87171);

  static const Color darkTrackColor       = Color(0xFF475569);
  static const Color darkBorderColor      = Color(0xFF64748B);
  static const Color darkDividerColor     = Color(0xFF3730A3);

  // ============ GRADIENTS ============
  static const List<Color> lightCardGradient = [Color(0xFFFAFAFA), Color(0xFFF1F5F9)];
  static const List<Color> lightPrimaryGradient = [Color(0xFF0EA5E9), Color(0xFF06B6D4), Color(0xFF3B82F6)];
  static const List<Color> lightAccentGradient  = [Color(0xFF3B82F6), Color(0xFF0EA5E9), Color(0xFF06B6D4)];

  static const List<Color> darkCardGradient     = [Color(0xFF1E293B), Color(0xFF0F172A)];
  static const List<Color> darkPrimaryGradient  = [Color(0xFF06D9FF), Color(0xFF10EFFF), Color(0xFF60A5FA)];
  static const List<Color> darkAccentGradient   = [Color(0xFF60A5FA), Color(0xFF06D9FF), Color(0xFF10EFFF)];

  // ✅ Helper: يرجع اللون الصح بناءً على الـ brightness الحالية
  static Color primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkPrimaryColor
          : lightPrimaryColor;

  static Color text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextColor
          : lightTextColor;

  static Color hint(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkHintColor
          : lightHintColor;

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackgroundColor
          : lightBackgroundColor;

  static Color card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkCardColor
          : lightCardColor;

  static Color track(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTrackColor
          : lightTrackColor;

  static Color selected(BuildContext context) => primary(context);
}
