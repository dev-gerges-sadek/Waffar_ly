// ============================================================================
// section_divider.dart
// Thin gradient divider used to separate dashboard sections.
// ============================================================================

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/sh_colors.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: 4.h),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              SHColors.hint(context).withOpacity(0.15),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
