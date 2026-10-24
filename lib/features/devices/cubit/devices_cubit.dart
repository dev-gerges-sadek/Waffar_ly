import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/device_model.dart';
import '../../devices/domain/repositories/device_repository.dart';
import 'devices_states.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit({DeviceRepository? repository})
    : _repository = repository ?? GetIt.I<DeviceRepository>(),
      super(DevicesInitial());

  final DeviceRepository _repository;
  StreamSubscription<List<DeviceModel>>? _deviceSub;
  final Map<String, DeviceModel> _devices = {};
  int _toggleErrors = 0;

  void loadDevicesForRoom(String roomKey) {
    emit(DevicesLoading());
    _devices.clear();
    _deviceSub?.cancel();
    _deviceSub = _repository
        .watchDevicesForRoom(roomKey)
        .listen(
          (devices) {
            // The stream is the source of truth: replace, so devices that
            // disappeared upstream do not linger.
            _devices
              ..clear()
              ..addEntries(devices.map((d) => MapEntry(d.id, d)));
            _emitLoaded();
          },
          onError: (Object e) {
            if (kDebugMode) debugPrint('[DevicesCubit] stream error: $e');
            if (!isClosed) emit(DevicesError());
          },
        );
  }

  /// Toggles the active source (hardware-first via CombinedRepo).
  Future<void> toggleDevice(String deviceId, bool newStatus) async {
    final current = _devices[deviceId];
    if (current == null) return;
    final hardwareActive = current.hardwareData?.isOn ?? false;
    await _toggle(
      current,
      newStatus,
      source: hardwareActive
          ? DeviceSourceType.hardware
          : DeviceSourceType.simulation,
      touchHardware: hardwareActive,
    );
  }

  /// Force-toggle the Firestore simulation source only.
  Future<void> toggleSimulation(String deviceId, bool newStatus) async {
    final current = _devices[deviceId];
    if (current == null) return;
    await _toggle(
      current,
      newStatus,
      source: DeviceSourceType.simulation,
      touchHardware: false,
    );
  }

  /// Force-toggle the physical hardware source only.
  Future<void> toggleHardware(String deviceId, bool newStatus) async {
    final current = _devices[deviceId];
    if (current == null) return;
    await _toggle(
      current,
      newStatus,
      source: DeviceSourceType.hardware,
      touchHardware: true,
    );
  }

  /// Optimistic update -> repository write -> revert + error signal on failure.
  Future<void> _toggle(
    DeviceModel current,
    bool newStatus, {
    required DeviceSourceType source,
    required bool touchHardware,
  }) async {
    final status = newStatus ? 'ON' : 'OFF';
    final updated = touchHardware
        ? current.copyWith(
            hardwareData: current.hardwareData?.copyWith(status: status),
            simulationData: current.simulationData,
            source: source,
          )
        : current.copyWith(
            simulationData: current.simulationData?.copyWith(status: status),
            hardwareData: current.hardwareData,
            hardwareSensor: current.hardwareSensor,
            source: source,
          );
    _devices[current.id] = updated;
    _emitLoaded();

    try {
      await _repository.toggleDevice(updated, newStatus);
    } catch (e) {
      if (kDebugMode) debugPrint('[DevicesCubit] toggle error: $e');
      _devices[current.id] = current;
      _toggleErrors++;
      _emitLoaded();
    }
  }

  void _emitLoaded() {
    if (isClosed) return;
    final list = List<DeviceModel>.unmodifiable(_devices.values);
    final onlineHw = list
        .where((d) => d.hardwareSensor?.status == SensorStatus.online)
        .length;
    emit(
      DevicesLoaded(
        list,
        hwOnlineCount: onlineHw,
        toggleErrorSeq: _toggleErrors,
      ),
    );
  }

  @override
  Future<void> close() {
    _deviceSub?.cancel();
    return super.close();
  }
}
