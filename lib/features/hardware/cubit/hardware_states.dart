import '../models/hardware_device.dart';

sealed class HardwareState {}

class HardwareInitial  extends HardwareState {}
class HardwareLoading  extends HardwareState {}

class HardwareLoaded extends HardwareState {
  HardwareLoaded({
    required this.devices,
    required this.connectionStatus,
  });
  final List<HardwareDevice> devices;
  final HwConnectionStatus   connectionStatus;
}

class HardwareError extends HardwareState {
  HardwareError(this.message);
  final String message;
}
