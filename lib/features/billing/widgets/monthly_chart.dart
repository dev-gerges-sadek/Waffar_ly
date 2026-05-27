import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../cubit/billing_states.dart';

class MonthlyChartWidget extends StatelessWidget {
  const MonthlyChartWidget({
    super.key,
    required this.monthlyData,
  });

  final List<MonthlyCost> monthlyData;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final cardColor = SHColors.card(context);

    final maxCost =
        monthlyData.map((m) => m.cost).reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 12 Months',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          SizedBox(height: 16.h),

          // ── Line chart representation with bars ─────────────────────
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: monthlyData.map((month) {
                  final barHeight = (month.cost / maxCost) * 150.h;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        Container(
                          width: 20.w,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          month.displayMonth.split(' ')[0],
                          style: TextStyle(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w600,
                            color: hintColor,
                          ),
                        ),
                        Text(
                          '${month.cost.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: hintColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
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
              children: monthlyData.map((month) {
                final isLast = monthlyData.last == month;
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
                                month.displayMonth,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'Month ${monthlyData.indexOf(month) + 1} of 12',
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
                                '${month.cost.toStringAsFixed(2)} EGP',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                '${month.kwh.toStringAsFixed(0)} kWh',
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
