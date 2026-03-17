class EnergyRecord {
  const EnergyRecord({
    required this.deviceId,
    required this.kwh,
    required this.watts,
    required this.timestamp,
    this.roomId,
  });

  final String deviceId;
  final double kwh;
  final double watts;
  final DateTime timestamp;
  final String? roomId;

  String get deviceName => deviceId.replaceAll('_', ' ');

  factory EnergyRecord.fromFirestore(String id, Map<String, dynamic> data) {
    return EnergyRecord(
      deviceId: id,
      kwh:   (data['kwh']   as num?)?.toDouble() ?? 0,
      watts: (data['watts'] as num?)?.toDouble() ?? 0,
      timestamp: data['last_updated'] != null
          ? (data['last_updated'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}

class RoomEnergy {
  const RoomEnergy({required this.roomName, required this.totalKwh});
  final String roomName;
  final double totalKwh;
}

sealed class EnergyState {}

class EnergyInitial   extends EnergyState {}
class EnergyLoading   extends EnergyState {}

class EnergyLoaded    extends EnergyState {
  EnergyLoaded({
    required this.records,
    required this.totalKwh,
    required this.estimatedCost,
    required this.topDevices,
    required this.roomBreakdown,
    required this.electricityRate,
  });

  final List<EnergyRecord> records;
  final double totalKwh;
  final double estimatedCost;
  final List<EnergyRecord> topDevices;
  final List<RoomEnergy> roomBreakdown;
  final double electricityRate;
}

class EnergyError extends EnergyState {
  EnergyError(this.message);
  final String message;
}
