import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../models/ai_result.dart';
import 'ai_probability_gauge.dart';
import 'ai_severity_badge.dart';

class AiResultCard extends StatelessWidget {
  const AiResultCard({
    super.key,
    required this.aiResult,
  });

  final AiResult aiResult;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = SHColors.card(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header with source + severity ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${aiResult.source.toUpperCase()} MODE',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: hintColor,
                  letterSpacing: 1.0,
                ),
              ),
              AiSeverityBadge(
                severity: aiResult.severity,
                aiDecision: aiResult.aiDecision,
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // ── Recommendation ─────────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: _getRecommendationBgColor(aiResult.severity),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: _getRecommendationBorderColor(aiResult.severity),
              ),
            ),
            child: Text(
              aiResult.recommendation,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: _getRecommendationTextColor(aiResult.severity),
                height: 1.4,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // ── Telemetry grid ────────────────────────────────────────────
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1.3,
            children: [
              _TelemetryTile(
                icon: '⚡',
                label: 'Watts',
                value: aiResult.watts.toStringAsFixed(1),
                unit: 'W',
                isDark: isDark,
              ),
              _TelemetryTile(
                icon: '🔌',
                label: 'Amperes',
                value: aiResult.amperes.toStringAsFixed(2),
                unit: 'A',
                isDark: isDark,
              ),
              _TelemetryTile(
                icon: '⚙️',
                label: 'Voltage',
                value: aiResult.voltage.toStringAsFixed(1),
                unit: 'V',
                isDark: isDark,
              ),
              _TelemetryTile(
                icon: '📊',
                label: 'kWh',
                value: aiResult.kwhConsumed.toStringAsFixed(4),
                unit: 'kWh',
                isDark: isDark,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── Probability gauge ──────────────────────────────────────────
          AiProbabilityGauge(
            anomalyProb: aiResult.probAnomalyPct,
            normalProb: aiResult.probNormalPct,
          ),

          SizedBox(height: 16.h),

          // ── Cost breakdown ────────────────────────────────────────────
          _CostSection(
            costPerKwh: aiResult.costPerKwhEgp,
            costSoFar: aiResult.costSoFarEgp,
            predictedMonthly: aiResult.predictedMonthlyEgp,
            isDark: isDark,
          ),

          SizedBox(height: 12.h),

          // ── Footer with timestamp ──────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Updated: ${aiResult.lastUpdate}',
              style: TextStyle(
                fontSize: 9.sp,
                color: hintColor.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRecommendationBgColor(AiSeverity severity) {
    switch (severity) {
      case AiSeverity.critical:
        return Colors.red.withOpacity(0.1);
      case AiSeverity.danger:
        return Colors.orange.withOpacity(0.1);
      case AiSeverity.warning:
        return Colors.amber.withOpacity(0.1);
      case AiSeverity.normal:
        return Colors.green.withOpacity(0.1);
    }
  }

  Color _getRecommendationBorderColor(AiSeverity severity) {
    switch (severity) {
      case AiSeverity.critical:
        return Colors.red.withOpacity(0.3);
      case AiSeverity.danger:
        return Colors.orange.withOpacity(0.3);
      case AiSeverity.warning:
        return Colors.amber.withOpacity(0.3);
      case AiSeverity.normal:
        return Colors.green.withOpacity(0.3);
    }
  }

  Color _getRecommendationTextColor(AiSeverity severity) {
    switch (severity) {
      case AiSeverity.critical:
        return Colors.red;
      case AiSeverity.danger:
        return Colors.orange[700]!;
      case AiSeverity.warning:
        return Colors.amber[900]!;
      case AiSeverity.normal:
        return Colors.green[700]!;
    }
  }
}

// ── Single telemetry tile ──────────────────────────────────────────────────
class _TelemetryTile extends StatelessWidget {
  const _TelemetryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.isDark,
  });

  final String icon;
  final String label;
  final String value;
  final String unit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(icon, style: TextStyle(fontSize: 16.sp)),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: hintColor,
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                    color: hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cost breakdown section ─────────────────────────────────────────────────
class _CostSection extends StatelessWidget {
  const _CostSection({
    required this.costPerKwh,
    required this.costSoFar,
    required this.predictedMonthly,
    required this.isDark,
  });

  final double costPerKwh;
  final double costSoFar;
  final double predictedMonthly;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);
    final hintColor = SHColors.hint(context);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          _CostRow(
            label: '💰 Cost/kWh',
            value: '${costPerKwh.toStringAsFixed(2)} EGP',
          ),
          SizedBox(height: 8.h),
          _CostRow(
            label: '📈 Cost So Far',
            value: '${costSoFar.toStringAsFixed(2)} EGP',
          ),
          SizedBox(height: 8.h),
          Container(
            height: 1,
            color: hintColor.withOpacity(0.2),
          ),
          SizedBox(height: 8.h),
          _CostRow(
            label: '📅 Predicted Monthly',
            value: '${predictedMonthly.toStringAsFixed(2)} EGP',
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: textColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
