import 'package:waffar_ly_app/features/devices/domain/repositories/device_repository.dart';
import '../../devices/models/device_model.dart';
import 'firestore_devices_data_source.dart';

class SimulationDeviceRepositoryImpl implements DeviceRepository {
  SimulationDeviceRepositoryImpl(this._source);

  final FirestoreDevicesDataSource _source;

  @override
  Stream<List<DeviceModel>> watchDevicesForRoom(String roomKey) {
    final ids = kRoomDevices[roomKey] ?? [];
    return _source.watchSimDevices(ids).map((map) {
      return ids
          .map(
            (id) => DeviceModel(
              id: id,
              name: id.replaceAll('_', ' '),
              type: id.toDeviceType(),
              roomId: roomKey,
              simulationData: map[id],
              source: DeviceSourceType.simulation,
            ),
          )
          .toList(growable: false);
    });
  }

  @override
  Future<void> toggleDevice(DeviceModel device, bool newStatus) =>
      _source.updateDeviceState(device.id, newStatus);
}
