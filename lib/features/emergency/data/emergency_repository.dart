import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/data/home_scope.dart';

/// Result of an emergency shutoff. [hardwareSent] is false when the command
/// to the physical device could not be written - callers MUST surface that.
class EmergencyOutcome {
  const EmergencyOutcome({
    required this.simulationOff,
    required this.hardwareSent,
  });
  final int simulationOff;
  final bool hardwareSent;
}

/// Handles all Firestore writes for emergency shutoff.
class EmergencyRepository {
  EmergencyRepository(this._scope);

  final HomeScope _scope;
  static const int _maxBatchSize = 500;

  /// Always attempts BOTH targets, even if one fails, so a simulation error
  /// can never prevent the physical device from being cut.
  Future<EmergencyOutcome> shutoffAllDevices() async {
    final hardwareSent = await _shutoffHardware();
    Object? simError;
    var simOff = 0;
    try {
      simOff = await _shutoffSimulation();
    } catch (e) {
      simError = e;
      if (kDebugMode) debugPrint('[Emergency] simulation error: $e');
    }
    if (simError != null && !hardwareSent) throw simError;
    return EmergencyOutcome(simulationOff: simOff, hardwareSent: hardwareSent);
  }

  Future<int> _shutoffSimulation() async {
    final snapshot = await _scope
        .col(AppConstants.colDeviceStates)
        .where('status', isEqualTo: 'ON')
        .get();
    final toOff = snapshot.docs;

    for (var i = 0; i < toOff.length; i += _maxBatchSize) {
      final end = (i + _maxBatchSize).clamp(0, toOff.length);
      final batch = _scope.db.batch();
      for (final doc in toOff.sublist(i, end)) {
        batch.update(doc.reference, {
          'status': 'OFF',
          'last_updated': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    }
    return toOff.length;
  }

  Future<bool> _shutoffHardware() async {
    try {
      await _scope
          .col(AppConstants.colDeviceControl)
          .doc(AppConstants.docRealDevice)
          .set({
            'shutdown': true,
            'relayState': false,
            'timestamp': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('[Emergency] hardware shutoff error: $e');
      return false;
    }
  }
}
