// ============================================================================
// ai_energy_state.dart
// Sealed state hierarchy for the unified AI + Energy dashboard cubit.
// ============================================================================

import '../models/ai_result.dart';
import '../models/energy_record.dart';

// ── System health ─────────────────────────────────────────────────────────────

/// Overall system health derived from AI severity and live energy load.
enum SystemHealthStatus { healthy, caution, critical, loading }

extension SystemHealthStatusX on SystemHealthStatus {
  /// Locale-aware label.
  String label(bool isArabic) {
    if (isArabic) {
      switch (this) {
        case SystemHealthStatus.healthy:
          return 'طبيعي';
        case SystemHealthStatus.caution:
          return 'تحذير';
        case SystemHealthStatus.critical:
          return 'حرج';
        case SystemHealthStatus.loading:
          return 'جارٍ التحميل…';
      }
    }
    switch (this) {
      case SystemHealthStatus.healthy:
        return 'Healthy';
      case SystemHealthStatus.caution:
        return 'Caution';
      case SystemHealthStatus.critical:
        return 'Critical';
      case SystemHealthStatus.loading:
        return 'Loading…';
    }
  }

  String get emoji {
    switch (this) {
      case SystemHealthStatus.healthy:
        return '✅';
      case SystemHealthStatus.caution:
        return '⚠️';
      case SystemHealthStatus.critical:
        return '🚨';
      case SystemHealthStatus.loading:
        return '⏳';
    }
  }
}

// ── Sealed states ─────────────────────────────────────────────────────────────

sealed class AiEnergyState {}

/// Before any data fetch begins.
class AiEnergyInitial extends AiEnergyState {}

/// Spinner shown on first load.
class AiEnergyLoading extends AiEnergyState {}

/// Error state — shown with a retry button.
class AiEnergyError extends AiEnergyState {
  AiEnergyError(this.message);
  final String message;
}

/// Fully loaded state — the only state the UI cares about.
class AiEnergyLoaded extends AiEnergyState {
  AiEnergyLoaded({
    required this.simulator,
    required this.hardware,
    required this.records,
    required this.totalKwh,
    required this.estimatedCost,
    required this.topDevices,
    required this.roomBreakdown,
    required this.electricityRate,
    required this.systemHealth,
    required this.lastRefreshed,
  });

  // AI sources
  final AiResult simulator;
  final AiResult hardware;

  // Energy data
  final List<EnergyRecord> records;
  final double totalKwh;
  final double estimatedCost;
  final List<EnergyRecord> topDevices;
  final List<RoomEnergy> roomBreakdown;
  final double electricityRate;

  // Derived
  final SystemHealthStatus systemHealth;
  final DateTime lastRefreshed;

  // ── Computed getters used by widgets ──────────────────────────────────────

  /// Max anomaly probability across both sources.
  int get maxAnomalyPct =>
      simulator.probAnomalyPct > hardware.probAnomalyPct
          ? simulator.probAnomalyPct
          : hardware.probAnomalyPct;

  /// True when either source reports an anomaly.
  bool get hasAnomaly => simulator.isAnomaly || hardware.isAnomaly;

  /// Worst severity across both sources.
  AiSeverity get worstSeverity {
    final severities = [simulator.severity, hardware.severity];
    if (severities.any((s) => s == AiSeverity.critical)) {
      return AiSeverity.critical;
    }
    if (severities.any((s) => s == AiSeverity.danger)) return AiSeverity.danger;
    if (severities.any((s) => s == AiSeverity.warning)) {
      return AiSeverity.warning;
    }
    return AiSeverity.normal;
  }

  /// Combined live watts (sim + hardware).
  double get totalLiveWatts => simulator.watts + hardware.watts;

  /// Combined live amperes.
  double get totalLiveAmperes => simulator.amperes + hardware.amperes;

  /// Combined predicted monthly cost in EGP.
  double get totalPredictedMonthlyEgp =>
      simulator.predictedMonthlyEgp + hardware.predictedMonthlyEgp;

  /// Active device count.
  int get deviceCount => records.length;

  // ── Immutable copy ────────────────────────────────────────────────────────

  AiEnergyLoaded copyWith({
    AiResult? simulator,
    AiResult? hardware,
    List<EnergyRecord>? records,
    double? totalKwh,
    double? estimatedCost,
    List<EnergyRecord>? topDevices,
    List<RoomEnergy>? roomBreakdown,
    double? electricityRate,
    SystemHealthStatus? systemHealth,
    DateTime? lastRefreshed,
  }) =>
      AiEnergyLoaded(
        simulator: simulator ?? this.simulator,
        hardware: hardware ?? this.hardware,
        records: records ?? this.records,
        totalKwh: totalKwh ?? this.totalKwh,
        estimatedCost: estimatedCost ?? this.estimatedCost,
        topDevices: topDevices ?? this.topDevices,
        roomBreakdown: roomBreakdown ?? this.roomBreakdown,
        electricityRate: electricityRate ?? this.electricityRate,
        systemHealth: systemHealth ?? this.systemHealth,
        lastRefreshed: lastRefreshed ?? this.lastRefreshed,
      );
}
