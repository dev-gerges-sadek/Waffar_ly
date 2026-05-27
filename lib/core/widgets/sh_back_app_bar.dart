// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/sh_colors.dart';

/// A reusable back-navigating AppBar used across feature screens.
/// Supports an optional trailing widget (e.g. settings icon, live badge).
class ShBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShBackAppBar({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      backgroundColor: isDark
          ? SHColors.darkBackgroundColor
          : SHColors.lightBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          isRtl
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded,
          color: textColor,
          size: 20.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
      actions: [
        trailing != null ? trailing! : SizedBox(width: 4.w),
        SizedBox(width: 4.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 2.h);
}
