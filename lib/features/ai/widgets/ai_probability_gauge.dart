import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiProbabilityGauge extends StatelessWidget {
  const AiProbabilityGauge({
    super.key,
    required this.anomalyProb,
    required this.normalProb,
  });

  final double anomalyProb;
  final double normalProb;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final backgroundColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.08);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title ──────────────────────────────────────────────────────────
        Text(
          'Detection Probability',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 10.h),

        // ── Normal gauge ───────────────────────────────────────────────────
        Row(
          children: [
            Text(
              '✅ Normal',
              style: TextStyle(fontSize: 10.sp, color: Colors.green),
            ),
            const Spacer(),
            Text(
              '${normalProb.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            minHeight: 8.h,
            value: normalProb / 100.0,
            backgroundColor: backgroundColor,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),

        SizedBox(height: 12.h),

        // ── Anomaly gauge ─────────────────────────────────────────────────
        Row(
          children: [
            Text(
              '🚨 Anomaly',
              style: TextStyle(fontSize: 10.sp, color: Colors.orange),
            ),
            const Spacer(),
            Text(
              '${anomalyProb.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            minHeight: 8.h,
            value: anomalyProb / 100.0,
            backgroundColor: backgroundColor,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
      ],
    );
  }
}
