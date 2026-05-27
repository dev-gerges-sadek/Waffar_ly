import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/hardware_device.dart';
import 'hardware_states.dart';

class HardwareCubit extends Cubit<HardwareState> {
  HardwareCubit() : super(HardwareInitial());

  final _firestore = FirebaseFirestore.instance;
  StreamSubscription? _sub;

  void startMonitoring() {
    emit(HardwareLoading());

    _sub?.cancel();
    _sub = _firestore
        .collection('Devices')
        .snapshots()
        .listen(
      (snapshot) {
        final devices = <HardwareDevice>[];

        for (final doc in snapshot.docs) {
          try {
            final device =
                HardwareDevice.fromFirestore(doc.id, doc.data());
            // Only include if it looks like real hardware (has source field)
            if (doc.data().containsKey('source')) {
              devices.add(device);
            }
          } catch (_) {
            // Skip malformed documents
          }
        }

        if (!isClosed) {
          final isConnected = devices.isNotEmpty &&
              devices.any((d) => d.connectionStatus == 'Connected');
          emit(HardwareLoaded(
            devices: devices,
            isConnected: isConnected,
          ));
        }
      },
      onError: (e) {
        if (!isClosed) {
          emit(HardwareError(e.toString()));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
