// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core.dart';

class SHCard extends StatelessWidget {
  const SHCard({
    super.key,
    this.height,
    this.children = const [],
    this.childrenPadding = EdgeInsets.zero,
  });

  final double? height;
  final List<Widget> children;
  final EdgeInsets childrenPadding;

  @override
  Widget build(BuildContext context) {
    final isDark       = Theme.of(context).brightness == Brightness.dark;
    final cardGradient = isDark ? SHColors.darkCardGradient : SHColors.lightCardGradient;

    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: cardGradient,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < children.length; i++) ...[
              Padding(padding: childrenPadding, child: children[i]),
              if (i < children.length - 1) const SHDivider(),
            ],
          ],
        ),
      ),
    );
  }
}
