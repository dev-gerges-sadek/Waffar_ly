// ============================================================================
// ai_energy_cubit.dart
// Single cubit that streams both AI analysis results and device energy data
// from Firestore, sanitises the AI output, and emits a unified AiEnergyLoaded
// state consumed by the dashboard UI.
//
// Replaces:
//   - UnifiedAiEnergyCubit (ai_energy_dashboard/)
//   - UnifiedEnergyAiCubit (energy/)
//   - AiResultCubit (energy/)
// ============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../data/ai_energy_repository.dart';
import '../models/ai_result.dart';
import '../models/energy_record.dart';
import '../utils/ai_utilities.dart';
import 'ai_energy_state.dart';

class AiEnergyCubit extends Cubit<AiEnergyState> {
  AiEnergyCubit(this._repo) : super(AiEnergyInitial()) {
    _initPrefs();
  }

  final AiEnergyRepository _repo;

  late SharedPreferences _prefs;
  double _rate = 1.25;

  StreamSubscription<dynamic>? _simSub;
  StreamSubscription<dynamic>? _hwSub;
  StreamSubscription<dynamic>? _deviceSub;

  // Cached values
  AiResult? _simResult;
  AiResult? _hwResult;
  List<EnergyRecord> _energyRecords = [];

  // ── Public API ────────────────────────────────────────────────────────────

  /// Begin streaming all Firestore data.
  void startListening() {
    if (isClosed) return;
    emit(AiEnergyLoading());
    _subscribeAi();
    _subscribeDevices();
  }

  /// Update electricity rate and persist to SharedPreferences.
  Future<void> updateRate(double newRate) async {
    if (newRate <= 0) return;
    _rate = newRate;
    await _prefs.setDouble(AppConstants.keyElectricityRate, newRate);
    _emitLoaded();
  }

  // ── Private: initialisation ───────────────────────────────────────────────

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _rate = _prefs.getDouble(AppConstants.keyElectricityRate) ?? 1.25;
  }

  // ── Private: subscriptions ────────────────────────────────────────────────

  void _subscribeAi() {
    _simSub?.cancel();
    _simSub = _repo.watchSimulator().listen(
      (data) {
        _simResult = data != null
            ? AiUtilities.sanitise(data, 'simulator')
            : AiResult.idle('simulator');
        _emitLoaded();
      },
      onError: (Object e) {
        debugPrint('[AiEnergyCubit] simulator error: $e');
        _simResult = AiResult.idle('simulator');
        _emitLoaded();
      },
    );

    _hwSub?.cancel();
    _hwSub = _repo.watchHardware().listen(
      (data) {
        _hwResult = data != null
            ? AiUtilities.sanitise(data, 'hardware')
            : AiResult.idle('hardware');
        _emitLoaded();
      },
      onError: (Object e) {
        debugPrint('[AiEnergyCubit] hardware error: $e');
        _hwResult = AiResult.idle('hardware');
        _emitLoaded();
      },
    );
  }

  void _subscribeDevices() {
    _deviceSub?.cancel();
    _deviceSub = _repo.watchDeviceStates().listen(
      (records) {
        _energyRecords = records;
        _emitLoaded();
      },
      onError: (Object e) {
        debugPrint('[AiEnergyCubit] device states error: $e');
        _energyRecords = [];
        _emitLoaded();
      },
    );
  }

  // ── Private: state emission ───────────────────────────────────────────────

  void _emitLoaded() {
    if (isClosed) return;

    final sim = _simResult ?? AiResult.idle('simulator');
    final hw = _hwResult ?? AiResult.idle('hardware');

    // Energy aggregations
    final totalKwh = _energyRecords.fold<double>(0.0, (sum, r) => sum + r.kwh);
    final estimatedCost = totalKwh * _rate;
    final sorted = [..._energyRecords]..sort((a, b) => b.kwh.compareTo(a.kwh));
    final topDevices = sorted.take(5).toList();

    // Room breakdown
    final roomMap = <String, double>{};
    for (final r in _energyRecords) {
      final room = AiUtilities.roomFromDeviceId(r.deviceId);
      roomMap[room] = (roomMap[room] ?? 0) + r.kwh;
    }
    final roomBreakdown =
        roomMap.entries
            .map((e) => RoomEnergy(roomName: e.key, totalKwh: e.value))
            .toList()
          ..sort((a, b) => b.totalKwh.compareTo(a.totalKwh));

    emit(
      AiEnergyLoaded(
        simulator: sim,
        hardware: hw,
        records: _energyRecords,
        totalKwh: totalKwh,
        estimatedCost: estimatedCost,
        topDevices: topDevices,
        roomBreakdown: roomBreakdown,
        electricityRate: _rate,
        systemHealth: AiUtilities.deriveHealth(sim, hw, totalKwh),
        lastRefreshed: DateTime.now(),
      ),
    );
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _simSub?.cancel();
    _hwSub?.cancel();
    _deviceSub?.cancel();
    return super.close();
  }
}
