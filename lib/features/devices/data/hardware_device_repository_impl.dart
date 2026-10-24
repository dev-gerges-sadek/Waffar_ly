import 'package:waffar_ly_app/features/devices/domain/repositories/device_repository.dart';
import '../../../core/constants/app_constants.dart';
import '../../devices/models/device_model.dart';
import '../../devices/data/firestore_devices_data_source.dart';

class HardwareDeviceRepositoryImpl implements DeviceRepository {
  HardwareDeviceRepositoryImpl(this._source);

  final FirestoreDevicesDataSource _source;

  @override
  Stream<List<DeviceModel>> watchDevicesForRoom(String roomKey) {
    final ids = kRoomDevices[roomKey] ?? [];
    return _source.watchHwSensors(ids).map((map) {
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
  Future<void> toggleDevice(DeviceModel device, bool newStatus) =>
      _source.setHardwareStatus(AppConstants.docRealDevice, newStatus);
}
