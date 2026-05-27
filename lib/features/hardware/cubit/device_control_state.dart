sealed class DeviceControlState {}

class DeviceControlInitial extends DeviceControlState {}

class DeviceControlLoading extends DeviceControlState {}

class DeviceControlSuccess extends DeviceControlState {
  DeviceControlSuccess({required this.command});
  final String command;
}

class DeviceControlError extends DeviceControlState {
  DeviceControlError({required this.message});
  final String message;
}
