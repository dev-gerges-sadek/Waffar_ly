import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';

/// Handles all Firestore writes for emergency shutoff.
/// Keeps EmergencyCubit free of direct Firebase references.
class EmergencyRepository {
  EmergencyRepository() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const int _maxBatchSize = 500;

  /// Returns total count of devices turned off.
  Future<int> shutoffAllDevices() async {
    int count = 0;
    count += await _shutoffSimulation();
    count += await _shutoffHardware();
    return count;
  }

  Future<int> _shutoffSimulation() async {
    final snapshot = await _firestore
        .collection(AppConstants.colDeviceStates)
        .get();
    final toOff = snapshot.docs
        .where((d) => (d.data()['status'] as String?) == 'ON')
        .toList();

    for (var i = 0; i < toOff.length; i += _maxBatchSize) {
      final chunk = toOff.sublist(
        i,
        (i + _maxBatchSize).clamp(0, toOff.length),
      );
      final batch = _firestore.batch();
      for (final doc in chunk) {
        batch.update(doc.reference, {
          'status': 'OFF',
          'last_updated': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    }
    return toOff.length;
  }

  Future<int> _shutoffHardware() async {
    try {
      // Send shutoff command to Real_Device_01 via Control collection.
      await _firestore
          .collection('Control')
          .doc(AppConstants.docRealDevice)
          .update({
            'shutdown': true,
            'timestamp': FieldValue.serverTimestamp(),
          });
      return 1; // Counted as 1 command sent to hardware
    } catch (e) {
      debugPrint("[Emergency] Hardware shutoff error: $e");
      return 0; // Hardware failure is non-critical
    }
  }
}
