import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/ai_energy_state.dart';

/// Hero KPI block: the four numbers a household actually cares about.
/// Two columns on phones, four on wide screens; values animate when they
/// change and every tile is a single merged semantics node for TalkBack.
class DashboardKpiGrid extends StatelessWidget {
  const DashboardKpiGrid({super.key, required this.state});

  final AiEnergyLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tiles = [
      _KpiTile(
        icon: Icons.electric_bolt_rounded,
        color: SHColors.primary(context),
        label: l10n.dashLivePower,
        value: state.totalLiveWatts,
        decimals: 0,
        unit: l10n.watts,
      ),
      _KpiTile(
        icon: Icons.battery_charging_full_rounded,
        color: SHColors.chartBlue(context),
        label: l10n.dashEnergyUsed,
        value: state.totalKwh,
        decimals: 2,
        unit: l10n.kwh,
      ),
      _KpiTile(
        icon: Icons.payments_rounded,
        color: SHColors.success(context),
        label: l10n.dashEstCost,
        value: state.estimatedCost,
        decimals: 2,
        unit: l10n.currencyEgp,
        footnote: state.totalPredictedMonthlyEgp > 0
            ? '${l10n.dashMonthlyForecast}: '
                  '${state.totalPredictedMonthlyEgp.toStringAsFixed(0)} '
                  '${l10n.currencyEgp}'
            : null,
      ),
      _KpiTile(
        icon: Icons.devices_other_rounded,
        color: SHColors.warning(context),
        label: l10n.dashActiveDevices,
        value: state.deviceCount.toDouble(),
        decimals: 0,
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth >= 640 ? 4 : 2;
        final gap = 10.w;
        final w = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final t in tiles) SizedBox(width: w, child: t),
          ],
        );
      },
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.decimals,
    this.unit,
    this.footnote,
  });

  final IconData icon;
  final Color color;
  final String label;
  final double value;
  final int decimals;
  final String? unit;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final text = SHColors.text(context);
    final hint = SHColors.hint(context);

    return Semantics(
      container: true,
      label: '$label: ${value.toStringAsFixed(decimals)} ${unit ?? ''}',
      child: ExcludeSemantics(
        child: Container(
          padding: EdgeInsets.all(12.w),
          constraints: BoxConstraints(minHeight: 104.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withValues(alpha: 0.22)),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                color.withValues(alpha: 0.14),
                SHColors.card(context),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(icon, color: color, size: 16.sp),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: hint,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              TweenAnimationBuilder<double>(
                tween: Tween(end: value),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                builder: (_, v, _) => FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: v.toStringAsFixed(decimals),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: text,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        if (unit != null)
                          TextSpan(
                            text: ' $unit',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (footnote != null) ...[
                SizedBox(height: 4.h),
                Text(
                  footnote!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.sp, color: hint),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
