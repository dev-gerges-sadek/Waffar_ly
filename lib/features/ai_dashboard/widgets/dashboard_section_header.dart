// ============================================================================
// dashboard_section_header.dart
// Consistent section header with colored icon pill, title, and optional
// subtitle / action button. Used throughout the dashboard body.
// ============================================================================

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/sh_colors.dart';

class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final IconData icon;
  final Color color;

  /// Optional descriptive line rendered below the title pill.
  final String? subtitle;

  /// Optional right-side action button label.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Colored icon + title pill
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 12.sp, color: color),
                  SizedBox(width: 5.w),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Optional action button
            if (actionLabel != null && onAction != null)
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: color.withOpacity(0.20)),
                  ),
                  child: Text(
                    actionLabel!,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsetsDirectional.only(end: 4.w),
            child: Text(
              subtitle!,
              style: TextStyle(
                fontSize: 9.sp,
                color: SHColors.hint(context),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
