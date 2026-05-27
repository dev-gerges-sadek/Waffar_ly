
sealed class EmergencyState {}

class EmergencyIdle extends EmergencyState {}

class EmergencyRunning extends EmergencyState {}

class EmergencyDone extends EmergencyState {
  EmergencyDone(this.turnedOffCount);
  final int turnedOffCount;
}

class EmergencyError extends EmergencyState {
  EmergencyError(this.message);
  final String message;
}

