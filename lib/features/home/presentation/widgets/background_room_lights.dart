// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/core.dart';

class BackgroundRoomCard extends StatelessWidget {
  const BackgroundRoomCard({
    required this.room,
    required this.translation,
    super.key,
  });

  final SmartRoom room;
  final double translation;

  @override
  Widget build(BuildContext context) {
    final cardColor = SHColors.card(context);

    return Transform(
      transform: Matrix4.translationValues(0, 80 * translation, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(-7, 7)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RoomInfoRow(
              icon: const Icon(SHIcons.thermostat),
              label: const Text('Temperature'),
              data: '${room.temperature}°',
            ),
            SizedBox(height: 4.h),
            _RoomInfoRow(
              icon: const Icon(SHIcons.waterDrop),
              label: const Text('Air Humidity'),
              data: '${room.airHumidity}%',
            ),
            SizedBox(height: 4.h),
            const _RoomInfoRow(
              icon: Icon(SHIcons.timer),
              label: Text('Timer'),
              data: null,
            ),
            SizedBox(height: 12.h),
            const SHDivider(),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _DeviceIconSwitcher(
                    onTap: (_) {},
                    icon: const Icon(SHIcons.lightBulbOutline),
                    label: const Text('Lights'),
                    value: room.lights.isOn,
                  ),
                  _DeviceIconSwitcher(
                    onTap: (_) {},
                    icon: const Icon(SHIcons.fan),
                    label: const Text('Air-con'),
                    value: room.airCondition.isOn,
                  ),
                  _DeviceIconSwitcher(
                    onTap: (_) {},
                    icon: const Icon(SHIcons.music),
                    label: const Text('Music'),
                    value: room.musicInfo.isOn,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Device Icon Switcher ─────────────────────────────────────────────────────
class _DeviceIconSwitcher extends StatelessWidget {
  const _DeviceIconSwitcher({
    required this.onTap,
    required this.label,
    required this.icon,
    required this.value,
  });

  final Text label;
  final Icon icon;
  final bool value;
  final ValueChanged<bool> onTap;

  @override
  Widget build(BuildContext context) {
    final color = value ? SHColors.primary(context) : SHColors.text(context);

    return InkWell(
      onTap: () => onTap(!value),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(color: color, size: 22.sp),
              child: icon,
            ),
            SizedBox(height: 4.h),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 10.sp,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              child: label,
            ),
            Text(
              value ? 'ON' : 'OFF',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 9.sp,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Room Info Row ────────────────────────────────────────────────────────────
class _RoomInfoRow extends StatelessWidget {
  const _RoomInfoRow({
    required this.icon,
    required this.label,
    required this.data,
  });

  final Icon icon;
  final Text label;
  final String? data;

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          IconTheme(
            data: IconThemeData(size: 16.sp, color: hintColor),
            child: icon,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 11.sp,
                color: data == null ? textColor.withOpacity(0.6) : hintColor,
              ),
              child: label,
            ),
          ),
          if (data != null)
            Text(
              data!,
              style: GoogleFonts.montserrat(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BlueLightDot(),
                SizedBox(width: 4.w),
                Text(
                  'OFF',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w800,
                    fontSize: 11.sp,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
