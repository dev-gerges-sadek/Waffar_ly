import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../ai/data/ai_results_repository.dart';
import '../../ai/models/ai_result.dart';
import 'ai_energy_state.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// UNIFIED AI ENERGY CUBIT
/// ─────────────────────────────────────────────────────────────────────────────
/// Consolidates AiCubit, EnergyCubit, and AiEnergyCubit into a single cubit.
/// Emits AiEnergyLoaded state (compatible with AiEnergyDashboard).

class UnifiedAiEnergyCubit extends Cubit<AiEnergyState> {
  UnifiedAiEnergyCubit(this._aiRepo) : super(AiEnergyInitial()) {
    _initPrefs();
  }

  final AiResultsRepository _aiRepo;
  late double _rate;
  late SharedPreferences _prefs;

  // Subscriptions
  StreamSubscription<dynamic>? _aiSimSub;
  StreamSubscription<dynamic>? _aiHwSub;
  StreamSubscription<dynamic>? _aiRealDeviceSub;
  StreamSubscription<dynamic>? _deviceStateSub;

  // Cached data
  AiResult? _simResult;
  AiResult? _hwResult;
  AiResult? _realDeviceResult;
  List<EnergyRecord> _energyRecords = [];

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _rate = _prefs.getDouble(AppConstants.keyElectricityRate) ?? 0.05;
  }

  /// Start listening to all streams
  void startListening() {
    if (isClosed) return;
    emit(AiEnergyLoading());
    _subscribeToAi();
    _subscribeToEnergyRecords();
  }

  /// Update electricity rate
  Future<void> updateRate(double newRate) async {
    if (newRate <= 0) return;
    _rate = newRate;
    await _prefs.setDouble(AppConstants.keyElectricityRate, newRate);
    _emitState();
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// PRIVATE: AI SUBSCRIPTIONS
  /// ─────────────────────────────────────────────────────────────────────────

  void _subscribeToAi() {
    // Simulator
    _aiSimSub?.cancel();
    _aiSimSub = _aiRepo.watchSimulator().listen(
      (data) {
        _simResult = data != null
            ? _sanitiseAiResult(data, 'simulator')
            : AiResult.idle('simulator');
        _emitState();
      },
      onError: (e) {
        debugPrint('[UnifiedAiEnergyCubit] Simulator error: $e');
        _simResult = AiResult.idle('simulator');
        _emitState();
      },
    );

    // Hardware
    _aiHwSub?.cancel();
    _aiHwSub = _aiRepo.watchHardware().listen(
      (data) {
        _hwResult = data != null
            ? _sanitiseAiResult(data, 'hardware')
            : AiResult.idle('hardware');
        _emitState();
      },
      onError: (e) {
        debugPrint('[UnifiedAiEnergyCubit] Hardware error: $e');
        _hwResult = AiResult.idle('hardware');
        _emitState();
      },
    );

    // Real Device
    _aiRealDeviceSub?.cancel();
    _aiRealDeviceSub = _aiRepo.watchRealDeviceAiResults().listen(
      (data) {
        _realDeviceResult = data != null
            ? _sanitiseAiResult(data, 'Real_Device_01')
            : AiResult.idle('Real_Device_01');
        _emitState();
      },
      onError: (e) {
        debugPrint('[UnifiedAiEnergyCubit] Real Device error: $e');
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
        debugPrint('[UnifiedAiEnergyCubit] Energy error: $e');
        _energyRecords = [];
        _emitState();
      },
    );
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// PRIVATE: SANITIZATION
  /// ─────────────────────────────────────────────────────────────────────────

  AiResult _sanitiseAiResult(Map<String, dynamic> data, String src) {
    final watts = (data['watts'] as num?)?.toDouble() ?? 0;
    final amperes = (data['amperes'] as num?)?.toDouble() ?? 0;
    final kwh = (data['kwh_consumed'] as num?)?.toDouble() ?? 0;
    final voltage = (data['voltage'] as num?)?.toDouble() ?? 0;

    // All readings are zero: idle
    if (watts == 0 && amperes == 0 && kwh == 0) {
      return AiResult.idle(src);
    }

    // Only voltage without power: idle
    if (voltage > 0 && watts == 0 && amperes == 0) {
      return AiResult.idle(src);
    }

    final result = AiResult.fromFirestore(data, src);

    // Fix false anomalies
    if (result.probAnomalyPct < 30 &&
        (result.severity == AiSeverity.danger ||
            result.severity == AiSeverity.critical)) {
      return result.copyWithSeverity(AiSeverity.normal);
    }

    // Recompute severity
    final recomputed = _recomputeSeverity(watts, amperes);
    if (recomputed != result.severity) {
      return result.copyWithSeverity(recomputed);
    }

    return result;
  }

  AiSeverity _recomputeSeverity(double watts, double amps) {
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

  /// ─────────────────────────────────────────────────────────────────────────
  /// PRIVATE: STATE EMISSION
  /// ─────────────────────────────────────────────────────────────────────────

  void _emitState() {
    if (isClosed) return;

    final sim = _simResult ?? AiResult.idle('simulator');
    final hw = _hwResult ?? AiResult.idle('hardware');
    final records = _energyRecords;

    // Energy calculations
    final totalKwh = records.fold(0.0, (sum, r) => sum + r.kwh);
    final cost = totalKwh * _rate;
    final sorted = [...records]..sort((a, b) => b.kwh.compareTo(a.kwh));
    final topDevices = sorted.take(5).toList();

    // Room breakdown
    final roomMap = <String, double>{};
    for (final r in records) {
      final room = _roomFromId(r.deviceId);
      roomMap[room] = (roomMap[room] ?? 0) + r.kwh;
    }
    final roomBreakdown = roomMap.entries
        .map((e) => RoomEnergy(roomName: e.key, totalKwh: e.value))
        .toList()
      ..sort((a, b) => b.totalKwh.compareTo(a.totalKwh));

    // System health
    final health = _deriveSystemHealth(sim, hw, totalKwh);

    emit(AiEnergyLoaded(
      simulator: sim,
      hardware: hw,
      records: records,
      totalKwh: totalKwh,
      estimatedCost: cost,
      topDevices: topDevices,
      roomBreakdown: roomBreakdown,
      electricityRate: _rate,
      systemHealth: health,
      lastRefreshed: DateTime.now(),
    ));
  }

  String _roomFromId(String id) {
    for (final e in AppConstants.roomSuffixMap.entries) {
      if (id.contains('_${e.key}_')) return e.value;
    }
    return 'Other';
  }

  SystemHealthStatus _deriveSystemHealth(
      AiResult sim, AiResult hw, double totalKwh) {
    final severities = [sim.severity, hw.severity];
    if (severities.any((s) => s == AiSeverity.critical) || totalKwh > 50) {
      return SystemHealthStatus.critical;
    }
    if (severities.any(
            (s) => s == AiSeverity.danger || s == AiSeverity.warning) ||
        totalKwh > 20) {
      return SystemHealthStatus.caution;
    }
    return SystemHealthStatus.healthy;
  }

  @override
  Future<void> close() {
    _aiSimSub?.cancel();
    _aiHwSub?.cancel();
    _aiRealDeviceSub?.cancel();
    _deviceStateSub?.cancel();
    return super.close();
  }
}
