import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/ai_result.dart';

class AiSeverityBadge extends StatelessWidget {
  const AiSeverityBadge({
    super.key,
    required this.severity,
    required this.aiDecision,
  });

  final AiSeverity severity;
  final String aiDecision;

  Color get _backgroundColor {
    switch (severity) {
      case AiSeverity.critical:
        return Colors.red.withOpacity(0.12);
      case AiSeverity.danger:
        return Colors.orange.withOpacity(0.12);
      case AiSeverity.warning:
        return Colors.amber.withOpacity(0.12);
      case AiSeverity.normal:
        return Colors.green.withOpacity(0.12);
    }
  }

  Color get _textColor {
    switch (severity) {
      case AiSeverity.critical:
        return Colors.red;
      case AiSeverity.danger:
        return Colors.orange;
      case AiSeverity.warning:
        return Colors.amber;
      case AiSeverity.normal:
        return Colors.green;
    }
  }

  String get _emoji {
    switch (severity) {
      case AiSeverity.critical:
        return '🔴';
      case AiSeverity.danger:
        return '🚨';
      case AiSeverity.warning:
        return '⚠️';
      case AiSeverity.normal:
        return '✅';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _textColor.withOpacity(0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_emoji, style: TextStyle(fontSize: 14.sp)),
          SizedBox(width: 6.w),
          Text(
            aiDecision.toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: _textColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
