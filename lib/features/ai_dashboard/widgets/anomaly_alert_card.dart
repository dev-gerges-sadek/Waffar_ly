// ============================================================================
// anomaly_alert_card.dart
// Prominent card displayed when AI reports an anomaly.
// Shows: severity badge, probability bar, localised recommendation, live readings.
// Hides itself (SizedBox.shrink) when result is not an anomaly.
// ============================================================================

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../models/ai_result.dart';

class AnomalyAlertCard extends StatelessWidget {
  const AnomalyAlertCard({
    super.key,
    required this.result,
    required this.sourceLabel,
  });

  final AiResult result;
  final String sourceLabel;

  @override
  Widget build(BuildContext context) {
    if (!result.isAnomaly) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _severityColor(context, result.severity);
    final textColor = SHColors.text(context);

    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: color.withOpacity(0.45), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  result.severity == AiSeverity.critical
                      ? Icons.dangerous_rounded
                      : Icons.warning_amber_rounded,
                  color: color,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.anomalyDetected,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    Text(
                      sourceLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: SHColors.hint(context),
                      ),
                    ),
                  ],
                ),
              ),
              _SeverityBadge(severity: result.severity, l10n: l10n),
            ],
          ),
          SizedBox(height: 12.h),

          // Probability bar
          _ProbabilityRow(
            probAnomaly: result.probAnomalyPct,
            probNormal: result.probNormalPct,
            color: color,
            l10n: l10n,
          ),
          SizedBox(height: 12.h),

          // Localised recommendation
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: color.withOpacity(0.18)),
            ),
            child: Text(
              result.severity.recommendation(
                l10n.isArabic,
                result.watts,
                result.amperes,
              ),
              style: TextStyle(fontSize: 11.sp, color: textColor, height: 1.55),
            ),
          ),
          SizedBox(height: 10.h),

          // Live readings chips
          _LiveReadingsRow(result: result, l10n: l10n),
        ],
      ),
    );
  }

  Color _severityColor(BuildContext context, AiSeverity s) {
    switch (s) {
      case AiSeverity.normal:
        return SHColors.severity(context, 'normal');
      case AiSeverity.warning:
        return SHColors.severity(context, 'warning');
      case AiSeverity.danger:
        return SHColors.severity(context, 'danger');
      case AiSeverity.critical:
        return SHColors.severity(context, 'critical');
    }
  }
}

// ── Severity badge ────────────────────────────────────────────────────────────

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.severity, required this.l10n});
  final AiSeverity severity;
  final AppLocalizations l10n;

  Color _color(BuildContext context, AiSeverity s) {
    switch (s) {
      case AiSeverity.normal:
        return SHColors.severity(context, 'normal');
      case AiSeverity.warning:
        return SHColors.severity(context, 'warning');
      case AiSeverity.danger:
        return SHColors.severity(context, 'danger');
      case AiSeverity.critical:
        return SHColors.severity(context, 'critical');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context, severity);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        severity.localLabel(l10n.isArabic),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

// ── Probability bar ───────────────────────────────────────────────────────────

class _ProbabilityRow extends StatelessWidget {
  const _ProbabilityRow({
    required this.probAnomaly,
    required this.probNormal,
    required this.color,
    required this.l10n,
  });
  final int probAnomaly, probNormal;
  final Color color;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final hint = SHColors.hint(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.probabilitySignal,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: hint,
              ),
            ),
            Text(
              '${l10n.anomaly} $probAnomaly% · ${l10n.normal} $probNormal%',
              style: TextStyle(fontSize: 9.5.sp, color: hint),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: probAnomaly / 100,
            minHeight: 8.h,
            backgroundColor: SHColors.lightSeverityNormal.withOpacity(0.25),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

// ── Live readings chips ───────────────────────────────────────────────────────

class _LiveReadingsRow extends StatelessWidget {
  const _LiveReadingsRow({required this.result, required this.l10n});
  final AiResult result;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8.w,
    runSpacing: 6.h,
    children: [
      _Chip(
        label: '${result.watts.toStringAsFixed(1)} ${l10n.watts}',
        icon: Icons.bolt_rounded,
        color: SHColors.severity(context, 'danger'),
      ),
      _Chip(
        label: '${result.amperes.toStringAsFixed(2)} ${l10n.amps}',
        icon: Icons.electric_bolt,
        color: SHColors.severity(context, 'warning'),
      ),
      _Chip(
        label: '${result.voltage.toStringAsFixed(0)} ${l10n.volts}',
        icon: Icons.power_rounded,
        color: SHColors.chartBlue(context),
      ),
      _Chip(
        label: '${result.kwhConsumed.toStringAsFixed(3)} ${l10n.kwh}',
        icon: Icons.energy_savings_leaf_rounded,
        color: SHColors.severity(context, 'normal'),
      ),
    ],
  );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: color.withOpacity(0.10),
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10.sp, color: color),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5.sp,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
