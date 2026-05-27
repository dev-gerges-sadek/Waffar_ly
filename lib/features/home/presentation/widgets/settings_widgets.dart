// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/core/theme/sh_colors.dart';

/// Uppercase section label (e.g. "APPEARANCE", "LANGUAGE").
class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: SHColors.hint(context),
        letterSpacing: 0.8,
      ),
    );
  }
}

/// Animated language selection tile with flag, label, and check indicator.
class LanguageOption extends StatelessWidget {
  const LanguageOption({
    super.key,
    required this.label,
    required this.flag,
    required this.selected,
    required this.primaryColor,
    required this.onTap,
  });

  final String label;
  final String flag;
  final bool selected;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected
              ? primaryColor.withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected
                ? primaryColor.withOpacity(0.40)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 20.sp)),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? primaryColor : SHColors.text(context),
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded,
                  color: primaryColor, size: 18.sp),
          ],
        ),
      ),
    );
  }
}
