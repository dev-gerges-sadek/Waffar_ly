import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';

class DeviceLegendBar extends StatelessWidget {
  const DeviceLegendBar({
    super.key,
    required this.simulationColor,
    required this.hardwareColor,
  });

  final Color simulationColor;
  final Color hardwareColor;

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final hint    = SHColors.hint(context);

    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(16.w, 14.h, 16.w, 0),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark
            ? SHColors.darkSurfaceColor.withOpacity(0.5)
            : SHColors.lightSurfaceColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _LegendChip(label: l10n.simulation, color: simulationColor),
          SizedBox(width: 8.w),
          _LegendChip(label: l10n.hardware, color: hardwareColor),
          const Spacer(),
          Flexible(
            child: Text(
              l10n.tapDetails,
              style: TextStyle(fontSize: 10.sp, color: hint),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.label, required this.color});
  final String label;
  final Color  color;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: color),
            ),
          ],
        ),
      );
}

class DeviceSummaryChips extends StatelessWidget {
  const DeviceSummaryChips({
    super.key,
    required this.onCount,
    required this.offCount,
    required this.total,
    required this.primaryColor,
    required this.hintColor,
  });

  final int   onCount, offCount, total;
  final Color primaryColor, hintColor;

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final success = SHColors.success(context);

    return Wrap(
      spacing: 8.w,
      runSpacing: 6.h,
      children: [
        _SummaryChip(label: '$onCount ${l10n.online}',  color: success),
        _SummaryChip(label: '$offCount ${l10n.offline}', color: hintColor),
        _SummaryChip(label: '$total ${l10n.devices}',    color: primaryColor),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.color});
  final String label;
  final Color  color;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: color),
        ),
      );
}
