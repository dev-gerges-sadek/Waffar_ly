// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/device_model.dart';
import '../../../core/theme/sh_colors.dart';

enum DataSourceTag { simulation, hardware }

class DeviceDataBadge extends StatelessWidget {
  const DeviceDataBadge({super.key, required this.tag, required this.data});

  final DataSourceTag tag;
  final DeviceData? data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSimulation = tag == DataSourceTag.simulation;

    // Simulation = cyan tint  |  Hardware = amber tint
    final Color accent = isSimulation
        ? (isDark ? SHColors.darkPrimaryColor : SHColors.lightPrimaryColor)
        : (isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor);

    final Color bgColor = accent.withOpacity(isDark ? 0.15 : 0.09);
    final Color textColor = SHColors.text(context);
    final Color hintColor = SHColors.hint(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accent.withOpacity(0.35), width: 1),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Tag row ────────────────────────────────────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data != null ? accent : hintColor,
                  ),
                ),
                SizedBox(width: 5.w),
                Flexible(
                  child: Text(
                    isSimulation ? 'Simulation' : 'Hardware',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: accent,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            // ── Status ─────────────────────────────────────────────────────
            if (data == null)
              Text(
                'No data',
                style: TextStyle(fontSize: 10.sp, color: hintColor),
              )
            else ...[
              _DataRow(
                label: 'Status',
                value: data!.status,
                valueColor: data!.isOn
                    ? Colors.greenAccent.shade400
                    : hintColor,
                textColor: textColor,
              ),
              if (data!.watts != null)
                _DataRow(
                  label: 'Watts',
                  value: '${data!.watts!.toStringAsFixed(1)} W',
                  textColor: textColor,
                ),
              if (data!.kwh != null)
                _DataRow(
                  label: 'kWh',
                  value: data!.kwh!.toStringAsFixed(2),
                  textColor: textColor,
                ),
              if (data!.volts != null)
                _DataRow(
                  label: 'Volts',
                  value: '${data!.volts!.toStringAsFixed(1)} V',
                  textColor: textColor,
                ),
              if (data!.amps != null)
                _DataRow(
                  label: 'Amps',
                  value: '${data!.amps!.toStringAsFixed(2)} A',
                  textColor: textColor,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.value,
    required this.textColor,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color textColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 9.5.sp,
              color: textColor.withOpacity(0.5),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                color: valueColor ?? textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
