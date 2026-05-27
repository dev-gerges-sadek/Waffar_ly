sealed class DeviceControlState {}

class DeviceControlInitial extends DeviceControlState {}

class DeviceControlLoading extends DeviceControlState {}

class DeviceControlSuccess extends DeviceControlState {
  DeviceControlSuccess({required this.command});
  final String command;
}

/// Emitted both optimistically (fromFirestore: false) and on Firestore
/// confirmation (fromFirestore: true).
class RelayToggleSuccess extends DeviceControlState {
  RelayToggleSuccess({
    required this.relayState,
    this.fromFirestore = false,
  });
  final bool relayState;

  /// True when this state originated from the Firestore stream
  /// (i.e. the ESP32 or another client actually wrote the value).
  final bool fromFirestore;
}

class DeviceControlError extends DeviceControlState {
  DeviceControlError({required this.message});
  final String message;
}
