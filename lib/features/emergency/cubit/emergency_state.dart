sealed class EmergencyState {}

class EmergencyIdle extends EmergencyState {}

class EmergencyRunning extends EmergencyState {}

class EmergencyDone extends EmergencyState {
  EmergencyDone(this.turnedOffCount, {required this.hardwareSent});
  final int turnedOffCount;

  /// False -> the command to the physical device failed (partial success).
  final bool hardwareSent;
}

/// Total failure. The UI shows a localised message (no raw exception text).
class EmergencyError extends EmergencyState {}
