// ignore: dangling_library_doc_comments
/// Device models — Firestore only. RTDB removed.
///
/// Hardware section is view-only (disabled in UI).
/// Simulation section allows on/off toggle via Firestore device_states.

enum DeviceType { lamp, fan, ac, tv, washer, fridge, heater, speaker }

// ── Sensor status ─────────────────────────────────────────────────────────────

enum SensorStatus { online, offline, warning, unknown }

extension SensorStatusX on SensorStatus {
  bool get isOnline => this == SensorStatus.online;
  bool get isWarning => this == SensorStatus.warning;
}

// ── Device data ───────────────────────────────────────────────────────────────

class DeviceData {
  DeviceData({
    required this.status,
    this.watts,
    this.kwh,
    this.volts,
    this.amps,
    this.lastUpdated,
  });

  final String status;
  final double? watts;
  final double? kwh;
  final double? volts;
  final double? amps;
  final DateTime? lastUpdated;

  bool get isOn => status == 'ON';

  factory DeviceData.fromFirestore(Map<String, dynamic> d) => DeviceData(
    status: d['status'] as String? ?? 'OFF',
    watts: (d['watts'] as num?)?.toDouble(),
    kwh: (d['kwh'] as num?)?.toDouble(),
    volts: (d['volts'] as num?)?.toDouble(),
    amps: (d['amps'] as num?)?.toDouble(),
    lastUpdated: _parseDate(d['last_updated']),
  );

  // Alias kept for compatibility
  factory DeviceData.fromMap(Map<String, dynamic> d) =>
      DeviceData.fromFirestore(d);

  DeviceData copyWith({
    String? status,
    double? watts,
    double? kwh,
    double? volts,
    double? amps,
    DateTime? lastUpdated,
  }) => DeviceData(
    status: status ?? this.status,
    watts: watts ?? this.watts,
    kwh: kwh ?? this.kwh,
    volts: volts ?? this.volts,
    amps: amps ?? this.amps,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    try {
      return (raw as dynamic).toDate() as DateTime;
    } catch (_) {}
    return null;
  }
}

// ── Hardware sensor (view-only, no RTDB) ──────────────────────────────────────

/// Represents the hardware device status from Firestore ai_results/Real_Device_01.
/// This is display-only — no user interaction allowed.
class HardwareSensor {
  const HardwareSensor({
    required this.deviceId,
    required this.status,
    required this.data,
    required this.updatedAt,
    this.isViewOnly = true, // Always true — hardware is read-only
  });

  final String deviceId;
  final SensorStatus status;
  final DeviceData data;
  final DateTime updatedAt;
  final bool isViewOnly;

  bool get isOnline => status == SensorStatus.online;
  bool get isWarning => status == SensorStatus.warning;

  /// Build from Firestore ai_results/Real_Device_01 data.
  factory HardwareSensor.fromFirestore(String id, Map<String, dynamic> raw) {
    final data = DeviceData.fromFirestore(raw);
    final updatedAt = data.lastUpdated ?? DateTime.now();

    final rawStatus = (raw['status'] as String?)?.toLowerCase() ?? '';
    final SensorStatus sensorStatus;
    if (rawStatus == 'on') {
      sensorStatus = SensorStatus.online;
    } else if (rawStatus == 'off') {
      sensorStatus = SensorStatus.offline;
    } else {
      sensorStatus = SensorStatus.unknown;
    }

    return HardwareSensor(
      deviceId: id,
      status: sensorStatus,
      data: data,
      updatedAt: updatedAt,
      isViewOnly: true,
    );
  }
}

// ── Source type ───────────────────────────────────────────────────────────────

enum DeviceSourceType { simulation, hardware }

// ── DeviceModel ───────────────────────────────────────────────────────────────

class DeviceModel {
  DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.roomId,
    this.simulationData,
    this.hardwareData, // Always null in current version
    this.hardwareSensor, // Always null in current version
    this.source = DeviceSourceType.simulation,
  });

  final String id;
  final String name;
  final DeviceType type;
  final String roomId;

  /// Data from Firestore device_states/{id} (simulation, toggleable)
  final DeviceData? simulationData;

  /// Data from Firestore ai_results/Real_Device_01 (hardware, view-only)
  /// Currently null — hardware panel is disabled/greyed out.
  final DeviceData? hardwareData;
  final HardwareSensor? hardwareSensor;

  final DeviceSourceType source;

  /// On state is derived only from simulation (hardware is offline/disabled)
  bool get isOn => simulationData?.isOn ?? false;

  DeviceModel copyWith({
    DeviceData? simulationData,
    DeviceData? hardwareData,
    HardwareSensor? hardwareSensor,
    DeviceSourceType? source,
  }) => DeviceModel(
    id: id,
    name: name,
    type: type,
    roomId: roomId,
    simulationData: simulationData ?? this.simulationData,
    hardwareData: hardwareData ?? this.hardwareData,
    hardwareSensor: hardwareSensor ?? this.hardwareSensor,
    source: source ?? this.source,
  );
}

// ── Extensions & constants ────────────────────────────────────────────────────

extension DeviceTypeX on String {
  DeviceType toDeviceType() {
    final l = toLowerCase();
    if (l.contains('lamp')) return DeviceType.lamp;
    if (l.contains('fan')) return DeviceType.fan;
    if (l.contains('ac')) return DeviceType.ac;
    if (l.contains('tv')) return DeviceType.tv;
    if (l.contains('wash')) return DeviceType.washer;
    if (l.contains('fridge')) return DeviceType.fridge;
    if (l.contains('heater')) return DeviceType.heater;
    if (l.contains('speaker') || l.contains('sound')) return DeviceType.speaker;
    return DeviceType.lamp;
  }
}

const Map<String, String> kRoomSuffix = {
  'LR': 'Living Room',
  'BR': 'Bedroom',
  'K': 'Kitchen',
  'B': 'Bathroom',
  'R2': 'Room 2',
};

const Map<String, List<String>> kRoomDevices = {
  'living_room': ['Lamp_LR_01', 'Fan_LR_01', 'TV_LR_01'],
  'bedroom': ['Lamp_BR_01', 'AC_BR_01'],
  'kitchen': ['Lamp_K_01', 'Fridge_K_01'],
  'bathroom': ['Lamp_B_01', 'HEATER_B_01'],
  'room2': ['Lamp_R2_01', 'AC_R2_01'],
};

const Map<String, String> kRoomIdToKey = {
  '1': 'living_room',
  '2': 'room2',
  '3': 'kitchen',
  '4': 'bedroom',
  '5': 'bathroom',
};
