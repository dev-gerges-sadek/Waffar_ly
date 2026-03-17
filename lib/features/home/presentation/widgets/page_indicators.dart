import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/domain/entities/smart_room.dart';
import '../../../../core/theme/sh_colors.dart';

class PageIndicators extends StatelessWidget {
  const PageIndicators({
    super.key,
    required this.roomSelectorNotifier,
    required this.pageNotifier,
  });

  final ValueNotifier<int>    roomSelectorNotifier;
  final ValueNotifier<double> pageNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: roomSelectorNotifier,
      builder: (_, value, child) => AnimatedOpacity(
        opacity: value != -1 ? 0 : 1,
        duration: value != -1
            ? const Duration(milliseconds: 1)
            : const Duration(milliseconds: 400),
        child: child,
      ),
      child: ValueListenableBuilder<double>(
        valueListenable: pageNotifier,
        builder: (_, value, _) => Center(
          child: PageViewIndicators(
            length: SmartRoom.fakeValues.length,
            pageIndex: value,
          ),
        ),
      ),
    );
  }
}

class PageViewIndicators extends StatelessWidget {
  const PageViewIndicators({
    required this.length,
    required this.pageIndex,
    super.key,
  });

  final int    length;
  final double pageIndex;

  @override
  Widget build(BuildContext context) {
    // ✅ theme-aware colors
    final primaryColor = SHColors.primary(context);
    final bgColor      = SHColors.background(context);
    final trackColor   = SHColors.track(context);

    return SizedBox(
      height: 12.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < length; i++) ...[
                _Dot(trackColor: trackColor),
                if (i < length - 1) SizedBox(width: 16.w),
              ],
            ],
          ),
          Positioned(
            left: (16.w * pageIndex) + (6.w * pageIndex),
            child: _BorderDot(
              primaryColor: primaryColor,
              bgColor: bgColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _BorderDot extends StatelessWidget {
  const _BorderDot({
    required this.primaryColor,
    required this.bgColor,
  });

  final Color primaryColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12.w,
      height: 12.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 2), // ✅
          color: bgColor,                                     // ✅
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.trackColor});
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 6.w,
      height: 6.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: trackColor, // ✅
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
