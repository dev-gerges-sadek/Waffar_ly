class AnomalyAlert {
  final String deviceId;
  final double currentKwh;
  final double watts;
  final double probAnomaly;
  final String aiDecision;
  final String recommendation;
  final DateTime detectedAt;

  const AnomalyAlert({
    required this.deviceId,
    required this.currentKwh,
    required this.watts,
    required this.probAnomaly,
    required this.aiDecision,
    required this.recommendation,
    required this.detectedAt,
  });

  String get deviceName => deviceId.toUpperCase().replaceAll('_', ' ');
}

sealed class AnomalyState {}

class AnomalyInitial extends AnomalyState {}
class AnomalyLoading extends AnomalyState {}

class AnomalyLoaded extends AnomalyState {
  final List<AnomalyAlert> alerts;
  final bool allClear;

  AnomalyLoaded({required this.alerts, required this.allClear});
}

class AnomalyError extends AnomalyState {
  final String message;
  AnomalyError(this.message);
}