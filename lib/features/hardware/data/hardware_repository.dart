import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/data/home_scope.dart';
import '../models/hardware_device.dart';

/// All Firestore access for the physical (ESP32) device lives here, so cubits
/// and widgets never touch Firebase directly.
class HardwareRepository {
  HardwareRepository(this._scope);

  final HomeScope _scope;

  DocumentReference<Map<String, dynamic>> get _control => _scope
      .col(AppConstants.colDeviceControl)
      .doc(AppConstants.docRealDevice);

  /// Live telemetry of the real device (null when the document is missing).
  Stream<HardwareDevice?> watchDevice() => _scope
      .col(AppConstants.colHardwareDevices)
      .doc(AppConstants.docRealDevice)
      .snapshots()
      .map((snap) {
        final data = snap.data();
        if (!snap.exists || data == null) return null;
        return HardwareDevice.fromFirestore(snap.id, data);
      });

  /// Relay state as last written to Firestore (null while unknown).
  Stream<bool?> watchRelayState() => _control.snapshots().map((snap) {
    final v = snap.data()?['relayState'];
    return v is bool ? v : null;
  });

  Future<void> setRelay(bool on) => _control.set({
    'relayState': on,
    'last_updated': FieldValue.serverTimestamp(),
    'device': AppConstants.docRealDevice,
  }, SetOptions(merge: true));

  /// AI analysis document for [deviceId].
  Stream<Map<String, dynamic>?> watchAiResult(String deviceId) => _scope
      .col(AppConstants.colAiResults)
      .doc(deviceId)
      .snapshots()
      .map((snap) => snap.exists ? snap.data() : null);
}
