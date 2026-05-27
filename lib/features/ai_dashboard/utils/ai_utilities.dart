// ============================================================================
// ai_utilities.dart
// Shared utility functions for AI analysis: data sanitization, severity
// computation, health derivation, and room mapping.
//
// These are extracted from AiEnergyCubit to enable reuse and testing.
// ============================================================================

import '../../../core/constants/app_constants.dart';
import '../cubit/ai_energy_state.dart';
import '../models/ai_result.dart';

/// Shared AI utility functions for data processing and analysis.
class AiUtilities {
  AiUtilities._(); // Private constructor to prevent instantiation

  // ── Sanitization ──────────────────────────────────────────────────────────

  /// Cleans raw Firestore data: handles idle states and corrects false anomalies.
  ///
  /// - Returns idle state when all readings are zero
  /// - Detects standby mode (voltage present but no power)
  /// - Corrects false anomaly classifications when probability is low
  /// - Recomputes severity from live readings for accuracy
  static AiResult sanitise(Map<String, dynamic> data, String src) {
    final watts = (data['watts'] as num?)?.toDouble() ?? 0;
    final amperes = (data['amperes'] as num?)?.toDouble() ?? 0;
    final kwh = (data['kwh_consumed'] as num?)?.toDouble() ?? 0;
    final voltage = (data['voltage'] as num?)?.toDouble() ?? 0;

    // All readings zero → idle
    if (watts == 0 && amperes == 0 && kwh == 0) return AiResult.idle(src);

    // Voltage present but no power → idle (standby mode)
    if (voltage > 0 && watts == 0 && amperes == 0) return AiResult.idle(src);

    final result = AiResult.fromFirestore(data, src);

    // Correct false critical/danger when anomaly probability is low
    if (result.probAnomalyPct < 30 &&
        (result.severity == AiSeverity.danger ||
            result.severity == AiSeverity.critical)) {
      return result.copyWithSeverity(AiSeverity.normal);
    }

    // Recompute severity from live readings for accuracy
    final computed = computeSeverity(watts, amperes);
    if (computed != result.severity) return result.copyWithSeverity(computed);

    return result;
  }

  // ── Severity Computation ──────────────────────────────────────────────────

  /// Computes severity level based on current power and amperage readings.
  ///
  /// Thresholds are defined in [AppConstants]:
  /// - Critical: watts > aiWattsCritical OR amps > aiAmpsCritical
  /// - Danger: watts > aiWattsDanger OR amps > aiAmpsDanger
  /// - Warning: watts > aiWattsWarning OR amps > aiAmpsWarning
  /// - Normal: all other states (including zero/idle)
  static AiSeverity computeSeverity(double watts, double amps) {
    if (watts == 0 && amps == 0) return AiSeverity.normal;
    if (watts > AppConstants.aiWattsCritical ||
        amps > AppConstants.aiAmpsCritical) {
      return AiSeverity.critical;
    }
    if (watts > AppConstants.aiWattsDanger ||
        amps > AppConstants.aiAmpsDanger) {
      return AiSeverity.danger;
    }
    if (watts > AppConstants.aiWattsWarning ||
        amps > AppConstants.aiAmpsWarning) {
      return AiSeverity.warning;
    }
    return AiSeverity.normal;
  }

  // ── Room Mapping ──────────────────────────────────────────────────────────

  /// Maps device ID suffixes to room names using [AppConstants.roomSuffixMap].
  ///
  /// Returns 'Other' if no matching suffix is found in the device ID.
  static String roomFromDeviceId(String id) {
    for (final entry in AppConstants.roomSuffixMap.entries) {
      if (id.contains('_${entry.key}_')) return entry.value;
    }
    return 'Other';
  }

  // ── Health Derivation ─────────────────────────────────────────────────────

  /// Derives overall system health status from AI results and energy consumption.
  ///
  /// - Critical: any source at critical severity OR totalKwh > 50
  /// - Caution: any source at danger/warning severity OR totalKwh > 20
  /// - Healthy: all other states
  static SystemHealthStatus deriveHealth(
    AiResult sim,
    AiResult hw,
    double totalKwh,
  ) {
    final severities = [sim.severity, hw.severity];
    if (severities.any((s) => s == AiSeverity.critical) || totalKwh > 50) {
      return SystemHealthStatus.critical;
    }
    if (severities.any(
          (s) => s == AiSeverity.danger || s == AiSeverity.warning,
        ) ||
        totalKwh > 20) {
      return SystemHealthStatus.caution;
    }
    return SystemHealthStatus.healthy;
  }
}
