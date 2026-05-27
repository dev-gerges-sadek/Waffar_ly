// ============================================================================
// energy_snapshot_card.dart
// 2x2 stat grid + monthly forecast banner.
// Shows: total kWh, estimated cost, device count, live watts.
// ============================================================================

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../cubit/ai_energy_state.dart';
import 'ai_source_panel.dart' show AiStatCard;

class EnergySnapshotCard extends StatelessWidget {
  const EnergySnapshotCard({super.key, required this.state});
  final AiEnergyLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = SHColors.primary(context);
    final amber = isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2-column stat grid
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 10.w) / 2;
            return Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                SizedBox(
                  width: itemWidth,
                  child: AiStatCard(
                    label: l10n.totalKwhLabel,
                    value: state.totalKwh.toStringAsFixed(2),
                    unit: l10n.kwh,
                    icon: Icons.energy_savings_leaf_rounded,
                    color: primary,
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AiStatCard(
                    label: l10n.estimatedCost,
                    value: state.estimatedCost.toStringAsFixed(2),
                    unit: l10n.billLabel,
                    icon: Icons.payments_rounded,
                    color: amber,
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AiStatCard(
                    label: l10n.devices,
                    value: '${state.deviceCount}',
                    unit: l10n.devices,
                    icon: Icons.devices_rounded,
                    color: SHColors.severity(context, 'normal'),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AiStatCard(
                    label: l10n.liveWatts,
                    value: state.totalLiveWatts.toStringAsFixed(1),
                    unit: l10n.watts,
                    icon: Icons.electric_bolt_rounded,
                    color: SHColors.chartBlue(context),
                    sublabel:
                        '${state.totalLiveAmperes.toStringAsFixed(2)} ${l10n.amps}',
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 12.h),

        // Monthly forecast banner
        _MonthlyForecastBanner(
          monthly: state.totalPredictedMonthlyEgp,
          rate: state.electricityRate,
          amber: amber,
          primary: primary,
        ),
      ],
    );
  }
}

class _MonthlyForecastBanner extends StatelessWidget {
  const _MonthlyForecastBanner({
    required this.monthly,
    required this.rate,
    required this.amber,
    required this.primary,
  });
  final double monthly, rate;
  final Color amber, primary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            amber.withOpacity(isDark ? 0.12 : 0.08),
            primary.withOpacity(isDark ? 0.08 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: amber.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month_rounded, color: amber, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.predictedMonthly,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: SHColors.hint(context),
                  ),
                ),
                Text(
                  '${monthly.toStringAsFixed(0)} ${l10n.billLabel}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: amber,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${rate.toStringAsFixed(3)} ${l10n.electricityRateSuffix}',
              style: TextStyle(
                fontSize: 9.sp,
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
