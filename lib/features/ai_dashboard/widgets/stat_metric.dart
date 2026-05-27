// ============================================================================
// stat_metric.dart
// Reusable metric tile: icon + label + value.
// Also contains RateFooterCard used at the bottom of the dashboard.
// ============================================================================

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';

// ── Mini metric tile ──────────────────────────────────────────────────────────

class StatMetric extends StatelessWidget {
  const StatMetric({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18.sp),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: SHColors.text(context),
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Rate footer card ──────────────────────────────────────────────────────────

/// Displays the current electricity rate with an edit button.
class RateFooterCard extends StatelessWidget {
  const RateFooterCard({
    super.key,
    required this.rate,
    required this.primary,
    required this.onTap,
  });

  final double rate;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: SHColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: primary.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt_rounded, color: primary, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.electricityRateLabel,
                  style: TextStyle(fontSize: 9.sp, color: SHColors.hint(context)),
                ),
                Text(
                  '${rate.toStringAsFixed(3)} ${l10n.electricityRateUnit}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: SHColors.text(context),
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onTap,
            icon: Icon(Icons.edit_rounded, size: 14.sp, color: primary),
            label: Text(
              l10n.editLabel,
              style: TextStyle(fontSize: 11.sp, color: primary),
            ),
          ),
        ],
      ),
    );
  }
}
