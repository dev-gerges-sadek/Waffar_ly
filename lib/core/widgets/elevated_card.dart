// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/sh_colors.dart';

/// Themed card container with subtle shadow, used as a layout wrapper.
class ElevatedCard extends StatelessWidget {
  const ElevatedCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: SHColors.card(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: SHColors.lightShadowColor),
        boxShadow: [
          BoxShadow(
            color: SHColors.lightShadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
