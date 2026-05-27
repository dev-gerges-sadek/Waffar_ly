import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'billing_states.dart';

class BillingCubit extends Cubit<BillingState> {
  BillingCubit() : super(BillingInitial());

  final _firestore = FirebaseFirestore.instance;
  StreamSubscription? _sub;
  double _rate = 1.25; // EGP per kWh

  void loadBilling() async {
    emit(BillingLoading());

    try {
      // Load electricity rate
      final prefs = await SharedPreferences.getInstance();
      _rate = prefs.getDouble('electricity_rate_per_kwh') ?? 1.25;

      // Listen to device_states for real-time kWh data
      _sub?.cancel();
      _sub = _firestore
          .collection('device_states')
          .snapshots()
          .listen((snap) async {
        try {
          await _processEnergyData(snap);
        } catch (e) {
          if (!isClosed) {
            emit(BillingError(e.toString()));
          }
        }
      }, onError: (e) {
        if (!isClosed) {
          emit(BillingError(e.toString()));
        }
      });
    } catch (e) {
      if (!isClosed) {
        emit(BillingError(e.toString()));
      }
    }
  }

  Future<void> _processEnergyData(QuerySnapshot snap) async {
    // Generate synthetic daily/weekly/monthly data for demo
    // In production, this would aggregate from historical snapshots

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Calculate current metrics from device states
    double totalKwh = 0;
    for (final doc in snap.docs) {
      final kwh = (doc['kwh'] as num?)?.toDouble() ?? 0.0;
      totalKwh += kwh;
    }

    // Generate daily data (last 7 days)
    final dailyData = <DailyCost>[];
    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      // Synthetic data: random between 5-15 kWh per day
      final kwh = 5 + (i * 1.2 + (i % 3) * 2.0); // Slight trend
      dailyData.add(DailyCost(
        date: date,
        kwh: kwh,
        cost: kwh * _rate,
      ));
    }

    // Generate weekly data (last 4 weeks)
    final weeklyData = <WeeklyCost>[];
    for (int i = 3; i >= 0; i--) {
      final weekStart = today.subtract(Duration(days: i * 7));
      final kwh = 50 + i * 5.0 + (i % 2) * 8.0; // Increasing trend
      weeklyData.add(WeeklyCost(
        weekStart: weekStart,
        kwh: kwh,
        cost: kwh * _rate,
      ));
    }

    // Generate monthly data (last 12 months)
    final monthlyData = <MonthlyCost>[];
    for (int i = 11; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      final kwh = 200 + i * 15.0 + (i % 4) * 25.0; // Seasonal variation
      monthlyData.add(MonthlyCost(
        year: date.year,
        month: date.month,
        kwh: kwh,
        cost: kwh * _rate,
      ));
    }

    // Calculate current month cost
    final currentMonthCost = monthlyData.isNotEmpty
        ? monthlyData.last.cost
        : totalKwh * _rate;

    // Estimate next bill (assume same usage as today)
    final estimatedDaily = dailyData.isNotEmpty
        ? dailyData.last.cost
        : totalKwh * _rate;
    const daysInMonth = 30;
    final estimatedNextBill = estimatedDaily * daysInMonth;

    // Find peak usage day
    final peakDay = dailyData.reduce((a, b) => a.cost > b.cost ? a : b);
    final peakUsageDay = peakDay.dayOfWeek;

    if (!isClosed) {
      emit(BillingLoaded(
        dailyData: dailyData,
        weeklyData: weeklyData,
        monthlyData: monthlyData,
        currentMonthCost: currentMonthCost,
        estimatedNextBill: estimatedNextBill,
        peakUsageDay: peakUsageDay,
        electricityRate: _rate,
      ));
    }
  }

  Future<void> updateRate(double newRate) async {
    _rate = newRate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('electricity_rate_per_kwh', newRate);

    // Reload with new rate
    if (state is BillingLoaded) {
      final current = state as BillingLoaded;
      // Recalculate all costs with new rate
      final recalcDaily = current.dailyData
          .map((d) => DailyCost(date: d.date, kwh: d.kwh, cost: d.kwh * newRate))
          .toList();
      final recalcWeekly = current.weeklyData
          .map((w) =>
              WeeklyCost(weekStart: w.weekStart, kwh: w.kwh, cost: w.kwh * newRate))
          .toList();
      final recalcMonthly = current.monthlyData
          .map((m) => MonthlyCost(
              year: m.year, month: m.month, kwh: m.kwh, cost: m.kwh * newRate))
          .toList();

      if (!isClosed) {
        emit(BillingLoaded(
          dailyData: recalcDaily,
          weeklyData: recalcWeekly,
          monthlyData: recalcMonthly,
          currentMonthCost: recalcMonthly.isNotEmpty
              ? recalcMonthly.last.cost
              : current.currentMonthCost * (newRate / _rate),
          estimatedNextBill: current.estimatedNextBill * (newRate / _rate),
          peakUsageDay: current.peakUsageDay,
          electricityRate: newRate,
        ));
      }
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
