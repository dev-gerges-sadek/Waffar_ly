import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/sh_colors.dart';

/// Animated three-dot typing indicator shown while AI is processing.
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key, required this.cardColor});
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final primary = SHColors.primary(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundColor: primary.withOpacity(0.15),
            child: Icon(Icons.smart_toy_rounded, color: primary, size: 14),
          ),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _BounceDot(delay: i * 200)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BounceDot extends StatefulWidget {
  const _BounceDot({required this.delay});
  final int delay;

  @override
  State<_BounceDot> createState() => _BounceDotState();
}

class _BounceDotState extends State<_BounceDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 7.w,
        height: 7.w,
        margin: EdgeInsetsDirectional.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SHColors.hint(context),
        ),
      ),
    );
  }
}
