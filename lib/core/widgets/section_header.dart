import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Uppercase section label used throughout the app (e.g. "AI RECOMMENDATION").
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: TextStyle(
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1.0,
        ),
      );
}
