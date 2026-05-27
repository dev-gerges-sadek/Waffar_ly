// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';

/// Live hardware sensor streaming banner.
/// The [color] is always passed from the parent (resolved via SHColors) —
/// no raw Colors.* usage in this file.
class HwLiveBanner extends StatelessWidget {
  const HwLiveBanner({
    super.key,
    required this.count,
    required this.color,
  });

  final int   count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = l10n.isArabic
        ? 'يعمل $count ${count > 1 ? 'مستشعرات أجهزة' : 'مستشعر جهاز'} مباشرةً'
        : '$count hardware sensor${count > 1 ? 's' : ''} streaming live';

    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 0),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Row(
        children: [
          Icon(Icons.sensors_rounded, color: color, size: 15.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          _PulsingDot(color: color),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});
  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _ctrl,
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: widget.color),
        ),
      );
}
