/// Represents hardware device from Firebase `Control/Real_Device_01` collection
class HardwareDevice {
  const HardwareDevice({
    required this.id,
    required this.voltage,
    required this.current,
    required this.power,
    required this.source,
    this.status,
    this.kwh,
    this.amps,
    this.lastUpdated,
  });

  final String id;
  final double voltage;
  final double current;
  final double power;
  final String source; // 'ESP32_Hardware'
  final String? status;
  final double? kwh;
  final double? amps;
  final DateTime? lastUpdated;

  bool get isConnected => source == 'ESP32_Hardware' && power > 0;

  factory HardwareDevice.fromFirestore(String docId, Map<String, dynamic> d) {
    return HardwareDevice(
      id: docId,
      voltage: (d['voltage'] as num?)?.toDouble() ?? 0,
      current: (d['current'] as num?)?.toDouble() ?? 0,
      power: (d['power'] as num?)?.toDouble() ?? 0,
      source: d['source'] as String? ?? 'ESP32_Hardware',
      status: d['status'] as String?,
      kwh: (d['kwh'] as num?)?.toDouble(),
      amps: (d['amps'] as num?)?.toDouble(),
      lastUpdated: d['last_updated'] != null
          ? (d['last_updated'] as dynamic).toDate()
          : null,
    );
  }

  String get displayName => id.replaceAll('_', ' ');

  /// Safety status based on voltage thresholds
  HardwareSafetyStatus get safetyStatus {
    if (voltage == 0 && current == 0) return HardwareSafetyStatus.idle;
    if (voltage > 250 || current > 15) return HardwareSafetyStatus.critical;
    if (voltage > 240 || current > 10) return HardwareSafetyStatus.warning;
    return HardwareSafetyStatus.normal;
  }
}

enum HardwareSafetyStatus { idle, normal, warning, critical }

enum HwConnectionStatus { connected, disconnected, reconnecting }
