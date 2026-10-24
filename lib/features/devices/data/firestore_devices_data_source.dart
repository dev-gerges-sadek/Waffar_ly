import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/data/home_scope.dart';
import '../models/device_model.dart';

/// Single Firestore gateway for device + hardware sensor data.
///
/// Reads only the documents it needs (`whereIn` on document id, chunked to
/// Firestore's limit of 30) instead of streaming the whole collection.
class FirestoreDevicesDataSource {
  FirestoreDevicesDataSource(this._scope);

  final HomeScope _scope;

  static const int _whereInLimit = 30;

  CollectionReference<Map<String, dynamic>> get _states =>
      _scope.col(AppConstants.colDeviceStates);

  Query<Map<String, dynamic>> _byIds(List<String> ids) =>
      _states.where(FieldPath.documentId, whereIn: ids);

  List<String> _clean(List<String> ids) =>
      ids.take(_whereInLimit).toList(growable: false);

  // ── Simulation devices ────────────────────────────────────────────────────

  Stream<Map<String, DeviceData>> watchSimDevices(List<String> deviceIds) {
    final ids = _clean(deviceIds);
    if (ids.isEmpty) return Stream.value(const {});
    return _byIds(ids).snapshots().map(
      (snap) => {
        for (final doc in snap.docs)
          doc.id: DeviceData.fromFirestore(doc.data()),
      },
    );
  }

  Future<void> updateDeviceState(String deviceId, bool isOn) {
    return _states.doc(deviceId).set({
      'status': isOn ? 'ON' : 'OFF',
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Hardware sensors ──────────────────────────────────────────────────────

  Stream<Map<String, HardwareSensor>> watchHwSensors(List<String> deviceIds) {
    final ids = _clean(deviceIds);
    if (ids.isEmpty) return Stream.value(const {});
    return _byIds(ids).snapshots().map(
      (snap) => {
        for (final doc in snap.docs)
          doc.id: HardwareSensor.fromFirestore(doc.id, doc.data()),
      },
    );
  }

  /// Relay command for the physical device (picked up by the ESP32).
  Future<void> setHardwareStatus(String deviceId, bool isOn) {
    return _scope.col(AppConstants.colDeviceControl).doc(deviceId).set({
      'status': isOn ? 'ON' : 'OFF',
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
