import 'package:rxdart/rxdart.dart';
import '../../devices/models/device_model.dart';
import '../../devices/data/devices_rtdb_source.dart';
import '../../domain/repositories/device_repository.dart';
import 'hardware_device_repository_impl.dart';
import 'simulation_device_repository_impl.dart';

class CombinedDeviceRepository implements DeviceRepository {
  CombinedDeviceRepository({
    required this.simulationRepository,
    required this.hardwareRepository,
  });

  final SimulationDeviceRepositoryImpl simulationRepository;
  final HardwareDeviceRepositoryImpl hardwareRepository;

  @override
  Stream<List<DeviceModel>> watchDevicesForRoom(String roomKey) {
    final simStream = simulationRepository.watchDevicesForRoom(roomKey);
    final hwStream = hardwareRepository.watchDevicesForRoom(roomKey);

    return Rx.combineLatest2<List<DeviceModel>, List<DeviceModel>, List<DeviceModel>>(
      simStream,
      hwStream,
      (simDevices, hwDevices) {
        final map = {for (final device in simDevices) device.id: device};

        for (final hwDevice in hwDevices) {
          final existing = map[hwDevice.id];
          if (existing == null) {
            map[hwDevice.id] = hwDevice;
            continue;
          }
          map[hwDevice.id] = existing.copyWith(
            hardwareData: hwDevice.hardwareData,
            hardwareSensor: hwDevice.hardwareSensor,
            source: DeviceSourceType.hardware,
          );
        }

        final ids = kRoomDevices[roomKey] ?? [];
        return ids.map((id) => map[id] ??
            DeviceModel(
              id: id,
              name: id.replaceAll('_', ' '),
              type: id.toDeviceType(),
              roomId: roomKey,
            )).toList(growable: false);
      },
    );
  }

  @override
  Future<void> toggleDevice(DeviceModel device, bool newStatus) {
    final isHardware = device.source == DeviceSourceType.hardware ||
        device.hardwareSensor != null;
    if (isHardware) {
      return hardwareRepository.toggleDevice(device, newStatus);
    }
    return simulationRepository.toggleDevice(device, newStatus);
  }
}
