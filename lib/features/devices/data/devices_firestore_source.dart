import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../models/device_model.dart';

class DevicesFirestoreSource {
  DevicesFirestoreSource() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<Map<String, DeviceData>> watchSimDevices(List<String> deviceIds) {
    return _firestore
        .collection(AppConstants.colDeviceStates)
        .snapshots()
        .map(
          (snapshot) => Map.fromEntries(
            snapshot.docs
                .where((doc) => deviceIds.contains(doc.id))
                .map(
                  (doc) =>
                      MapEntry(doc.id, DeviceData.fromFirestore(doc.data())),
                ),
          ),
        );
  }

  Future<Map<String, DeviceData>> readSimDevicesOnce(
    List<String> deviceIds,
  ) async {
    final snapshot = await _firestore
        .collection(AppConstants.colDeviceStates)
        .get();
    return Map.fromEntries(
      snapshot.docs
          .where((doc) => deviceIds.contains(doc.id))
          .map((doc) => MapEntry(doc.id, DeviceData.fromFirestore(doc.data()))),
    );
  }

  Future<void> updateDeviceState(String deviceId, bool isOn) async {
    await _firestore.collection(AppConstants.colDeviceStates).doc(deviceId).set(
      {
        'status': isOn ? 'ON' : 'OFF',
        'last_updated': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
