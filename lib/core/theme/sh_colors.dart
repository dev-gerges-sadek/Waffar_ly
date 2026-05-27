import 'package:flutter/material.dart';

abstract class SHColors {
  // ── Light mode ────────────────────────────────────────────────────────────
  static const Color lightTextColor        = Color(0xFF0F172A);
  static const Color lightHintColor        = Color(0xFF64748B);
  static const Color lightSecondaryText    = Color(0xFF78716C);

  static const Color lightBackgroundColor  = Color(0xFFF8FAFC);
  static const Color lightCardColor        = Color(0xFFFFFFFF);
  static const Color lightSurfaceColor     = Color(0xFFF1F5F9);

  static const Color lightPrimaryColor     = Color(0xFF0EA5E9);
  static const Color lightSecondaryColor   = Color(0xFF06B6D4);
  static const Color lightAccentColor      = Color(0xFF3B82F6);

  // Semantic status tokens
  static const Color lightSuccessColor     = Color(0xFF10B981);
  static const Color lightWarningColor     = Color(0xFFF59E0B);
  static const Color lightErrorColor       = Color(0xFFEF4444);

  // Severity scale (normal → warning → danger → critical)
  static const Color lightSeverityNormal   = Color(0xFF10B981); // green
  static const Color lightSeverityWarning  = Color(0xFFF59E0B); // amber
  static const Color lightSeverityDanger   = Color(0xFFF97316); // orange
  static const Color lightSeverityCritical = Color(0xFFEF4444); // red

  // Rank/medal tokens (leaderboard)
  static const Color lightRankGold         = Color(0xFFF59E0B); // amber
  static const Color lightRankSilver       = Color(0xFF94A3B8); // blue-grey
  static const Color lightRankBronze       = Color(0xFF92400E); // brown

  // Chart accent (device/energy charts)
  static const Color lightChartBlue        = Color(0xFF60A5FA);
  static const Color lightChartTeal        = Color(0xFF2DD4BF);

  // Shadow token
  static const Color lightShadowColor      = Color(0x1A000000); // black 10%

  static const Color lightTrackColor       = Color(0xFFE2E8F0);
  static const Color lightBorderColor      = Color(0xFFCBD5E1);
  static const Color lightDividerColor     = Color(0xFFE0E7FF);

  // ── Dark mode ─────────────────────────────────────────────────────────────
  static const Color darkTextColor         = Color(0xFFF1F5F9);
  static const Color darkHintColor         = Color(0xFFCBD5E1);
  static const Color darkSecondaryText     = Color(0xFFCBD5E1);

  static const Color darkBackgroundColor   = Color(0xFF0F172A);
  static const Color darkCardColor         = Color(0xFF1E293B);
  static const Color darkSurfaceColor      = Color(0xFF334155);

  static const Color darkPrimaryColor      = Color(0xFF06D9FF);
  static const Color darkSecondaryColor    = Color(0xFF10EFFF);
  static const Color darkAccentColor       = Color(0xFF60A5FA);

  static const Color darkSuccessColor      = Color(0xFF34D399);
  static const Color darkWarningColor      = Color(0xFFFCD34D);
  static const Color darkErrorColor        = Color(0xFFF87171);

  static const Color darkSeverityNormal    = Color(0xFF34D399);
  static const Color darkSeverityWarning   = Color(0xFFFCD34D);
  static const Color darkSeverityDanger    = Color(0xFFFB923C);
  static const Color darkSeverityCritical  = Color(0xFFF87171);

  static const Color darkRankGold          = Color(0xFFFCD34D);
  static const Color darkRankSilver        = Color(0xFF94A3B8);
  static const Color darkRankBronze        = Color(0xFFB45309);

  static const Color darkChartBlue         = Color(0xFF93C5FD);
  static const Color darkChartTeal         = Color(0xFF5EEAD4);

  static const Color darkShadowColor       = Color(0x33000000); // black 20%

  static const Color darkTrackColor        = Color(0xFF475569);
  static const Color darkBorderColor       = Color(0xFF64748B);
  static const Color darkDividerColor      = Color(0xFF3730A3);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const List<Color> lightCardGradient =
      [Color(0xFFFAFAFA), Color(0xFFF1F5F9)];
  static const List<Color> lightPrimaryGradient =
      [Color(0xFF0EA5E9), Color(0xFF06B6D4), Color(0xFF3B82F6)];
  static const List<Color> lightAccentGradient =
      [Color(0xFF3B82F6), Color(0xFF0EA5E9), Color(0xFF06B6D4)];

  static const List<Color> darkCardGradient =
      [Color(0xFF1E293B), Color(0xFF0F172A)];
  static const List<Color> darkPrimaryGradient =
      [Color(0xFF06D9FF), Color(0xFF10EFFF), Color(0xFF60A5FA)];
  static const List<Color> darkAccentGradient =
      [Color(0xFF60A5FA), Color(0xFF06D9FF), Color(0xFF10EFFF)];

  // ── Context-aware helpers ─────────────────────────────────────────────────

  static Color primary(BuildContext context) =>
      _d(context) ? darkPrimaryColor     : lightPrimaryColor;

  static Color text(BuildContext context) =>
      _d(context) ? darkTextColor        : lightTextColor;

  static Color hint(BuildContext context) =>
      _d(context) ? darkHintColor        : lightHintColor;

  static Color background(BuildContext context) =>
      _d(context) ? darkBackgroundColor  : lightBackgroundColor;

  static Color card(BuildContext context) =>
      _d(context) ? darkCardColor        : lightCardColor;

  static Color surface(BuildContext context) =>
      _d(context) ? darkSurfaceColor     : lightSurfaceColor;

  static Color track(BuildContext context) =>
      _d(context) ? darkTrackColor       : lightTrackColor;

  static Color shadow(BuildContext context) =>
      _d(context) ? darkShadowColor      : lightShadowColor;

  static Color selected(BuildContext context) => primary(context);

  static Color success(BuildContext context) =>
      _d(context) ? darkSuccessColor     : lightSuccessColor;

  static Color warning(BuildContext context) =>
      _d(context) ? darkWarningColor     : lightWarningColor;

  static Color error(BuildContext context) =>
      _d(context) ? darkErrorColor       : lightErrorColor;

  /// Maps an AI severity level to its theme-correct color.
  /// [level] accepts: 'normal' | 'warning' | 'danger' | 'critical'
  static Color severity(BuildContext context, String level) {
    final d = _d(context);
    return switch (level.toLowerCase()) {
      'normal'   => d ? darkSeverityNormal   : lightSeverityNormal,
      'warning'  => d ? darkSeverityWarning  : lightSeverityWarning,
      'danger'   => d ? darkSeverityDanger   : lightSeverityDanger,
      'critical' => d ? darkSeverityCritical : lightSeverityCritical,
      _          => primary(context),
    };
  }

  /// Leaderboard rank color: 1=gold, 2=silver, 3=bronze, else primary.
  static Color rank(BuildContext context, int position) {
    final d = _d(context);
    return switch (position) {
      1 => d ? darkRankGold   : lightRankGold,
      2 => d ? darkRankSilver : lightRankSilver,
      3 => d ? darkRankBronze : lightRankBronze,
      _ => primary(context),
    };
  }

  /// Chart blue accent (devices/live watts).
  static Color chartBlue(BuildContext context) =>
      _d(context) ? darkChartBlue : lightChartBlue;

  // ── Internal ──────────────────────────────────────────────────────────────
  static bool _d(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
