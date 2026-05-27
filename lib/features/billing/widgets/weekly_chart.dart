import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../cubit/billing_states.dart';

class WeeklyChartWidget extends StatelessWidget {
  const WeeklyChartWidget({
    super.key,
    required this.weeklyData,
  });

  final List<WeeklyCost> weeklyData;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final cardColor = SHColors.card(context);

    final maxCost =
        weeklyData.map((w) => w.cost).reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 4 Weeks',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeklyData.map((week) {
                final barHeight = (week.cost / maxCost) * 150.h;
                return Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'W${weeklyData.indexOf(week) + 1}',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: hintColor,
                      ),
                    ),
                    Text(
                      '${week.cost.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: hintColor,
                      ),
                    ),
                  ],
                );
              }).toList(),
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
              children: weeklyData.map((week) {
                final isLast = weeklyData.last == week;
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
                                'Week ${weeklyData.indexOf(week) + 1}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                week.displayWeek,
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
                                '${week.cost.toStringAsFixed(2)} EGP',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                '${week.kwh.toStringAsFixed(1)} kWh',
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
