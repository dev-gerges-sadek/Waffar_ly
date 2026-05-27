import 'package:waffar_ly_app/features/devices/data/devices_firestore_source.dart';
import 'package:waffar_ly_app/features/devices/domain/repositories/device_repository.dart';
import '../../devices/models/device_model.dart';

class SimulationDeviceRepositoryImpl implements DeviceRepository {
  SimulationDeviceRepositoryImpl()
    : _firestoreSource = DevicesFirestoreSource();

  final DevicesFirestoreSource _firestoreSource;

  @override
  Stream<List<DeviceModel>> watchDevicesForRoom(String roomKey) {
    final ids = kRoomDevices[roomKey] ?? [];
    return _firestoreSource.watchSimDevices(ids).map((map) {
      return ids
          .map((id) {
            return DeviceModel(
              id: id,
              name: id.replaceAll('_', ' '),
              type: id.toDeviceType(),
              roomId: roomKey,
              simulationData: map[id],
              source: DeviceSourceType.simulation,
            );
          })
          .toList(growable: false);
    });
  }

  @override
  Future<void> toggleDevice(DeviceModel device, bool newStatus) async {
    await _firestoreSource.updateDeviceState(device.id, newStatus);
  }
}
