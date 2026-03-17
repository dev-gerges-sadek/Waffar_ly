import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffar_ly_app/features/devices/models/device_model.dart';

import '../../../core/constants/app_constants.dart';

sealed class EmergencyState {}

class EmergencyIdle extends EmergencyState {}

class EmergencyRunning extends EmergencyState {}

class EmergencyDone extends EmergencyState {
  EmergencyDone(this.turnedOffCount);
  final int turnedOffCount;
}

class EmergencyError extends EmergencyState {
  EmergencyError(this.message);
  final String message;
}

class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit() : super(EmergencyIdle());

  final _firestore = FirebaseFirestore.instance;

  /// Turns OFF every device in every room that is currently ON
  Future<void> shutoffAll() async {
    emit(EmergencyRunning());

    try {
      // Collect all device IDs from all rooms
      final allIds = kRoomDevices.values.expand((ids) => ids).toList();

      // Fetch current states
      final snapshots = await Future.wait(
        allIds.map((id) =>
            _firestore.collection(AppConstants.colDeviceStates).doc(id).get()),
      );

      // Write batch: set all ON devices to OFF
      final batch = _firestore.batch();
      int count = 0;

      for (final doc in snapshots) {
        if (!doc.exists) continue;
        final status = doc.data()?['status'] as String? ?? 'OFF';
        if (status == 'ON') {
          batch.update(doc.reference, {
            'status': 'OFF',
            'last_updated': FieldValue.serverTimestamp(),
          });
          count++;
        }
      }

      if (count > 0) await batch.commit();

      emit(EmergencyDone(count));

      // Reset to idle after 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed) emit(EmergencyIdle());
    } catch (e) {
      emit(EmergencyError('Failed: ${e.toString()}'));
      await Future.delayed(const Duration(seconds: 2));
      if (!isClosed) emit(EmergencyIdle());
    }
  }
}
