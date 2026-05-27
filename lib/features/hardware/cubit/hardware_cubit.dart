import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../models/hardware_device.dart';
import 'hardware_states.dart';

class HardwareCubit extends Cubit<HardwareState> {
  HardwareCubit() : super(HardwareInitial());

  final _db = FirebaseFirestore.instance;
  StreamSubscription? _sub;
  Timer? _reconnectTimer;
  HwConnectionStatus _connStatus = HwConnectionStatus.disconnected;

  void startListening() {
    emit(HardwareLoading());
    _connStatus = HwConnectionStatus.reconnecting;

    _sub?.cancel();
    // Listen to Real_Device_01 from Devices collection
    _sub = _db
        .collection('Devices')
        .doc(AppConstants.docRealDevice)
        .snapshots()
        .listen(
          (snap) {
            _reconnectTimer?.cancel();
            _connStatus = HwConnectionStatus.connected;

            if (snap.exists && snap.data() != null) {
              final device = HardwareDevice.fromFirestore(
                snap.id,
                snap.data() as Map<String, dynamic>,
              );

              if (!isClosed) {
                emit(
                  HardwareLoaded(
                    devices: [device],
                    connectionStatus: _connStatus,
                  ),
                );
              }
            } else {
              if (!isClosed) {
                emit(
                  HardwareLoaded(devices: [], connectionStatus: _connStatus),
                );
              }
            }

            // Set reconnect watchdog: if no update in 30s → show reconnecting
            _reconnectTimer = Timer(const Duration(seconds: 30), () {
              _connStatus = HwConnectionStatus.reconnecting;
              if (!isClosed && state is HardwareLoaded) {
                final s = state as HardwareLoaded;
                emit(
                  HardwareLoaded(
                    devices: s.devices,
                    connectionStatus: _connStatus,
                  ),
                );
              }
            });
          },
          onError: (e) {
            _connStatus = HwConnectionStatus.disconnected;
            if (!isClosed) emit(HardwareError(e.toString()));
          },
        );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _reconnectTimer?.cancel();
    return super.close();
  }
}
