// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;

import '../../../core/theme/sh_colors.dart';
import '../cubit/devices_cubit.dart';
import '../models/device_model.dart';
import 'device_data_badge.dart';
import 'device_detail_sheet.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.device});

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = SHColors.card(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary = SHColors.primary(context);
    final isOn = device.simulationData?.isOn ?? false;

    return GestureDetector(
      onTap: () => showDeviceDetailSheet(context, device),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isOn ? primary.withOpacity(0.45) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.black12).withOpacity(
                isDark ? 0.25 : 0.1,
              ),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon row ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOn
                          ? primary.withOpacity(0.15)
                          : hintColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      _iconForType(device.type),
                      color: isOn ? primary : hintColor,
                      size: 22.sp,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch.adaptive(
                      value: isOn,
                      activeColor: primary,
                      onChanged: (val) => context
                          .read<DevicesCubit>()
                          .toggleDevice(device.id, val),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),

              // ── Name + status ─────────────────────────────────────────
              Text(
                device.name,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOn
                          ? Colors.greenAccent.shade400
                          : hintColor.withOpacity(0.4),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    isOn ? 'ON' : 'OFF',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: isOn ? Colors.greenAccent.shade400 : hintColor,
                    ),
                  ),
                  // Watts if available
                  if (device.simulationData?.watts != null) ...[
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        '·  ${device.simulationData!.watts!.toStringAsFixed(0)} W',
                        style: TextStyle(fontSize: 10.sp, color: hintColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 8.h),

              // ── Simulation + Hardware badges ──────────────────────────
              LimitedBox(
                maxHeight: 100.h,
                child: Row(
                  children: [
                    Expanded(
                      child: DeviceDataBadge(
                        tag: DataSourceTag.simulation,
                        data: device.simulationData,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: DeviceDataBadge(
                        tag: DataSourceTag.hardware,
                        data: device.hardwareData,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Tap hint ──────────────────────────────────────────────
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 11,
                    color: hintColor.withOpacity(0.5),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'tap for details',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: hintColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(DeviceType type) {
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
