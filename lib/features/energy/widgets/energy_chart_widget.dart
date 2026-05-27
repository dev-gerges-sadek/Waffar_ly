// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/energy_states.dart';
import '../models/rtdb_device_snapshot.dart';

/// Real-time energy consumption line chart showing watts over time
class EnergyChartWidget extends StatelessWidget {
  const EnergyChartWidget({
    required this.records,
    required this.primary,
    super.key,
  });

  final List<EnergyRecord> records;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chartColor =
        isDark ? primary.withOpacity(0.7) : primary;
    final gridColor = SHColors.hint(context).withOpacity(0.1);

    // Group devices into 5-minute buckets for visualization
    final buckets = _groupDevices(records);

    if (buckets.isEmpty || records.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.h),
          child: Text(
            'No energy data available',
            style: TextStyle(
              fontSize: 13.sp,
              color: SHColors.hint(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    final spots = List<FlSpot>.from(
      buckets.asMap().entries.map(
        (e) => FlSpot(e.key.toDouble(), e.value),
      ),
    );

    final maxWatts = buckets.fold(0.0, (max, val) => max > val ? max : val);
    final yInterval =
        (maxWatts / 4).roundToDouble().clamp(100, double.infinity);

    return Container(
      height: 240.h,
      padding: EdgeInsets.all(16.w),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (value) => FlLine(
              color: gridColor,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()} W',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: SHColors.hint(context),
                  ),
                ),
                reservedSize: 45,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() % 2 == 0) {
                    return Text(
                      'T${value.toInt()}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: SHColors.hint(context),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: gridColor,
                width: 1,
              ),
              left: BorderSide(
                color: gridColor,
                width: 1,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: chartColor,
              barWidth: 2.5,
              belowBarData: BarAreaData(
                show: true,
                color: chartColor.withOpacity(0.1),
              ),
              dotData: FlDotData(
                show: spots.length <= 6,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4.w,
                  color: chartColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
            ),
          ],
          minX: 0,
          maxX: (buckets.length - 1).toDouble().clamp(0, double.infinity),
          minY: 0,
          maxY: maxWatts * 1.1,
        ),
      ),
    );
  }

  /// Group devices into buckets for smooth charting
  List<double> _groupDevices(List<EnergyRecord> records) {
    if (records.isEmpty) return [];

    // Create 10 time buckets
    final buckets = List<double>.filled(10, 0);
    final recordsPerBucket = (records.length / buckets.length).ceil().clamp(1, 100);

    for (int i = 0; i < records.length; i++) {
      final bucketIndex = (i / recordsPerBucket).floor().clamp(0, 9);
      buckets[bucketIndex] += records[i].watts;
    }

    // Average each bucket
    return buckets
        .asMap()
        .entries
        .map((e) => e.value / recordsPerBucket)
        .toList();
  }
}

/// Top consuming devices bar chart
class TopDevicesChartWidget extends StatelessWidget {
  const TopDevicesChartWidget({
    required this.records,
    required this.primary,
    super.key,
  });

  final List<EnergyRecord> records;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chartColor =
        isDark ? primary.withOpacity(0.8) : primary;
    final gridColor = SHColors.hint(context).withOpacity(0.1);

    // Get top 5 devices by watts
    final topDevices = [...records]
        ..sort((a, b) => b.watts.compareTo(a.watts))
        ..take(5);

    if (topDevices.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.h),
          child: Text(
            'No device data',
            style: TextStyle(
              fontSize: 13.sp,
              color: SHColors.hint(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    final barGroups = topDevices.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value.watts,
            color: chartColor,
            width: 20.w,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(4.r),
            ),
          ),
        ],
      );
    }).toList();

    final maxWatts =
        topDevices.fold(0.0, (max, r) => max > r.watts ? max : r.watts);

    return Container(
      height: 240.h,
      padding: EdgeInsets.all(16.w),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxWatts * 1.15,
          barGroups: barGroups,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval:
                (maxWatts / 4).roundToDouble().clamp(100, double.infinity),
            getDrawingHorizontalLine: (value) => FlLine(
              color: gridColor,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}W',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: SHColors.hint(context),
                  ),
                ),
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < topDevices.length) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        topDevices[idx].deviceId
                            .replaceAll('_', '\n')
                            .split('\n')
                            .last,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: SHColors.hint(context),
                        ),
                        maxLines: 2,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 45,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: gridColor,
                width: 1,
              ),
              left: BorderSide(
                color: gridColor,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
