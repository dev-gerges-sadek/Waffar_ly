import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../ai/data/ai_results_repository.dart';
import '../../ai/models/ai_result.dart';
import 'energy_states.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// UNIFIED ENERGY + AI CUBIT
/// ─────────────────────────────────────────────────────────────────────────────
/// Consolidates AiCubit, EnergyCubit, and AiEnergyCubit into a single, streamlined
/// cubit that eliminates duplication and reduces complexity.
///
/// Features:
/// - Real-time energy consumption from device_states
/// - AI analysis from ai_results/{simulator|hardware|Real_Device_01}
/// - Electricity rate management
/// - Shared sanitization logic for AI results
/// - Optimized state emission for UI performance

class UnifiedEnergyAiCubit extends Cubit<EnergyLoaded> {
  UnifiedEnergyAiCubit(this._aiRepo)
      : _energyState = EnergyLoaded(
          records: [],
          totalKwh: 0.0,
          totalWatts: 0.0,
          estimatedCost: 0.0,
          topDevices: [],
          roomBreakdown: [],
          electricityRate: 1.25,
          predictedMonthly: 0.0,
          lastSyncedAt: DateTime.now(),
        ),
        super(EnergyLoaded(
          records: [],
          totalKwh: 0.0,
          totalWatts: 0.0,
          estimatedCost: 0.0,
          topDevices: [],
          roomBreakdown: [],
          electricityRate: 1.25,
          predictedMonthly: 0.0,
          lastSyncedAt: DateTime.now(),
        )) {
    _initPrefs();
  }

  final AiResultsRepository _aiRepo;
  late EnergyLoaded _energyState;
  late double _rate;
  late SharedPreferences _prefs;

  // Subscriptions
  StreamSubscription<dynamic>? _aiSimSub;
  StreamSubscription<dynamic>? _aiHwSub;
  StreamSubscription<dynamic>? _aiRealDeviceSub;
  StreamSubscription<dynamic>? _deviceStateSub;

  // Cached AI results
  AiResult? _simResult;
  AiResult? _hwResult;
  AiResult? _realDeviceResult;

  // Cached energy records
  List<EnergyRecord> _energyRecords = [];

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _rate = _prefs.getDouble(AppConstants.keyElectricityRate) ?? 1.25;
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// PUBLIC API
  /// ─────────────────────────────────────────────────────────────────────────

  /// Start listening to all energy and AI streams
  void startListening() {
    _subscribeToAi();
    _subscribeToEnergyRecords();
  }

  /// Update electricity rate (persisted to SharedPreferences)
  Future<void> updateRate(double newRate) async {
    if (newRate <= 0) return;
    _rate = newRate;
    await _prefs.setDouble(AppConstants.keyElectricityRate, newRate);
    _emitState();
  }

  /// Get all three AI results (simulator, hardware, real device)
  (AiResult?, AiResult?, AiResult?) getAiResults() =>
      (_simResult, _hwResult, _realDeviceResult);

  /// Get current energy state
  EnergyLoaded getEnergyState() => _energyState;

  /// ─────────────────────────────────────────────────────────────────────────
  /// PRIVATE: AI SUBSCRIPTIONS
  /// ─────────────────────────────────────────────────────────────────────────

  void _subscribeToAi() {
    // Simulator AI
    _aiSimSub?.cancel();
    _aiSimSub = _aiRepo.watchSimulator().listen(
      (data) {
        _simResult = data != null
            ? _sanitiseAiResult(data, 'simulator')
            : AiResult.idle('simulator');
        _emitState();
      },
      onError: (e) {
        debugPrint('[UnifiedCubit] AI Simulator error: $e');
        _simResult = AiResult.idle('simulator');
        _emitState();
      },
    );

    // Hardware AI
    _aiHwSub?.cancel();
    _aiHwSub = _aiRepo.watchHardware().listen(
      (data) {
        _hwResult = data != null
            ? _sanitiseAiResult(data, 'hardware')
            : AiResult.idle('hardware');
        _emitState();
      },
      onError: (e) {
        debugPrint('[UnifiedCubit] AI Hardware error: $e');
        _hwResult = AiResult.idle('hardware');
        _emitState();
      },
    );

    // Real Device AI
    _aiRealDeviceSub?.cancel();
    _aiRealDeviceSub = _aiRepo.watchRealDeviceAiResults().listen(
      (data) {
        _realDeviceResult = data != null
            ? _sanitiseAiResult(data, 'Real_Device_01')
            : AiResult.idle('Real_Device_01');
        _emitState();
      },
      onError: (e) {
        debugPrint('[UnifiedCubit] AI Real Device error: $e');
        _realDeviceResult = AiResult.idle('Real_Device_01');
        _emitState();
      },
    );
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// PRIVATE: ENERGY SUBSCRIPTIONS
  /// ─────────────────────────────────────────────────────────────────────────

  void _subscribeToEnergyRecords() {
    _deviceStateSub?.cancel();
    _deviceStateSub = _aiRepo.watchDeviceStates().listen(
      (records) {
        _energyRecords = records;
        _emitState();
      },
      onError: (e) {
        debugPrint('[UnifiedCubit] Energy records error: $e');
        _energyRecords = [];
        _emitState();
      },
    );
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// PRIVATE: AI SANITIZATION (CONSOLIDATED LOGIC)
  /// ─────────────────────────────────────────────────────────────────────────
  /// Prevents false anomalies when all readings are zero.

  AiResult _sanitiseAiResult(Map<String, dynamic> data, String src) {
    final watts = (data['watts'] as num?)?.toDouble() ?? 0;
    final amperes = (data['amperes'] as num?)?.toDouble() ?? 0;
    final kwh = (data['kwh_consumed'] as num?)?.toDouble() ?? 0;
    final voltage = (data['voltage'] as num?)?.toDouble() ?? 0;

    // All readings are zero: mark as idle
    if (watts == 0 && amperes == 0 && kwh == 0) {
      return AiResult.idle(src);
    }

    // Only voltage without power: idle
    if (voltage > 0 && watts == 0 && amperes == 0) {
      return AiResult.idle(src);
    }

    final result = AiResult.fromFirestore(data, src);

    // Fix severity mismatch: low anomaly probability but high severity
    if (result.probAnomalyPct < 30 &&
        (result.severity == AiSeverity.danger ||
            result.severity == AiSeverity.critical)) {
      return result.copyWithSeverity(AiSeverity.normal);
    }

    // Recompute severity based on actual watts/amps
    final recomputed = _recomputeSeverity(watts, amperes, result.probAnomalyPct);
    if (recomputed != result.severity) {
      return result.copyWithSeverity(recomputed);
    }

    return result;
  }

  AiSeverity _recomputeSeverity(double watts, double amps, int probAnomaly) {
    if (watts == 0 && amps == 0) return AiSeverity.normal;
    if (probAnomaly >= 90) return AiSeverity.critical;
    if (probAnomaly >= 70) return AiSeverity.danger;
    if (probAnomaly >= 50) return AiSeverity.warning;
    if (probAnomaly >= 30) return AiSeverity.anomaly;
    return AiSeverity.normal;
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// PRIVATE: STATE EMISSION
  /// ─────────────────────────────────────────────────────────────────────────

  void _emitState() {
    if (isClosed) return;

    // Calculate totals from device records
    final deviceWatts =
        _energyRecords.fold(0.0, (sum, r) => sum + r.watts);
    final totalKwh = _realDeviceResult?.kwhConsumed ??
        _energyRecords.fold(0.0, (sum, r) => sum + r.kwh);
    final estimatedCost = totalKwh * _rate;
    final predictedMonthly =
        _realDeviceResult?.predictedMonthlyEgp ?? (totalKwh * 30 * _rate);

    // Get top 5 devices by consumption
    final sorted = [..._energyRecords]
      ..sort((a, b) => b.watts.compareTo(a.watts));
    final topDevices = sorted.take(5).toList();

    // Group by room
    final roomMap = <String, double>{};
    for (final record in _energyRecords) {
      final roomName = _extractRoomName(record.deviceId);
      roomMap[roomName] = (roomMap[roomName] ?? 0) + record.watts;
    }
    final roomBreakdown = roomMap.entries
        .map((e) => RoomEnergy(roomName: e.key, totalKwh: e.value))
        .toList()
      ..sort((a, b) => b.totalKwh.compareTo(a.totalKwh));

    _energyState = EnergyLoaded(
      records: _energyRecords,
      totalKwh: totalKwh,
      totalWatts: deviceWatts > 0 ? deviceWatts : _realDeviceResult?.watts ?? 0,
      estimatedCost: estimatedCost,
      topDevices: topDevices,
      roomBreakdown: roomBreakdown,
      electricityRate: _rate,
      predictedMonthly: predictedMonthly,
      lastSyncedAt: DateTime.now(),
    );

    emit(_energyState);
  }

  String _extractRoomName(String deviceId) {
    // Lamp_LR_01 → Living Room
    // AC_BR_01 → Bedroom
    if (deviceId.contains('_LR_')) return 'Living Room';
    if (deviceId.contains('_BR_')) return 'Bedroom';
    if (deviceId.contains('_K_')) return 'Kitchen';
    if (deviceId.contains('_B_')) return 'Bathroom';
    if (deviceId.contains('_R2_')) return 'Room 2';
    return 'Unknown';
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// CLEANUP
  /// ─────────────────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _aiSimSub?.cancel();
    _aiHwSub?.cancel();
    _aiRealDeviceSub?.cancel();
    _deviceStateSub?.cancel();
    return super.close();
  }
}
