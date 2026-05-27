import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../models/device_model.dart';

class DeviceStatusRow extends StatelessWidget {
  const DeviceStatusRow({
    super.key,
    required this.device,
    required this.hintColor,
  });

  final DeviceModel device;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final data    = device.simulationData;
    final isOn    = device.isOn;
    final success = SHColors.success(context);
    final dot     = isOn ? success : hintColor.withOpacity(0.4);

    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dot),
        ),
        SizedBox(width: 4.w),
        Text(
          isOn ? l10n.powerOn : l10n.powerOff,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: isOn ? success : hintColor,
          ),
        ),
        if (data?.watts != null) ...[
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              '· ${data!.watts!.toStringAsFixed(0)} W',
              style: TextStyle(fontSize: 10.sp, color: hintColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}
