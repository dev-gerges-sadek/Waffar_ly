// ============================================================================
// energy_record.dart
// Simple immutable value-object for a single device's energy snapshot.
// Read from Firestore: device_states/{deviceId}
// ============================================================================

import '../../../core/helper/safe_json.dart';

class EnergyRecord {
  const EnergyRecord({
    required this.deviceId,
    required this.watts,
    this.kwh = 0,
    this.aiStatus = '',
    this.recommendation = '',
  });

  final String deviceId;
  final double watts;
  final double kwh;
  final String aiStatus;
  final String recommendation;

  /// Human-readable device name (underscores → spaces).
  String get deviceName => deviceId.replaceAll('_', ' ');

  /// True when the device is consuming power.
  bool get isOn => watts > 0;

  factory EnergyRecord.fromFirestore(
    String deviceId,
    Map<String, dynamic> data,
  ) =>
      EnergyRecord(
        deviceId: deviceId,
        watts: asDouble(data['watts']) ?? 0.0,
        kwh: asDouble(data['kwh']) ?? 0.0,
        aiStatus: asString(data['ai_status']) ?? '',
        recommendation: asString(data['recommendation']) ?? '',
      );
}

/// A single room's aggregated energy consumption.
class RoomEnergy {
  const RoomEnergy({required this.roomName, required this.totalKwh});
  final String roomName;
  final double totalKwh;
}
