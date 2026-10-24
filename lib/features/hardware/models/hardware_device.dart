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
      voltage: _num(d['voltage']) ?? 0,
      current: _num(d['current']) ?? 0,
      power: _num(d['power']) ?? 0,
      source: d['source'] is String ? d['source'] as String : 'ESP32_Hardware',
      status: d['status'] is String ? d['status'] as String : null,
      kwh: _num(d['kwh']),
      amps: _num(d['amps']),
      lastUpdated: _date(d['last_updated']),
    );
  }

  static double? _num(Object? v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static DateTime? _date(Object? v) {
    if (v is DateTime) return v;
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    try {
      return (v as dynamic)?.toDate() as DateTime?;
    } catch (_) {
      return null;
    }
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
