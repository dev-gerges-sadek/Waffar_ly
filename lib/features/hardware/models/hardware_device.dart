class HardwareDevice {
  HardwareDevice({
    required this.id,
    required this.voltage,
    required this.current,
    required this.power,
    required this.source,
    required this.status,
    required this.lastUpdate,
  });

  final String id;
  final double voltage;
  final double current;
  final double power;
  final String source;
  final String status;
  final DateTime lastUpdate;

  String get displayName => id.replaceAll('_', ' ');

  bool get isHealthy {
    final now = DateTime.now();
    final diff = now.difference(lastUpdate).inSeconds;
    return diff < 30; // Healthy if updated within 30 seconds
  }

  String get connectionStatus {
    final now = DateTime.now();
    final diff = now.difference(lastUpdate).inSeconds;

    if (diff < 30) return 'Connected';
    if (diff < 120) return 'Reconnecting';
    return 'Disconnected';
  }

  factory HardwareDevice.fromFirestore(String id, Map<String, dynamic> data) {
    return HardwareDevice(
      id: id,
      voltage: (data['voltage'] as num?)?.toDouble() ?? 0.0,
      current: (data['current'] as num?)?.toDouble() ?? 0.0,
      power: (data['power'] as num?)?.toDouble() ?? 0.0,
      source: data['source'] as String? ?? 'Unknown',
      status: data['status'] as String? ?? 'OFF',
      lastUpdate: data['last_update'] != null
          ? (data['last_update'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}
