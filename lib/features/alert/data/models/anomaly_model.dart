class AnomalyResult {
  final String id; // simulator or hardware
  final String aiDecision;
  final double watts;
  final double kwhConsumed;
  final bool isAnomaly;
  final double probAnomalyPct;
  final String recommendation;
  final String lastUpdate;
  final double voltage;

  AnomalyResult({
    required this.id,
    required this.aiDecision,
    required this.watts,
    required this.kwhConsumed,
    required this.isAnomaly,
    required this.probAnomalyPct,
    required this.recommendation,
    required this.lastUpdate,
    required this.voltage,
  });

  factory AnomalyResult.fromFirestore(String id, Map<String, dynamic> data) {
    return AnomalyResult(
      id: id,
      aiDecision: data['ai_decision'] ?? 'UNKNOWN',
      watts: (data['watts'] as num?)?.toDouble() ?? 0.0,
      kwhConsumed: (data['kwh_consumed'] as num?)?.toDouble() ?? 0.0,
      isAnomaly: data['is_anomaly'] ?? false,
      probAnomalyPct: (data['prob_anomaly_pct'] as num?)?.toDouble() ?? 0.0,
      recommendation: data['recommendation'] ?? 'No recommendation available',
      lastUpdate: data['last_update'] ?? '',
      voltage: (data['voltage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}