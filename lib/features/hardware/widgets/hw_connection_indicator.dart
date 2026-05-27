// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../models/hardware_device.dart';

class HwConnectionIndicator extends StatelessWidget {
  const HwConnectionIndicator({super.key, required this.status});
  final HwConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context);
    final color = _color(context, status);
    final label = _label(l10n, status);
    final icon  = _icon(status);

    return Container(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          status == HwConnectionStatus.reconnecting
              ? SizedBox(
                  width: 10.w,
                  height: 10.w,
                  child: CircularProgressIndicator(
                      strokeWidth: 1.5, color: color),
                )
              : Icon(icon, size: 10.sp, color: color),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _color(BuildContext context, HwConnectionStatus s) => switch (s) {
        HwConnectionStatus.connected    => SHColors.severity(context, 'normal'),
        HwConnectionStatus.disconnected => SHColors.severity(context, 'critical'),
        HwConnectionStatus.reconnecting => SHColors.severity(context, 'warning'),
      };

  String _label(AppLocalizations l10n, HwConnectionStatus s) => switch (s) {
        HwConnectionStatus.connected    => l10n.online,
        HwConnectionStatus.disconnected => l10n.offline,
        HwConnectionStatus.reconnecting => l10n.loading,
      };

  IconData _icon(HwConnectionStatus s) => switch (s) {
        HwConnectionStatus.connected    => Icons.wifi_rounded,
        HwConnectionStatus.disconnected => Icons.wifi_off_rounded,
        HwConnectionStatus.reconnecting => Icons.wifi_find_rounded,
      };
}
