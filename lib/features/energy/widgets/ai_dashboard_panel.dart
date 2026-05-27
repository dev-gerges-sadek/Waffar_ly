// ignore_for_file: deprecated_member_use
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/ai_result_cubit.dart';
import '../models/ai_result_model.dart';

class AiDashboardPanel extends StatelessWidget {
  const AiDashboardPanel({super.key, required this.aiState});
  final AIResultState aiState;

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary = SHColors.primary(context);
    final danger = Colors.redAccent.shade400;
    final normal = Colors.greenAccent.shade400;

    final data = aiState is AIResultSuccess ? (aiState as AIResultSuccess).result : AIResultModel.empty;
    final stats = [
      _TrendData('Live', data.liveWatts ?? data.watts, primary),
      _TrendData('Cost', data.currentBillEgp ?? data.costSoFarEgp, Colors.amber.shade700),
      _TrendData('Forecast', data.predictedMonthlyBill ?? data.predictedMonthlyEgp, danger),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            color: SHColors.card(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI ENERGY DASHBOARD',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: textColor)),
              SizedBox(height: 14.h),
              SizedBox(
                height: 180.h,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= stats.length) return const SizedBox.shrink();
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(stats[index].label,
                                  style: TextStyle(fontSize: 10.sp, color: hintColor)),
                            );
                          },
                        ),
                      ),
                    ),
                    minY: 0,
                    maxY: (stats.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.25).clamp(10, double.infinity),
                    lineBarsData: [
                      LineChartBarData(
                        spots: stats.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.value)).toList(),
                        isCurved: true,
                        barWidth: 3,
                        color: primary,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: true, color: primary.withOpacity(0.18)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: stats
                    .map((item) => Expanded(
                          child: Column(
                            children: [
                              Text(item.value.toStringAsFixed(1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: item.color)),
                              SizedBox(height: 4.h),
                              Text(item.label,
                                  style: TextStyle(fontSize: 9.sp, color: hintColor), textAlign: TextAlign.center),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ProbabilityPie(data: data, textColor: textColor, primary: primary, danger: danger)),
            SizedBox(width: 12.w),
            Expanded(child: _HeatmapPanel(data: data)),
          ],
        ),
      ],
    );
  }
}

class _HeatmapPanel extends StatelessWidget {
  const _HeatmapPanel({required this.data});
  final AIResultModel data;

  @override
  Widget build(BuildContext context) {
    final hintColor = SHColors.hint(context);
    final textColor = SHColors.text(context);
    final boxes = [
      _HeatmapCell('Decision', data.aiDecision.name.toUpperCase(), data.aiDecision == AiDecision.normal ? Colors.greenAccent.shade400 : Colors.orangeAccent.shade400),
      _HeatmapCell('Voltage', '${data.voltage.toStringAsFixed(1)} V', Colors.blueAccent.shade200),
      _HeatmapCell('Humidity', '${data.humidityPct.toStringAsFixed(1)}%', Colors.indigoAccent.shade200),
      _HeatmapCell('Temp', '${data.temperatureC.toStringAsFixed(1)}°C', Colors.redAccent.shade200),
    ];

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: SHColors.card(context),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SYSTEM HEATMAP', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: textColor)),
          SizedBox(height: 14.h),
          Wrap(
            runSpacing: 10.h,
            spacing: 10.w,
            children: boxes.map((cell) => _HeatmapBox(cell: cell)).toList(),
          ),
          SizedBox(height: 12.h),
          Text('Last update: ${data.lastUpdate == DateTime.fromMillisecondsSinceEpoch(0) ? 'N/A' : data.lastUpdate.toLocal()}',
              style: TextStyle(fontSize: 9.sp, color: hintColor)),
        ],
      ),
    );
  }
}

class _HeatmapCell {
  const _HeatmapCell(this.title, this.value, this.color);
  final String title;
  final String value;
  final Color color;
}

class _HeatmapBox extends StatelessWidget {
  const _HeatmapBox({required this.cell});
  final _HeatmapCell cell;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 72.w) / 2,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cell.color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cell.title, style: TextStyle(fontSize: 10.sp, color: SHColors.text(context).withOpacity(0.7))),
          SizedBox(height: 8.h),
          Text(cell.value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: SHColors.text(context))),
        ],
      ),
    );
  }
}

class _ProbabilityPie extends StatelessWidget {
  const _ProbabilityPie({
    required this.data,
    required this.textColor,
    required this.primary,
    required this.danger,
  });

  final AIResultModel data;
  final Color textColor;
  final Color primary;
  final Color danger;

  @override
  Widget build(BuildContext context) {
    final normal = (100 - data.probAnomalyPct).clamp(0, 100);
    final anomaly = data.probAnomalyPct.clamp(0, 100);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: SHColors.card(context),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Text('ANOMALY SCORE', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: textColor)),
          SizedBox(height: 14.h),
          SizedBox(
            height: 160.h,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 28,
                sections: [
                  PieChartSectionData(
                    color: danger,
                    value: anomaly,
                    title: '${anomaly.toStringAsFixed(0)}%',
                    radius: 44,
                    titleStyle: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                  PieChartSectionData(
                    color: primary,
                    value: normal,
                    title: '${normal.toStringAsFixed(0)}%',
                    radius: 34,
                    titleStyle: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Column(
            children: [
              _LegendItem(color: danger, label: 'Anomaly'),
              SizedBox(height: 6.h),
              _LegendItem(color: primary, label: 'Normal'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10.w, height: 10.w, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3.r))),
        SizedBox(width: 8.w),
        Text(label, style: TextStyle(fontSize: 10.sp, color: SHColors.text(context))),
      ],
    );
  }
}

class _TrendData {
  const _TrendData(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color;
}
