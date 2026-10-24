// ============================================================================
// ai_result.dart
// Single canonical AI result model for the Waffar energy dashboard.
// Merges the old AiResult (ai/) and AIResultModel (energy/) into one class.
// Firestore path: ai_results/{simulator | hardware | Real_Device_01}
// ============================================================================

import '../../../core/helper/safe_json.dart';
import '../../../core/l10n/app_localizations.dart';

/// Severity levels derived from AI decision and anomaly probability.

enum AiSeverity { normal, warning, danger, critical }

extension AiSeverityX on AiSeverity {
  // ── Factories ─────────────────────────────────────────────────────────────

  static AiSeverity fromDecision(String decision, int probAnomaly) {
    switch (decision) {
      case 'NORMAL':
        return AiSeverity.normal;
      case 'WARNING':
        return AiSeverity.warning;
      case 'DANGER':
        return AiSeverity.danger;
      case 'CRITICAL':
        return AiSeverity.critical;
      // Legacy 'ANOMALY' → map by probability
      default:
        if (probAnomaly >= 80) return AiSeverity.critical;
        if (probAnomaly >= 60) return AiSeverity.danger;
        if (probAnomaly >= 35) return AiSeverity.warning;
        return AiSeverity.normal;
    }
  }

  // ── Display helpers ───────────────────────────────────────────────────────

  String get label {
    switch (this) {
      case AiSeverity.normal:
        return 'NORMAL';
      case AiSeverity.warning:
        return 'WARNING';
      case AiSeverity.danger:
        return 'DANGER';
      case AiSeverity.critical:
        return 'CRITICAL';
    }
  }

  String get emoji {
    switch (this) {
      case AiSeverity.normal:
        return '✅';
      case AiSeverity.warning:
        return '⚠️';
      case AiSeverity.danger:
        return '🚨';
      case AiSeverity.critical:
        return '☠️';
    }
  }

  /// Locale-aware human label (text lives in the ARB files).
  String localLabel(AppLocalizations l) => switch (this) {
    AiSeverity.normal => l.sevNormal,
    AiSeverity.warning => l.sevWarning,
    AiSeverity.danger => l.sevDanger,
    AiSeverity.critical => l.sevCritical,
  };

  /// Human-readable recommendation (locale-aware).
  String recommendation(AppLocalizations l, double watts, double amps) =>
      switch (this) {
        AiSeverity.normal => l.recNormal,
        AiSeverity.warning => l.recWarning(watts.toStringAsFixed(0)),
        AiSeverity.danger =>
          l.recDanger(watts.toStringAsFixed(0), amps.toStringAsFixed(1)),
        AiSeverity.critical => l.recCritical(watts.toStringAsFixed(0)),
      };
}

// ── Model ─────────────────────────────────────────────────────────────────────

/// Unified AI result model. Reads from Firestore ai_results/{source}.
class AiResult {
  const AiResult({
    required this.source,
    required this.aiDecision,
    required this.isAnomaly,
    required this.probAnomalyPct,
    required this.probNormalPct,
    required this.recommendation,
    required this.severity,
    required this.amperes,
    required this.watts,
    required this.voltage,
    required this.kwhConsumed,
    required this.costPerKwhEgp,
    required this.costSoFarEgp,
    required this.predictedMonthlyEgp,
    required this.humidityPct,
    required this.temperatureC,
    required this.uptimeHours,
    required this.lastUpdate,
  });

  final String source;
  final String aiDecision;
  final bool isAnomaly;
  final int probAnomalyPct;
  final int probNormalPct;
  final String recommendation;
  final AiSeverity severity;

  // Electrical readings
  final double amperes;
  final double watts;
  final double voltage;
  final double kwhConsumed;
  final double costPerKwhEgp;
  final double costSoFarEgp;
  final double predictedMonthlyEgp;
  final double humidityPct;
  final double temperatureC;
  final double uptimeHours;
  final String lastUpdate;

  // ── Derived helpers ────────────────────────────────────────────────────────

  /// True when all electrical readings are zero (device off or disconnected).
  bool get isIdle => watts == 0 && amperes == 0 && kwhConsumed == 0;

  // ── Firestore factory ──────────────────────────────────────────────────────

  factory AiResult.fromFirestore(Map<String, dynamic> d, String src) {
    final probAnomaly = asInt(d['prob_anomaly_pct']) ?? 0;
    final probNormal = asInt(d['prob_normal_pct']) ?? 100;

    // Strip emojis and non-word chars from decision string
    final decision = (asString(d['ai_decision']) ?? 'NORMAL')
        .replaceAll(RegExp(r'[^\w]'), '')
        .toUpperCase()
        .trim();

    return AiResult(
      source: src,
      aiDecision: decision,
      isAnomaly: asBool(d['is_anomaly']) ?? false,
      probAnomalyPct: probAnomaly,
      probNormalPct: probNormal,
      recommendation: asString(d['recommendation']) ?? '',
      severity: AiSeverityX.fromDecision(decision, probAnomaly),
      amperes: asDouble(d['amperes']) ?? 0,
      watts: asDouble(d['watts']) ?? 0,
      voltage: asDouble(d['voltage']) ?? 0,
      kwhConsumed: asDouble(d['kwh_consumed']) ?? 0,
      costPerKwhEgp: asDouble(d['cost_per_kwh_egp']) ?? 1.25,
      costSoFarEgp: asDouble(d['cost_so_far_egp']) ?? 0,
      predictedMonthlyEgp:
          asDouble(d['predicted_monthly_egp']) ?? 0,
      humidityPct: asDouble(d['humidity_pct']) ?? 0,
      temperatureC: asDouble(d['temperature_c']) ?? 0,
      uptimeHours: asDouble(d['uptime_hours']) ?? 0,
      lastUpdate: asString(d['last_update']) ?? '',
    );
  }

  // ── Named constructors ────────────────────────────────────────────────────

  /// Idle result: all readings zero, source is offline or device is off.
  factory AiResult.idle(String src) => AiResult(
    source: src,
    aiDecision: 'NORMAL',
    isAnomaly: false,
    probAnomalyPct: 0,
    probNormalPct: 100,
    recommendation:
        '✅ All devices are OFF or idle. No power consumption detected.',
    severity: AiSeverity.normal,
    amperes: 0,
    watts: 0,
    voltage: 0,
    kwhConsumed: 0,
    costPerKwhEgp: 1.25,
    costSoFarEgp: 0,
    predictedMonthlyEgp: 0,
    humidityPct: 0,
    temperatureC: 0,
    uptimeHours: 0,
    lastUpdate: '',
  );

  // ── Immutable copy helpers ─────────────────────────────────────────────────

  AiResult copyWithSeverity(AiSeverity newSeverity) => AiResult(
    source: source,
    aiDecision: newSeverity.label,
    isAnomaly: newSeverity != AiSeverity.normal,
    probAnomalyPct: probAnomalyPct,
    probNormalPct: probNormalPct,
    recommendation: recommendation,
    severity: newSeverity,
    amperes: amperes,
    watts: watts,
    voltage: voltage,
    kwhConsumed: kwhConsumed,
    costPerKwhEgp: costPerKwhEgp,
    costSoFarEgp: costSoFarEgp,
    predictedMonthlyEgp: predictedMonthlyEgp,
    humidityPct: humidityPct,
    temperatureC: temperatureC,
    uptimeHours: uptimeHours,
    lastUpdate: lastUpdate,
  );
}
