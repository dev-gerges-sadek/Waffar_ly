// ============================================================================
// ai_source_panel.dart
// Side-by-side (or stacked on narrow screens) cards for simulator + hardware
// AI analysis results. Responsive via LayoutBuilder.
// ============================================================================

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../models/ai_result.dart';

class AiSourcePanel extends StatelessWidget {
  const AiSourcePanel({
    super.key,
    required this.simulator,
    required this.hardware,
  });

  final AiResult simulator;
  final AiResult hardware;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 340;
        final simCard = _AiSourceCard(
          result: simulator,
          accentColor: SHColors.primary(context),
          sourceLabel: l10n.simulation,
          icon: Icons.computer_rounded,
        );
        final hwCard = _AiSourceCard(
          result: hardware,
          accentColor: SHColors.severity(context, 'danger'),
          sourceLabel: l10n.hardware,
          icon: Icons.memory_rounded,
        );
        if (isWide) {
          return Row(
            children: [
              Expanded(child: simCard),
              SizedBox(width: 10.w),
              Expanded(child: hwCard),
            ],
          );
        }
        return Column(
          children: [
            simCard,
            SizedBox(height: 10.h),
            hwCard,
          ],
        );
      },
    );
  }
}

// ── Individual AI source card ─────────────────────────────────────────────────

class _AiSourceCard extends StatelessWidget {
  const _AiSourceCard({
    required this.result,
    required this.accentColor,
    required this.sourceLabel,
    required this.icon,
  });

  final AiResult result;
  final Color accentColor;
  final String sourceLabel;
  final IconData icon;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sevColor = _severityColor(context, result.severity);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? SHColors.darkCardColor : SHColors.lightCardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: sevColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: source chip + decision badge
          Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 7.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 10.sp, color: accentColor),
                    SizedBox(width: 3.w),
                    Text(
                      sourceLabel,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerEnd,
                  child: _DecisionBadge(
                    label: result.severity.localLabel(l10n.isArabic),
                    emoji: result.severity.emoji,
                    color: sevColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Watt reading
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '${result.watts.toStringAsFixed(1)} ${l10n.watts}',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: sevColor,
                height: 1.0,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '${result.amperes.toStringAsFixed(2)} ${l10n.amps}  •  '
            '${result.voltage.toStringAsFixed(0)} ${l10n.volts}',
            style: TextStyle(fontSize: 9.sp, color: hintColor),
          ),
          SizedBox(height: 10.h),

          // Anomaly probability bar
          _MiniProbBar(
            label: l10n.anomaly,
            probAnomaly: result.probAnomalyPct,
            color: sevColor,
          ),
          SizedBox(height: 10.h),

          // Cost chips
          Row(
            children: [
              _CostChip(
                label: l10n.cost,
                value:
                    '${result.costSoFarEgp.toStringAsFixed(2)} ${l10n.billLabel}',
                color: textColor,
                hint: hintColor,
              ),
              SizedBox(width: 6.w),
              _CostChip(
                label: l10n.forecast,
                value:
                    '${result.predictedMonthlyEgp.toStringAsFixed(0)} ${l10n.billLabel}',
                color: accentColor,
                hint: hintColor,
              ),
            ],
          ),

          // Last update timestamp
          if (result.lastUpdate.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.update_rounded, size: 9.sp, color: hintColor),
                SizedBox(width: 2.w),
                Text(
                  result.lastUpdate,
                  style: TextStyle(fontSize: 8.sp, color: hintColor),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Decision badge ────────────────────────────────────────────────────────────

class _DecisionBadge extends StatelessWidget {
  const _DecisionBadge({
    required this.label,
    required this.emoji,
    required this.color,
  });
  final String label, emoji;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: color.withOpacity(0.13),
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: color.withOpacity(0.35)),
    ),
    child: Text(
      emoji.isNotEmpty ? '$emoji $label' : label,
      style: TextStyle(
        fontSize: 9.5.sp,
        fontWeight: FontWeight.w800,
        color: color,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  );
}

// ── Mini probability bar ──────────────────────────────────────────────────────

class _MiniProbBar extends StatelessWidget {
  const _MiniProbBar({
    required this.label,
    required this.probAnomaly,
    required this.color,
  });
  final String label;
  final int probAnomaly;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 8.5.sp, color: SHColors.hint(context)),
          ),
          Text(
            '$probAnomaly%',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
      SizedBox(height: 4.h),
      ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: LinearProgressIndicator(
          value: (probAnomaly / 100).clamp(0.0, 1.0),
          minHeight: 5.h,
          backgroundColor: SHColors.lightSeverityNormal.withOpacity(0.20),
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    ],
  );
}

// ── Cost chip ─────────────────────────────────────────────────────────────────

class _CostChip extends StatelessWidget {
  const _CostChip({
    required this.label,
    required this.value,
    required this.color,
    required this.hint,
  });
  final String label, value;
  final Color color, hint;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: SHColors.background(context),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 8.sp, color: hint),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

// ── Reusable stat card with glassmorphism border ──────────────────────────────

class AiStatCard extends StatelessWidget {
  const AiStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.sublabel,
    this.trend,
    this.onTap,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String? sublabel;

  /// Positive = consumption up (amber), negative = down (green).
  final double? trend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.10 : 0.07),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: color.withOpacity(isDark ? 0.30 : 0.22),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isDark ? 0.12 : 0.08),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon row with optional trend badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: color, size: 16.sp),
                ),
                if (trend != null) _TrendBadge(trend: trend!),
              ],
            ),
            SizedBox(height: 10.h),

            // Value + unit
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: color,
                        height: 1.0,
                      ),
                    ),
                    TextSpan(
                      text: '  $unit',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: color.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),

            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5.sp,
                color: SHColors.hint(context),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            if (sublabel != null) ...[
              SizedBox(height: 2.h),
              Text(
                sublabel!,
                style: TextStyle(
                  fontSize: 8.5.sp,
                  color: SHColors.hint(context).withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Trend badge ───────────────────────────────────────────────────────────────

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.trend});
  final double trend;

  @override
  Widget build(BuildContext context) {
    final isPositive = trend >= 0;
    // Energy up = bad (orange), down = good (green)
    final color = isPositive
        ? SHColors.severity(context, 'danger')
        : Colors.green.shade400;
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: 8.sp,
            color: color,
          ),
          SizedBox(width: 2.w),
          Text(
            '${trend.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
