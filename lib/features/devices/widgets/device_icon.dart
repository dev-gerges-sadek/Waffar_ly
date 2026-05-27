import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import '../../../core/theme/sh_colors.dart';
import '../models/device_model.dart';

class DeviceIcon extends StatelessWidget {
  const DeviceIcon({
    super.key,
    required this.type,
    required this.isOn,
    required this.hwOnline,
    required this.primary,
    required this.hint,
  });

  final DeviceType type;
  final bool isOn, hwOnline;
  final Color primary, hint;

  @override
  Widget build(BuildContext context) {
    final success = SHColors.success(context);
    final card    = SHColors.card(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOn ? primary.withOpacity(0.15) : hint.withOpacity(0.1),
            border: hwOnline
                ? Border.all(
                    color: success.withOpacity(0.6),
                    width: 1.5,
                  )
                : null,
          ),
          child: Icon(iconFor(type),
              color: isOn ? primary : hint, size: 22.sp),
        ),
        if (hwOnline)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 9.w,
              height: 9.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: success,
                border: Border.all(color: card, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  static IconData iconFor(DeviceType t) => switch (t) {
        DeviceType.lamp    => Icons.lightbulb_outline,
        DeviceType.fan     => Icons.air,
        DeviceType.ac      => Icons.ac_unit,
        DeviceType.tv      => Icons.tv,
        DeviceType.washer  => Icons.local_laundry_service,
        DeviceType.fridge  => Icons.kitchen,
        DeviceType.heater  => Icons.whatshot_outlined,
        DeviceType.speaker => Icons.speaker,
      };
}
