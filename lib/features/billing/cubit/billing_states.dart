sealed class BillingState {}

class BillingInitial extends BillingState {}

class BillingLoading extends BillingState {}

class BillingLoaded extends BillingState {
  BillingLoaded({
    required this.dailyData,
    required this.weeklyData,
    required this.monthlyData,
    required this.currentMonthCost,
    required this.estimatedNextBill,
    required this.peakUsageDay,
    required this.electricityRate,
  });

  final List<DailyCost> dailyData;
  final List<WeeklyCost> weeklyData;
  final List<MonthlyCost> monthlyData;
  final double currentMonthCost;
  final double estimatedNextBill;
  final String peakUsageDay;
  final double electricityRate;
}

class BillingError extends BillingState {
  BillingError(this.message);
  final String message;
}

// ── Models ────────────────────────────────────────────────────────────────────

class DailyCost {
  DailyCost({
    required this.date,
    required this.cost,
    required this.kwh,
  });

  final DateTime date;
  final double cost;
  final double kwh;

  String get dayOfWeek {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}

class WeeklyCost {
  WeeklyCost({
    required this.weekStart,
    required this.cost,
    required this.kwh,
  });

  final DateTime weekStart;
  final double cost;
  final double kwh;

  String get displayWeek {
    final end = weekStart.add(const Duration(days: 6));
    return '${weekStart.day}-${end.day} ${_monthName(weekStart.month)}';
  }
}

class MonthlyCost {
  MonthlyCost({
    required this.year,
    required this.month,
    required this.cost,
    required this.kwh,
  });

  final int year;
  final int month;
  final double cost;
  final double kwh;

  String get displayMonth {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[month - 1]} $year';
  }
}

String _monthName(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}
