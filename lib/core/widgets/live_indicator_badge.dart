import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/sh_colors.dart';

/// Reusable "Live" or "Monitoring" pill badge used in AppBar actions.
/// All colours are resolved from [SHColors] / theme — zero hardcoded hex.
class LiveIndicatorBadge extends StatelessWidget {
  const LiveIndicatorBadge({super.key, this.label = 'Live'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final success = Theme.of(context).brightness == Brightness.dark
        ? SHColors.darkSuccessColor
        : SHColors.lightSuccessColor;

    return Container(
      margin: EdgeInsetsDirectional.only(end: 12.w),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 10.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: success.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 7, color: success),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
