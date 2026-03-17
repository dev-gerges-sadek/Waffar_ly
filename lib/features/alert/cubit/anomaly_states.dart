class AnomalyAlert {
  const AnomalyAlert({
    required this.deviceId,
    required this.currentKwh,
    required this.avgKwh,
    required this.zScore,
    required this.severity,
    required this.detectedAt,
  });

  final String deviceId;
  final double currentKwh;
  final double avgKwh;
  final double zScore;
  final AnomalySeverity severity;
  final DateTime detectedAt;

  String get deviceName => deviceId.replaceAll('_', ' ');

  String get message {
    final pct = avgKwh > 0
        ? ((currentKwh - avgKwh) / avgKwh * 100).toStringAsFixed(0)
        : '∞';
    return '$deviceName is consuming $pct% more than usual '
        '(${currentKwh.toStringAsFixed(2)} vs avg ${avgKwh.toStringAsFixed(2)} kWh)';
  }
}

enum AnomalySeverity { low, medium, high }

sealed class AnomalyState {}

class AnomalyInitial extends AnomalyState {}
class AnomalyLoading extends AnomalyState {}

class AnomalyLoaded extends AnomalyState {
  AnomalyLoaded({required this.alerts, required this.allClear});
  final List<AnomalyAlert> alerts;
  final bool allClear;
}

class AnomalyError extends AnomalyState {
  AnomalyError(this.message);
  final String message;
}
