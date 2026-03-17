// ignore_for_file: deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core.dart';

class SHSwitcher extends StatelessWidget {
  const SHSwitcher({
    required this.value,
    required this.onChanged,
    this.icon,
    super.key,
  });

  final bool value;
  final Icon? icon;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDarkMode ? SHColors.darkPrimaryColor : SHColors.lightPrimaryColor;
    final hintColor =
        isDarkMode ? SHColors.darkHintColor : SHColors.lightHintColor;
    final trackColor =
        isDarkMode ? SHColors.darkTrackColor : SHColors.lightTrackColor;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: value ? primaryColor : hintColor,
              ),
              child: icon!,
            ),
            const SizedBox(width: 8),
          ],
          CupertinoSwitch(
            trackColor: trackColor,
            activeColor: primaryColor,
            thumbColor: value ? null : hintColor,
            value: value,
            onChanged: onChanged,
          ),
          const SizedBox(width: 8),
          Text(
            value ? 'ON' : 'OFF',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: value ? primaryColor : hintColor,
            ),
          )
        ],
      ),
    );
  }
}
