import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/device_model.dart';
import 'devices_states.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit() : super(DevicesInitial());

  final _firestore = FirebaseFirestore.instance;
  StreamSubscription? _simSub;
  StreamSubscription? _hwSub;

  // Current loaded devices list (merged sim + hw)
  final Map<String, DeviceModel> _devices = {};

  /// Load devices for a specific room.
  /// [roomKey] e.g. 'living_room', deviceIds e.g. ['Lamp_LR_01', 'Fan_LR_01']
  void loadDevicesForRoom(String roomKey) {
    emit(DevicesLoading());
    _devices.clear();

    final deviceIds = kRoomDevices[roomKey] ?? [];

    // Build initial device list (no data yet)
    for (final id in deviceIds) {
      _devices[id] = DeviceModel(
        id: id,
        name: _formatName(id),
        type: id.toDeviceType(),
        roomId: roomKey,
      );
    }

    // ── Simulation stream ──────────────────────────────────────────────────
    _simSub?.cancel();
    _simSub = _firestore
        .collection('device_states')
        .snapshots()
        .listen((snapshot) {
      for (final doc in snapshot.docs) {
        if (deviceIds.contains(doc.id)) {
          final current = _devices[doc.id];
          if (current != null) {
            _devices[doc.id] = current.copyWith(
              simulationData: DeviceData.fromFirestore(doc.data()),
            );
          }
        }
      }
      _emitLoaded();
    }, onError: (e) => emit(DevicesError(e.toString())));

    // ── Hardware stream ────────────────────────────────────────────────────
    // The hardware team will use a separate collection: 'device_states_hw'
    _hwSub?.cancel();
    _hwSub = _firestore
        .collection('device_states_hw')
        .snapshots()
        .listen((snapshot) {
      for (final doc in snapshot.docs) {
        if (deviceIds.contains(doc.id)) {
          final current = _devices[doc.id];
          if (current != null) {
            _devices[doc.id] = current.copyWith(
              hardwareData: DeviceData.fromFirestore(doc.data()),
            );
          }
        }
      }
      _emitLoaded();
    }, onError: (_) {
      // Hardware data not available yet — just ignore
    });
  }

  /// Toggle device ON/OFF in Firestore simulation collection
  Future<void> toggleDevice(String deviceId, bool newStatus) async {
    try {
      await _firestore.collection('device_states').doc(deviceId).update({
        'status': newStatus ? 'ON' : 'OFF',
        'last_updated': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  void _emitLoaded() {
    if (!isClosed) emit(DevicesLoaded(List.unmodifiable(_devices.values)));
  }

  String _formatName(String id) {
    // "Lamp_LR_01" → "Lamp LR 01"
    return id.replaceAll('_', ' ');
  }

  @override
  Future<void> close() {
    _simSub?.cancel();
    _hwSub?.cancel();
    return super.close();
  }
}
