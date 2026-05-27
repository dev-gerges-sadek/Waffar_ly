import 'package:rxdart/rxdart.dart';
import 'package:waffar_ly_app/features/devices/domain/repositories/device_repository.dart';
import '../../devices/models/device_model.dart';
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
    // startWith([]) ensures combineLatest2 fires immediately even when
    // hardware RTDB has no data yet — prevents infinite loading spinner.
    final simStream = simulationRepository
        .watchDevicesForRoom(roomKey)
        .startWith([]);
    final hwStream = hardwareRepository
        .watchDevicesForRoom(roomKey)
        .startWith([]);

    return Rx.combineLatest2<
      List<DeviceModel>,
      List<DeviceModel>,
      List<DeviceModel>
    >(simStream, hwStream, (simDevices, hwDevices) {
      final map = {for (final d in simDevices) d.id: d};

      for (final hwDevice in hwDevices) {
        final existing = map[hwDevice.id];
        if (existing == null) {
          map[hwDevice.id] = hwDevice;
        } else {
          map[hwDevice.id] = existing.copyWith(
            hardwareData: hwDevice.hardwareData,
            hardwareSensor: hwDevice.hardwareSensor,
            source: DeviceSourceType.hardware,
          );
        }
      }

      final ids = kRoomDevices[roomKey] ?? [];
      return ids
          .map(
            (id) =>
                map[id] ??
                DeviceModel(
                  id: id,
                  name: id.replaceAll('_', ' '),
                  type: id.toDeviceType(),
                  roomId: roomKey,
                ),
          )
          .toList(growable: false);
    });
  }

  @override
  Future<void> toggleDevice(DeviceModel device, bool newStatus) {
    // If source is explicitly set, trust it (allows manual override in cubit)
    // Otherwise, prefer hardware if available, fall back to simulation
    final isHardware =
        device.source == DeviceSourceType.hardware ||
        (device.source != DeviceSourceType.simulation &&
            device.hardwareSensor != null);
    return isHardware
        ? hardwareRepository.toggleDevice(device, newStatus)
        : simulationRepository.toggleDevice(device, newStatus);
  }
}
