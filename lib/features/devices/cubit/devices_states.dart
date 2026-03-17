import '../models/device_model.dart';

sealed class DevicesState {}

class DevicesInitial extends DevicesState {}

class DevicesLoading extends DevicesState {}

class DevicesLoaded extends DevicesState {
  DevicesLoaded(this.devices);
  final List<DeviceModel> devices;
}

class DevicesError extends DevicesState {
  DevicesError(this.message);
  final String message;
}

class DeviceUpdating extends DevicesState {
  DeviceUpdating(this.devices);
  final List<DeviceModel> devices;
}
