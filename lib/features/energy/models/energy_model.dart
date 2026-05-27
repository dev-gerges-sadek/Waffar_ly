/// Energy consumption data for a single device
class EnergyRecord {
  const EnergyRecord({
    required this.deviceId,
    required this.kwh,
    required this.watts,
    required this.timestamp,
    this.roomId,
    this.status = 'OFF',
    this.isReal = false,
  });

  final String deviceId;
  final double kwh;
  final double watts;
  final DateTime timestamp;
  final String? roomId;
  final String status; // "ON" or "OFF"
  final bool isReal; // true = from hardware, false = from simulator

  String get deviceName => deviceId.replaceAll('_', ' ');
}

/// Energy consumption per room
class RoomEnergy {
  const RoomEnergy({required this.roomName, required this.totalKwh});
  final String roomName;
  final double totalKwh;
}

/// Daily cost breakdown
class DailyCost {
  const DailyCost({
    required this.date,
    required this.kwh,
    required this.cost,
  });

  final DateTime date;
  final double kwh;
  final double cost;

  String get dayOfWeek {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String get formatted => '${date.day}/${date.month}';
}

/// Weekly cost breakdown
class WeeklyCost {
  const WeeklyCost({
    required this.weekStart,
    required this.kwh,
    required this.cost,
  });

  final DateTime weekStart;
  final double kwh;
  final double cost;

  String get formatted =>
      'Week ${weekStart.day}/${weekStart.month}';
}

/// Monthly cost breakdown
class MonthlyCost {
  const MonthlyCost({
    required this.year,
    required this.month,
    required this.kwh,
    required this.cost,
  });

  final int year;
  final int month;
  final double kwh;
  final double cost;

  String get monthName {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String get formatted => '$monthName $year';
}
