// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:intl/intl.dart';

import '../../../core/theme/sh_colors.dart';
import '../cubit/devices_cubit.dart';
import '../models/device_model.dart';

/// Bottom sheet يعرض تفاصيل جهاز واحد مع Simulation و Hardware
void showDeviceDetailSheet(BuildContext context, DeviceModel device) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<DevicesCubit>(),
      child: _DeviceDetailSheet(device: device),
    ),
  );
}

class _DeviceDetailSheet extends StatelessWidget {
  const _DeviceDetailSheet({required this.device});
  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? SHColors.darkCardColor : SHColors.lightCardColor;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary = SHColors.primary(context);
    final amber =
        isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;
    final isOn = device.simulationData?.isOn ?? false;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, scroll) => Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: ListView(
          controller: scroll,
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
          children: [
            // Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: hintColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // ── Device header ──────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOn
                        ? primary.withOpacity(0.15)
                        : hintColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    _iconFor(device.type),
                    color: isOn ? primary : hintColor,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isOn
                                  ? Colors.greenAccent.shade400
                                  : hintColor.withOpacity(0.5),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            isOn ? 'Online · ON' : 'Offline · OFF',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isOn
                                  ? Colors.greenAccent.shade400
                                  : hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Toggle
                Transform.scale(
                  scale: 0.9,
                  child: Switch.adaptive(
                    value: isOn,
                    activeColor: primary,
                    onChanged: (val) {
                      context.read<DevicesCubit>().toggleDevice(device.id, val);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // ── Two-column data panels ────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DataPanel(
                    label: 'Simulation',
                    accentColor: primary,
                    data: device.simulationData,
                    textColor: textColor,
                    hintColor: hintColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _DataPanel(
                    label: 'Hardware',
                    accentColor: amber,
                    data: device.hardwareData,
                    textColor: textColor,
                    hintColor: hintColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // ── Last updated ──────────────────────────────────────────
            if (device.simulationData?.lastUpdated != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.update_rounded, size: 12, color: hintColor),
                  SizedBox(width: 4.w),
                  Text(
                    'Last updated: ${DateFormat('MMM d, HH:mm').format(
                      device.simulationData!.lastUpdated!.toLocal(),
                    )}',
                    style: TextStyle(fontSize: 10.sp, color: hintColor),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(DeviceType type) {
    switch (type) {
      case DeviceType.lamp:
        return Icons.lightbulb_outline;
      case DeviceType.fan:
        return Icons.air;
      case DeviceType.ac:
        return Icons.ac_unit;
      case DeviceType.tv:
        return Icons.tv;
      case DeviceType.washer:
        return Icons.local_laundry_service;
      case DeviceType.fridge:
        return Icons.kitchen;
      case DeviceType.heater:
        return Icons.whatshot_outlined;
      case DeviceType.speaker:
        return Icons.speaker;
    }
  }
}

// ─── Data panel (Simulation or Hardware) ──────────────────────────────────────
class _DataPanel extends StatelessWidget {
  const _DataPanel({
    required this.label,
    required this.accentColor,
    required this.data,
    required this.textColor,
    required this.hintColor,
  });

  final String label;
  final Color accentColor;
  final DeviceData? data;
  final Color textColor;
  final Color hintColor;

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
          // Panel label
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: data != null ? accentColor : hintColor,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          if (data == null) ...[
            Icon(Icons.cloud_off_outlined, size: 22, color: hintColor),
            SizedBox(height: 4.h),
            Text(
              'No data yet',
              style: TextStyle(fontSize: 10.sp, color: hintColor),
            ),
          ] else ...[
            _Row('Status', data!.status, textColor, hintColor,
                bold: true,
                valueColor:
                    data!.isOn ? Colors.greenAccent.shade400 : hintColor),
            if (data!.watts != null)
              _Row('Watts', '${data!.watts!.toStringAsFixed(1)} W', textColor,
                  hintColor),
            if (data!.kwh != null)
              _Row('kWh', data!.kwh!.toStringAsFixed(3), textColor, hintColor),
            if (data!.volts != null)
              _Row('Volts', '${data!.volts!.toStringAsFixed(1)} V', textColor,
                  hintColor),
            if (data!.amps != null)
              _Row('Amps', '${data!.amps!.toStringAsFixed(2)} A', textColor,
                  hintColor),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(
    this.label,
    this.value,
    this.textColor,
    this.hintColor, {
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color textColor;
  final Color hintColor;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10.5.sp, color: hintColor),
          ),
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
