import '../models/device_model.dart';

sealed class DevicesState {}

class DevicesInitial  extends DevicesState {}
class DevicesLoading  extends DevicesState {}

class DevicesError extends DevicesState {
  DevicesError(this.message);
  final String message;
}

class DevicesLoaded extends DevicesState {
  DevicesLoaded(this.devices, {this.hwOnlineCount = 0});
  final List<DeviceModel> devices;
  final int hwOnlineCount;       // ← live count of online hardware sensors
}

// Kept for backward compat with any existing BlocBuilder
class DeviceUpdating extends DevicesState {
  DeviceUpdating(this.devices);
  final List<DeviceModel> devices;
}
