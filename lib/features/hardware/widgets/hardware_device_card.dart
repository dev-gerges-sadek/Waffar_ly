// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../models/hardware_device.dart';

class HardwareDeviceCard extends StatelessWidget {
  const HardwareDeviceCard({super.key, required this.device});
  final HardwareDevice device;

  @override
  Widget build(BuildContext context) {
    final isDark       = Theme.of(context).brightness == Brightness.dark;
    final cardColor    = SHColors.card(context);
    final textColor    = SHColors.text(context);
    final hintColor    = SHColors.hint(context);
    final primary      = SHColors.primary(context);
    final amber        = isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;
    final statusColor  = _safetyColor(context, device.safetyStatus);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: statusColor.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.memory_rounded,
                    color: primary, size: 18.sp),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  device.displayName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor,
                  boxShadow: [
                    BoxShadow(
                        color: statusColor.withOpacity(0.5),
                        blurRadius: 6),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _ReadingRow(
              label: AppLocalizations.of(context).voltage,
              value: '${device.voltage.toStringAsFixed(1)} V',
              valueColor: amber,
              hintColor: hintColor),
          _ReadingRow(
              label: AppLocalizations.of(context).amperes,
              value: '${device.current.toStringAsFixed(2)} A',
              valueColor: primary,
              hintColor: hintColor),
          _ReadingRow(
              label: AppLocalizations.of(context).watts,
              value: '${device.power.toStringAsFixed(1)} W',
              valueColor: SHColors.success(context),
              hintColor: hintColor),
          if (device.kwh != null)
            _ReadingRow(
                label: AppLocalizations.of(context).kwh,
                value: device.kwh!.toStringAsFixed(3),
                valueColor: hintColor,
                hintColor: hintColor),
          if (device.status != null)
            _ReadingRow(
                label: AppLocalizations.of(context).status,
                value: device.status!,
                // tealAccent → primary (same visual intent: live/active)
                valueColor: primary,
                hintColor: hintColor),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              device.source,
              style: TextStyle(
                  fontSize: 8.sp,
                  color: primary,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Color _safetyColor(BuildContext context, HardwareSafetyStatus s) =>
      switch (s) {
        HardwareSafetyStatus.idle     => SHColors.hint(context),
        HardwareSafetyStatus.normal   => SHColors.severity(context, 'normal'),
        HardwareSafetyStatus.warning  => SHColors.severity(context, 'warning'),
        HardwareSafetyStatus.critical => SHColors.severity(context, 'critical'),
      };
}

class _ReadingRow extends StatelessWidget {
  const _ReadingRow({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.hintColor,
  });

  final String label, value;
  final Color  valueColor, hintColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(bottom: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    TextStyle(fontSize: 10.5.sp, color: hintColor)),
            Text(value,
                style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: valueColor)),
          ],
        ),
      );
}
