import '../models/device_model.dart';

sealed class DevicesState {}

class DevicesInitial extends DevicesState {}

class DevicesLoading extends DevicesState {}

/// Fatal stream failure (nothing to show). The UI renders a localised view;
/// the raw exception is never exposed.
class DevicesError extends DevicesState {}

class DevicesLoaded extends DevicesState {
  DevicesLoaded(
    this.devices, {
    this.hwOnlineCount = 0,
    this.toggleErrorSeq = 0,
  });
  final List<DeviceModel> devices;
  final int hwOnlineCount; // live count of online hardware sensors

  /// Incremented every time a toggle fails (after the optimistic update was
  /// reverted). Listeners compare it to show a one-off snackbar WITHOUT the
  /// device list ever leaving the Loaded state.
  final int toggleErrorSeq;
}

// Kept for backward compat with any existing BlocBuilder
class DeviceUpdating extends DevicesState {
  DeviceUpdating(this.devices);
  final List<DeviceModel> devices;
}
