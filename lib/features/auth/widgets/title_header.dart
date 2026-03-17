// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:waffar_ly_app/core/helper/extensions/media_query.dart';


class TitleHeaderWidget extends StatelessWidget {
  const TitleHeaderWidget({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary   = Theme.of(context).colorScheme.primary;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Welcome to ',
            style: TextStyle(
              fontSize: context.sp(20),
              color: onSurface, // ✅ theme-aware بدل hardcoded white
            ),
          ),
          TextSpan(
            text: 'Waffar\n', // ✅ إصلاح: كان "DO IT"
            style: TextStyle(
              fontSize: context.sp(20),
              fontWeight: FontWeight.bold,
              color: primary, // ✅ اسم التطبيق بلون primary
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: context.sp(14),
              color: onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
