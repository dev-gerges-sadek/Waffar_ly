// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../models/weather_model.dart';

class PredictiveComfortCard extends StatelessWidget {
  const PredictiveComfortCard({super.key, required this.weather});
  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final primary  = SHColors.primary(context);
    final warning  = isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;

    final isHot    = weather.isHot;
    final acColor  = isHot ? warning : primary;
    final bgColor  = acColor.withOpacity(0.08);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: acColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: acColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              isHot ? Icons.ac_unit : Icons.thermostat_rounded,
              color: acColor,
              size: 22,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Predictive Comfort',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: acColor,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  weather.acRecommendation ?? '',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: SHColors.text(context).withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Outside temp badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: acColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${weather.avgTemp.toInt()}°C\noutside',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: acColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
