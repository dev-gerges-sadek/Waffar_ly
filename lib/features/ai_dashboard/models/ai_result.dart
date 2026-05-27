// ============================================================================
// ai_result.dart
// Single canonical AI result model for the Waffar energy dashboard.
// Merges the old AiResult (ai/) and AIResultModel (energy/) into one class.
// Firestore path: ai_results/{simulator | hardware | Real_Device_01}
// ============================================================================

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

  /// Locale-aware human label.
  String localLabel(bool isArabic) {
    if (isArabic) {
      switch (this) {
        case AiSeverity.normal:
          return 'طبيعي';
        case AiSeverity.warning:
          return 'تحذير';
        case AiSeverity.danger:
          return 'خطر';
        case AiSeverity.critical:
          return 'حرج';
      }
    }
    switch (this) {
      case AiSeverity.normal:
        return 'Normal';
      case AiSeverity.warning:
        return 'Warning';
      case AiSeverity.danger:
        return 'Danger';
      case AiSeverity.critical:
        return 'Critical';
    }
  }

  /// Returns a human-readable recommendation string (locale-aware).
  String recommendation(bool isArabic, double watts, double amps) {
    if (isArabic) {
      switch (this) {
        case AiSeverity.normal:
          return '✅ النظام يعمل بشكل طبيعي. الاستهلاك ضمن الحدود الآمنة.';
        case AiSeverity.warning:
          return '⚠️ تحذير — استهلاك مرتفع (${watts.toStringAsFixed(0)} واط). تابع أجهزتك.';
        case AiSeverity.danger:
          return '🚨 خطر — حمل عالٍ (${watts.toStringAsFixed(0)} واط / ${amps.toStringAsFixed(1)} أمبير). أوقف الأجهزة غير الضرورية.';
        case AiSeverity.critical:
          return '☠️ حرج — حمل خطير جداً (${watts.toStringAsFixed(0)} واط). افصل الأجهزة فوراً!';
      }
    }
    switch (this) {
      case AiSeverity.normal:
        return '✅ System operating normally. Power consumption is within safe range.';
      case AiSeverity.warning:
        return '⚠️ WARNING — Elevated consumption (${watts.toStringAsFixed(0)}W). Monitor your devices.';
      case AiSeverity.danger:
        return '🚨 DANGER — High load detected (${watts.toStringAsFixed(0)}W / ${amps.toStringAsFixed(1)}A). Turn off non-essential devices.';
      case AiSeverity.critical:
        return '☠️ CRITICAL — Extremely unsafe load (${watts.toStringAsFixed(0)}W). Disconnect devices immediately!';
    }
  }
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
    final probAnomaly = (d['prob_anomaly_pct'] as num?)?.toInt() ?? 0;
    final probNormal = (d['prob_normal_pct'] as num?)?.toInt() ?? 100;

    // Strip emojis and non-word chars from decision string
    final decision = (d['ai_decision'] as String? ?? 'NORMAL')
        .replaceAll(RegExp(r'[^\w]'), '')
        .toUpperCase()
        .trim();

    return AiResult(
      source: src,
      aiDecision: decision,
      isAnomaly: d['is_anomaly'] as bool? ?? false,
      probAnomalyPct: probAnomaly,
      probNormalPct: probNormal,
      recommendation: d['recommendation'] as String? ?? '',
      severity: AiSeverityX.fromDecision(decision, probAnomaly),
      amperes: (d['amperes'] as num?)?.toDouble() ?? 0,
      watts: (d['watts'] as num?)?.toDouble() ?? 0,
      voltage: (d['voltage'] as num?)?.toDouble() ?? 0,
      kwhConsumed: (d['kwh_consumed'] as num?)?.toDouble() ?? 0,
      costPerKwhEgp: (d['cost_per_kwh_egp'] as num?)?.toDouble() ?? 1.25,
      costSoFarEgp: (d['cost_so_far_egp'] as num?)?.toDouble() ?? 0,
      predictedMonthlyEgp:
          (d['predicted_monthly_egp'] as num?)?.toDouble() ?? 0,
      humidityPct: (d['humidity_pct'] as num?)?.toDouble() ?? 0,
      temperatureC: (d['temperature_c'] as num?)?.toDouble() ?? 0,
      uptimeHours: (d['uptime_hours'] as num?)?.toDouble() ?? 0,
      lastUpdate: d['last_update'] as String? ?? '',
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
