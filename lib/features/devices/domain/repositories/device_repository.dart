import '../../models/device_model.dart';

abstract class DeviceRepository {
  Stream<List<DeviceModel>> watchDevicesForRoom(String roomKey);
  Future<void> toggleDevice(DeviceModel device, bool newStatus);
}
