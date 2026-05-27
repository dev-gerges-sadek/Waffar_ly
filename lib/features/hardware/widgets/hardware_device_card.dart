import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../models/hardware_device.dart';

class HardwareDeviceCard extends StatelessWidget {
  const HardwareDeviceCard({
    super.key,
    required this.device,
  });

  final HardwareDevice device;

  Color get _statusColor {
    switch (device.connectionStatus) {
      case 'Connected':
        return Colors.green;
      case 'Reconnecting':
        return Colors.orange;
      case 'Disconnected':
      default:
        return Colors.red;
    }
  }

  String get _statusEmoji {
    switch (device.connectionStatus) {
      case 'Connected':
        return '✅';
      case 'Reconnecting':
        return '🟠';
      case 'Disconnected':
      default:
        return '🔴';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = SHColors.card(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _statusColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header with status ─────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.displayName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      device.source,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _statusEmoji,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      device.connectionStatus,
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: _statusColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // ── Telemetry grid ────────────────────────────────────────────
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: 1.2,
            children: [
              _TelemetryCell(
                label: 'Voltage',
                value: device.voltage.toStringAsFixed(1),
                unit: 'V',
                isDark: isDark,
              ),
              _TelemetryCell(
                label: 'Current',
                value: device.current.toStringAsFixed(2),
                unit: 'A',
                isDark: isDark,
              ),
              _TelemetryCell(
                label: 'Power',
                value: device.power.toStringAsFixed(1),
                unit: 'W',
                isDark: isDark,
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // ── Last update info ───────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status: ${device.status}',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: hintColor,
                ),
              ),
              Text(
                'Updated: ${_formatTime(device.lastUpdate)}',
                style: TextStyle(
                  fontSize: 8.sp,
                  color: hintColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else {
      return '${diff.inHours}h ago';
    }
  }
}

class _TelemetryCell extends StatelessWidget {
  const _TelemetryCell({
    required this.label,
    required this.value,
    required this.unit,
    required this.isDark,
  });

  final String label;
  final String value;
  final String unit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 7.sp,
              fontWeight: FontWeight.w600,
              color: hintColor,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: TextStyle(
                    fontSize: 6.sp,
                    fontWeight: FontWeight.w500,
                    color: hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
