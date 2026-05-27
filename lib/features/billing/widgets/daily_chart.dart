import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../cubit/billing_states.dart';

class DailyChartWidget extends StatelessWidget {
  const DailyChartWidget({
    super.key,
    required this.dailyData,
  });

  final List<DailyCost> dailyData;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final cardColor = SHColors.card(context);

    final maxCost =
        dailyData.map((d) => d.cost).reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 7 Days',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          SizedBox(height: 16.h),

          // ── Bar chart ──────────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: dailyData.map((day) {
                    final barHeight = (day.cost / maxCost) * 150.h;
                    return Column(
                      children: [
                        // Bar
                        Container(
                          width: 30.w,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        // Label
                        Text(
                          day.dayOfWeek,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: hintColor,
                          ),
                        ),
                        Text(
                          '${day.cost.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: hintColor,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // ── Data table ─────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: dailyData.map((day) {
                final isLast = dailyData.last == day;
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day.dayOfWeek,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                '${day.date.day}/${day.date.month}/${day.date.year}',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: hintColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${day.cost.toStringAsFixed(2)} EGP',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '${day.kwh.toStringAsFixed(1)} kWh',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: hintColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: 12.w,
                        endIndent: 12.w,
                        color: hintColor.withOpacity(0.2),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
