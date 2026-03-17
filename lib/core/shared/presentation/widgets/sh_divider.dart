// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core.dart';

class SHDivider extends StatelessWidget {
  const SHDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode   = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDarkMode
        ? SHColors.darkDividerColor.withOpacity(0.3)
        : SHColors.lightDividerColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDarkMode ? SHColors.darkSurfaceColor : SHColors.lightSurfaceColor,
        boxShadow: [BoxShadow(blurRadius: 1, color: dividerColor, offset: const Offset(0, 1))],
      ),
      child: SizedBox(height: 1.r, width: double.infinity),
    );
  }
}
