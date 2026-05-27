import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/anomaly_states.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({super.key, required this.alert});
  final AnomalyAlert alert;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final isCritical = alert.aiDecision.contains('CRITICAL');

    // SHColors semantic colours — no raw Colors.red / Colors.orange
    final severityColor = isCritical
        ? (isDark ? SHColors.darkErrorColor : SHColors.lightErrorColor)
        : (isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor);

    final decisionLabel = isCritical
        ? l10n.decisionCritical
        : l10n.decisionWarning;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: SHColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: severityColor.withOpacity(0.40)),
        boxShadow: [
          BoxShadow(
            color: severityColor.withOpacity(isDark ? 0.15 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 8.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  decisionLabel,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w800,
                    color: severityColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  l10n.translateDeviceOrRoomName(alert.deviceName),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              Icon(
                isCritical
                    ? Icons.report_problem_rounded
                    : Icons.warning_amber_rounded,
                color: severityColor,
                size: 18.sp,
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // ── Recommendation ────────────────────────────────────────
          Text(
            l10n.translateRecommendation(alert.recommendation),
            style: TextStyle(
              fontSize: 12.sp,
              color: textColor,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),

          // ── Stat chips ────────────────────────────────────────────
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              _StatChip(
                label: l10n.watts,
                value: '${alert.watts.toStringAsFixed(1)} W',
                color: severityColor,
              ),
              _StatChip(
                label: l10n.anomaly,
                value: '${alert.probAnomaly.toStringAsFixed(0)}%',
                color: hintColor,
              ),
              _StatChip(
                label: l10n.kwh,
                value: '${alert.currentKwh.toStringAsFixed(3)} kWh',
                color: severityColor,
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // ── Timestamp ─────────────────────────────────────────────
          Text(
            '${l10n.lastUpdated}: '
            '${DateFormat('HH:mm · d MMM').format(alert.detectedAt)}',
            style: TextStyle(fontSize: 10.sp, color: hintColor),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: color.withOpacity(0.10),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 9.sp, color: SHColors.hint(context)),
        ),
      ],
    ),
  );
}
