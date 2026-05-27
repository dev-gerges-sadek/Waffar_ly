import '../cubit/hardware_cubit.dart';

sealed class HardwareState {}

class HardwareInitial extends HardwareState {}

class HardwareLoading extends HardwareState {}

class HardwareLoaded extends HardwareState {
  HardwareLoaded({required this.devices, required this.isConnected});

  final List<HardwareDevice> devices;
  final bool isConnected;
}

class HardwareError extends HardwareState {
  HardwareError(this.message);
  final String message;
}
