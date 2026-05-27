import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/device_model.dart';
import '../../devices/domain/repositories/device_repository.dart';
import 'devices_states.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit()
    : _repository = GetIt.I<DeviceRepository>(),
      super(DevicesInitial());

  final DeviceRepository _repository;
  StreamSubscription<List<DeviceModel>>? _deviceSub;
  final Map<String, DeviceModel> _devices = {};

  void loadDevicesForRoom(String roomKey) {
    emit(DevicesLoading());
    _devices.clear();
    _deviceSub?.cancel();
    _deviceSub = _repository.watchDevicesForRoom(roomKey).listen((devices) {
      for (final d in devices) {
        _devices[d.id] = d;
      }
      _emitLoaded();
    }, onError: (Object e) => emit(DevicesError(e.toString())));
  }

  /// Toggles active source (hardware-first via CombinedRepo).
  Future<void> toggleDevice(String deviceId, bool newStatus) async {
    final current = _devices[deviceId];
    if (current == null) return;

    // Determine which source is active and update only that source
    final isHardwareActive = current.hardwareData?.isOn ?? false;

    // ── Optimistic update ───────────────────────────────────────────
    final updated = isHardwareActive
        ? current.copyWith(
            hardwareData: current.hardwareData?.copyWith(
              status: newStatus ? 'ON' : 'OFF',
            ),
            simulationData: current.simulationData, // Preserve simulation
          )
        : current.copyWith(
            simulationData: current.simulationData?.copyWith(
              status: newStatus ? 'ON' : 'OFF',
            ),
            hardwareData: current.hardwareData, // Preserve hardware
          );
    _devices[deviceId] = updated;
    _emitLoaded();

    try {
      await _repository.toggleDevice(current, newStatus);
    } on Exception catch (e) {
      debugPrint('[DevicesCubit] toggleDevice error: $e');
      // Revert on error
      _devices[deviceId] = current;
      _emitLoaded();
      // Emit error state so UI can show feedback
      if (!isClosed) {
        emit(DevicesError('Failed to toggle device: ${e.toString()}'));
        // Re-emit loaded state after showing error
        await Future.delayed(const Duration(seconds: 2));
        if (!isClosed) _emitLoaded();
      }
    }
  }

  /// Force-toggle Firestore simulation source only.
  Future<void> toggleSimulation(String deviceId, bool newStatus) async {
    final current = _devices[deviceId];
    if (current == null) return;

    // ── Preserve all hardware state (critical for decoupled toggles) ────
    final preservedHardwareData = current.hardwareData;
    final preservedHardwareSensor = current.hardwareSensor;

    // ── Optimistic update: update local state immediately ───────────
    final updated = current.copyWith(
      simulationData: current.simulationData?.copyWith(
        status: newStatus ? 'ON' : 'OFF',
      ),
      // Explicitly preserve hardware state to prevent any state bleed
      hardwareData: preservedHardwareData,
      hardwareSensor: preservedHardwareSensor,
      source: DeviceSourceType.simulation, // ← Explicit source
    );
    _devices[deviceId] = updated;
    _emitLoaded(); // UI updates immediately

    try {
      // ← Send the UPDATED device with new simulation status
      await _repository.toggleDevice(updated, newStatus);
    } on Exception catch (e) {
      debugPrint('[DevicesCubit] toggleSimulation error: $e');
      // Revert on error
      _devices[deviceId] = current;
      _emitLoaded();
      // Emit error state so UI can show feedback
      if (!isClosed) {
        emit(DevicesError('Failed to toggle simulation: ${e.toString()}'));
        // Re-emit loaded state after showing error
        await Future.delayed(const Duration(seconds: 2));
        if (!isClosed) _emitLoaded();
      }
    }
  }

  /// Force-toggle RTDB hardware source only.
  Future<void> toggleHardware(String deviceId, bool newStatus) async {
    final current = _devices[deviceId];
    if (current == null) return;

    // ── Preserve all simulation state (critical for decoupled toggles) ────
    final preservedSimulationData = current.simulationData;

    // ── Optimistic update: update local state immediately ───────────
    final updated = current.copyWith(
      hardwareData: current.hardwareData?.copyWith(
        status: newStatus ? 'ON' : 'OFF',
      ),
      // Explicitly preserve simulation state to prevent any state bleed
      simulationData: preservedSimulationData,
      source: DeviceSourceType.hardware, // ← Explicit source
    );
    _devices[deviceId] = updated;
    _emitLoaded(); // UI updates immediately

    try {
      // ← Send the UPDATED device with new hardware status
      await _repository.toggleDevice(updated, newStatus);
    } on Exception catch (e) {
      debugPrint('[DevicesCubit] toggleHardware error: $e');
      // Revert on error
      _devices[deviceId] = current;
      _emitLoaded();
      // Emit error state so UI can show feedback
      if (!isClosed) {
        emit(DevicesError('Failed to toggle hardware: ${e.toString()}'));
        // Re-emit loaded state after showing error
        await Future.delayed(const Duration(seconds: 2));
        if (!isClosed) _emitLoaded();
      }
    }
  }

  void _emitLoaded() {
    if (isClosed) return;
    final list = List<DeviceModel>.unmodifiable(_devices.values);
    final onlineHw = list
        .where((d) => d.hardwareSensor?.status == SensorStatus.online)
        .length;
    emit(DevicesLoaded(list, hwOnlineCount: onlineHw));
  }

  @override
  Future<void> close() {
    _deviceSub?.cancel();
    return super.close();
  }
}
