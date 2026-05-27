// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/core/theme/sh_colors.dart';
import '../models/device_model.dart';

/// Single-source data panel (Simulation or Hardware) shown inside the detail sheet.
class DeviceDataPanel extends StatelessWidget {
  const DeviceDataPanel({
    super.key,
    required this.label,
    required this.accentColor,
    required this.data,
    required this.textColor,
    required this.hintColor,
    required this.noDataText,
    required this.statusLabel,
    required this.wattsLabel,
    required this.kwhLabel,
    required this.voltsLabel,
    required this.ampsLabel,
  });

  final String     label;
  final Color      accentColor;
  final DeviceData? data;
  final Color      textColor;
  final Color      hintColor;
  final String     noDataText;
  final String     statusLabel;
  final String     wattsLabel;
  final String     kwhLabel;
  final String     voltsLabel;
  final String     ampsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
          SizedBox(height: 8.h),
          if (data == null)
            Text(
              noDataText,
              style: TextStyle(fontSize: 10.sp, color: hintColor),
            )
          else ...[
            _DataRow(
              statusLabel,
              data!.isOn ? 'ON' : 'OFF',
              textColor,
              hintColor,
              bold: true,
              valueColor:
                  data!.isOn ? SHColors.success(context) : hintColor,
            ),
            if (data!.watts != null)
              _DataRow(wattsLabel, '${data!.watts!.toStringAsFixed(1)} W',
                  textColor, hintColor),
            if (data!.kwh != null)
              _DataRow(kwhLabel, data!.kwh!.toStringAsFixed(3),
                  textColor, hintColor),
            if (data!.volts != null)
              _DataRow(voltsLabel,
                  '${data!.volts!.toStringAsFixed(1)} V', textColor, hintColor),
            if (data!.amps != null)
              _DataRow(ampsLabel,
                  '${data!.amps!.toStringAsFixed(2)} A', textColor, hintColor),
          ],
        ],
      ),
    );
  }
}

// ── Labelled key/value row ────────────────────────────────────────────────────

class _DataRow extends StatelessWidget {
  const _DataRow(
    this.label,
    this.value,
    this.textColor,
    this.hintColor, {
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color  textColor;
  final Color  hintColor;
  final bool   bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 10.5.sp, color: hintColor)),
          Text(
            value,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? textColor,
            ),
          ),
        ],
      ),
    );
  }
}
