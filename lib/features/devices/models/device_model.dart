enum DeviceType { lamp, fan, ac, tv, washer, fridge, heater, speaker }

class DeviceModel {
  DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.roomId,
    this.simulationData,
    this.hardwareData,
  });

  final String id;          // e.g. "Lamp_LR_01"
  final String name;        // e.g. "Lamp LR 01"
  final DeviceType type;
  final String roomId;      // e.g. "living_room"

  final DeviceData? simulationData;
  final DeviceData? hardwareData;

  DeviceModel copyWith({
    DeviceData? simulationData,
    DeviceData? hardwareData,
  }) =>
      DeviceModel(
        id: id,
        name: name,
        type: type,
        roomId: roomId,
        simulationData: simulationData ?? this.simulationData,
        hardwareData: hardwareData ?? this.hardwareData,
      );
}

class DeviceData {
  DeviceData({
    required this.status,
    this.watts,
    this.kwh,
    this.volts,
    this.amps,
    this.lastUpdated,
  });

  final String status;       // "ON" or "OFF"
  final double? watts;
  final double? kwh;
  final double? volts;
  final double? amps;
  final DateTime? lastUpdated;

  bool get isOn => status == 'ON';

  factory DeviceData.fromFirestore(Map<String, dynamic> data) {
    return DeviceData(
      status: data['status'] as String? ?? 'OFF',
      watts: (data['watts'] as num?)?.toDouble(),
      kwh: (data['kwh'] as num?)?.toDouble(),
      volts: (data['volts'] as num?)?.toDouble(),
      amps: (data['amps'] as num?)?.toDouble(),
      lastUpdated: data['last_updated'] != null
          ? (data['last_updated'] as dynamic).toDate()
          : null,
    );
  }
}

// Maps Firestore document IDs to DeviceType
extension DeviceTypeX on String {
  DeviceType toDeviceType() {
    final lower = toLowerCase();
    if (lower.contains('lamp')) return DeviceType.lamp;
    if (lower.contains('fan')) return DeviceType.fan;
    if (lower.contains('ac')) return DeviceType.ac;
    if (lower.contains('tv')) return DeviceType.tv;
    if (lower.contains('wash')) return DeviceType.washer;
    if (lower.contains('fridge')) return DeviceType.fridge;
    if (lower.contains('heater')) return DeviceType.heater;
    if (lower.contains('speaker') || lower.contains('sound')) {
      return DeviceType.speaker;
    }
    return DeviceType.lamp;
  }
}

// Room suffix → room name mapping
const Map<String, String> kRoomSuffix = {
  'LR': 'Living Room',
  'BR': 'Bedroom',
  'K': 'Kitchen',
  'B': 'Bathroom',
  'R2': 'Room 2',
};

// Pre-defined devices per room (matches Firestore document IDs from screenshot)
const Map<String, List<String>> kRoomDevices = {
  'living_room': [
    'Lamp_LR_01', 'Fan_LR_01', 'TV_LR_01',
  ],
  'bedroom': [
    'Lamp_BR_01', 'AC_BR_01',
  ],
  'kitchen': [
    'Lamp_K_01', 'Fridge_K_01',
  ],
  'bathroom': [
    'Lamp_B_01', 'HEATER_B_01',
  ],
  'room2': [
    'Lamp_R2_01', 'AC_R2_01',
  ],
};

// Map SmartRoom.id → room key
const Map<String, String> kRoomIdToKey = {
  '1': 'living_room',
  '2': 'dining_room',
  '3': 'kitchen',
  '4': 'bedroom',
  '5': 'bathroom',
};
