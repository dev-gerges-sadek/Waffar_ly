import 'package:firebase_database/firebase_database.dart';
import '../../../core/constants/app_constants.dart';
import '../../devices/models/device_model.dart';
import '../../devices/data/devices_rtdb_source.dart';
import '../../domain/repositories/device_repository.dart';

class HardwareDeviceRepositoryImpl implements DeviceRepository {
  HardwareDeviceRepositoryImpl()
    : _rtdbSource = DevicesRtdbSource(),
      _db = FirebaseDatabase.instanceFor(
        app: FirebaseDatabase.instance.app,
        databaseURL: AppConstants.rtdbUrl,
      );

  final DevicesRtdbSource _rtdbSource;
  final FirebaseDatabase _db;

  @override
  Stream<List<DeviceModel>> watchDevicesForRoom(String roomKey) {
    final ids = kRoomDevices[roomKey] ?? [];
    return _rtdbSource.watchHwSensors(ids).map((map) {
      return ids
          .map((id) {
            return DeviceModel(
              id: id,
              name: id.replaceAll('_', ' '),
              type: id.toDeviceType(),
              roomId: roomKey,
              hardwareSensor: map[id],
              hardwareData: map[id]?.data,
              source: map[id] != null
                  ? DeviceSourceType.hardware
                  : DeviceSourceType.simulation,
            );
          })
          .toList(growable: false);
    });
  }

  @override
  Future<void> toggleDevice(DeviceModel device, bool newStatus) async {
    await _db.ref('${AppConstants.rtdbHwDevicesPath}/${device.id}').update({
      'status': newStatus ? 'ON' : 'OFF',
      'last_updated': ServerValue.timestamp,
    });
  }
}
