import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../models/device_model.dart';

/// Firestore streams for device + hardware sensor data.
/// Replaces old DevicesRtdbSource — now Firestore-only.
class FirestoreDevicesDataSource {
  FirestoreDevicesDataSource() : _db = FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  // ── Simulation devices ────────────────────────────────────────────────────

  /// Stream of DeviceData for a single simulation device.
  Stream<DeviceData?> watchSimDevice(String deviceId) => _db
      .collection(AppConstants.colDeviceStates)
      .doc(deviceId)
      .snapshots()
      .map((snap) => _parseData(snap));

  /// Stream of all simulation devices matching [deviceIds].
  Stream<Map<String, DeviceData>> watchSimDevices(List<String> deviceIds) => _db
      .collection(AppConstants.colDeviceStates)
      .snapshots()
      .map((snap) => _parseDeviceMap(snap, deviceIds));

  // ── Hardware devices ──────────────────────────────────────────────────────

  /// Stream of HardwareSensor for a single hardware device.
  Stream<HardwareSensor?> watchHwSensor(String deviceId) => _db
      .collection(AppConstants.colDeviceStates)
      .doc(deviceId)
      .snapshots()
      .map((snap) => _parseSensor(snap, deviceId));

  /// Stream of all hardware sensors matching [deviceIds].
  Stream<Map<String, HardwareSensor>> watchHwSensors(List<String> deviceIds) =>
      _db
          .collection(AppConstants.colDeviceStates)
          .snapshots()
          .map((snap) => _parseSensorMap(snap, deviceIds));

  // ── Parsers ──────────────────────────────────────────────────────────────

  DeviceData? _parseData(DocumentSnapshot snap) {
    if (!snap.exists || snap.data() == null) return null;
    try {
      return DeviceData.fromMap(Map<String, dynamic>.from(snap.data() as Map));
    } catch (_) {
      return null;
    }
  }

  HardwareSensor? _parseSensor(DocumentSnapshot snap, String id) {
    if (!snap.exists || snap.data() == null) return null;
    try {
      return HardwareSensor.fromFirestore(
        id,
        Map<String, dynamic>.from(snap.data() as Map),
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, DeviceData> _parseDeviceMap(
    QuerySnapshot snap,
    List<String> filter,
  ) {
    try {
      final result = <String, DeviceData>{};
      for (final doc in snap.docs) {
        if (filter.contains(doc.id)) {
          final data = DeviceData.fromMap(
            Map<String, dynamic>.from(doc.data() as Map),
          );
          result[doc.id] = data;
        }
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  Map<String, HardwareSensor> _parseSensorMap(
    QuerySnapshot snap,
    List<String> filter,
  ) {
    try {
      final result = <String, HardwareSensor>{};
      for (final doc in snap.docs) {
        if (filter.contains(doc.id)) {
          final sensor = HardwareSensor.fromFirestore(
            doc.id,
            Map<String, dynamic>.from(doc.data() as Map),
          );
          result[doc.id] = sensor;
        }
      }
      return result;
    } catch (_) {
      return {};
    }
  }
}
