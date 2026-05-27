import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/energy_model.dart';

/// Service for aggregating real energy data from Firebase device_states
class EnergyAggregator {
  EnergyAggregator({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Parse real hardware device data and calculate aggregated metrics
  /// Returns aggregated energy data grouped by device and room
  Future<EnergyAggregationResult> aggregateHardwareData() async {
    try {
      // Read device_states_hw collection (real hardware devices)
      final hwSnapshot = await _firestore.collection('device_states_hw').get();

      final devices = <EnergyRecord>[];
      double totalKwh = 0;
      double totalWatts = 0;

      for (final doc in hwSnapshot.docs) {
        final kwh = (doc['kwh'] as num?)?.toDouble() ?? 0.0;
        final watts = (doc['watts'] as num?)?.toDouble() ?? 0.0;
        final status = doc['status'] as String? ?? 'OFF';
        final lastUpdated = doc['last_updated'] != null
            ? (doc['last_updated'] as dynamic).toDate()
            : DateTime.now();

        totalKwh += kwh;
        totalWatts += watts;

        devices.add(
          EnergyRecord(
            deviceId: doc.id,
            kwh: kwh,
            watts: watts,
            timestamp: lastUpdated,
            status: status,
            isReal: true,
          ),
        );
      }

      // Sort by kWh consumption (top devices)
      devices.sort((a, b) => b.kwh.compareTo(a.kwh));

      // Calculate room breakdown
      final roomBreakdown = <String, double>{};
      for (final device in devices) {
        final room = _extractRoomName(device.deviceId);
        roomBreakdown[room] = (roomBreakdown[room] ?? 0) + device.kwh;
      }

      final roomList = roomBreakdown.entries
          .map((e) => RoomEnergy(roomName: e.key, totalKwh: e.value))
          .toList()
        ..sort((a, b) => b.totalKwh.compareTo(a.totalKwh));

      return EnergyAggregationResult(
        totalKwh: totalKwh,
        totalWatts: totalWatts,
        deviceCount: devices.length,
        allDevices: devices,
        topDevices: devices.take(5).toList(),
        roomBreakdown: roomList,
        timestamp: DateTime.now(),
        source: 'hardware',
      );
    } catch (e) {
      // Return empty result on error
      return EnergyAggregationResult(
        totalKwh: 0,
        totalWatts: 0,
        deviceCount: 0,
        allDevices: [],
        topDevices: [],
        roomBreakdown: [],
        timestamp: DateTime.now(),
        source: 'error',
        error: e.toString(),
      );
    }
  }

  /// Extract room name from device ID (e.g., "Lamp_LR_01" → "Living Room")
  String _extractRoomName(String deviceId) {
    const roomMapping = {
      'LR': 'Living Room',
      'BR': 'Bedroom',
      'K': 'Kitchen',
      'B': 'Bathroom',
      'R2': 'Room 2',
    };

    for (final entry in roomMapping.entries) {
      if (deviceId.contains('_${entry.key}_')) {
        return entry.value;
      }
    }

    return 'Other';
  }

  /// Generate synthetic daily data for demo (when real historical data is unavailable)
  /// In production, this would read from persistent device_history snapshots
  List<DailyCost> generateDailyData({
    required double baseKwh,
    required double rate,
    int days = 7,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final list = <DailyCost>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      // Synthetic trend: slight variation around base kWh
      final variation = (i % 3) * 0.5; // 0-1 kWh variation
      final kwh = baseKwh + variation;
      list.add(DailyCost(
        date: date,
        kwh: kwh,
        cost: kwh * rate,
      ));
    }

    return list;
  }

  /// Generate synthetic weekly data for demo
  List<WeeklyCost> generateWeeklyData({
    required double baseKwh,
    required double rate,
    int weeks = 4,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final list = <WeeklyCost>[];

    for (int i = weeks - 1; i >= 0; i--) {
      final weekStart = today.subtract(Duration(days: i * 7));
      // Synthetic trend: slight increase week by week
      final kwh = baseKwh * 7 * (1 + i * 0.1);
      list.add(WeeklyCost(
        weekStart: weekStart,
        kwh: kwh,
        cost: kwh * rate,
      ));
    }

    return list;
  }

  /// Generate synthetic monthly data for demo
  List<MonthlyCost> generateMonthlyData({
    required double baseKwh,
    required double rate,
    int months = 12,
  }) {
    final now = DateTime.now();
    final list = <MonthlyCost>[];

    for (int i = months - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      // Synthetic trend: seasonal variation
      final kwh = baseKwh * 30 * (1 + (i % 4) * 0.2);
      list.add(MonthlyCost(
        year: date.year,
        month: date.month,
        kwh: kwh,
        cost: kwh * rate,
      ));
    }

    return list;
  }
}

/// Result of energy aggregation
class EnergyAggregationResult {
  EnergyAggregationResult({
    required this.totalKwh,
    required this.totalWatts,
    required this.deviceCount,
    required this.allDevices,
    required this.topDevices,
    required this.roomBreakdown,
    required this.timestamp,
    required this.source,
    this.error,
  });

  final double totalKwh;
  final double totalWatts;
  final int deviceCount;
  final List<EnergyRecord> allDevices;
  final List<EnergyRecord> topDevices;
  final List<RoomEnergy> roomBreakdown;
  final DateTime timestamp;
  final String source; // 'hardware', 'simulator', 'hybrid', 'error'
  final String? error;

  bool get isError => source == 'error';
}
