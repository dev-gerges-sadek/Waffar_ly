import '../../../../core/helper/safe_json.dart';

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
      aiDecision: asString(data['ai_decision']) ?? 'UNKNOWN',
      watts: asDouble(data['watts']) ?? 0.0,
      kwhConsumed: asDouble(data['kwh_consumed']) ?? 0.0,
      isAnomaly: asBool(data['is_anomaly']) ?? false,
      probAnomalyPct: asDouble(data['prob_anomaly_pct']) ?? 0.0,
      recommendation: asString(data['recommendation']) ?? 'No recommendation available',
      lastUpdate: asString(data['last_update']) ?? '',
      voltage: asDouble(data['voltage']) ?? 0.0,
    );
  }
}