import '../../../core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../models/weather_model.dart';

class PredictiveComfortCard extends StatelessWidget {
  const PredictiveComfortCard({super.key, required this.weather});
  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = SHColors.primary(context);
    final warning = isDark
        ? SHColors.darkWarningColor
        : SHColors.lightWarningColor;

    final isHot = weather.isHot;
    final acColor = isHot ? warning : primary;
    final bgColor = acColor.withValues(alpha: 0.08);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: acColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: acColor.withValues(alpha: 0.15),
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
                  AppLocalizations.of(context).predictiveComfort,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: acColor,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  switch (weather.acRecommendation) {
                    AcAdvice.veryHot => AppLocalizations.of(context).acAdviceVeryHot,
                    AcAdvice.warm => AppLocalizations.of(context).acAdviceWarm,
                    AcAdvice.cold => AppLocalizations.of(context).acAdviceCold,
                    null => '',
                  },
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: SHColors.text(context).withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Outside temp badge
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 8.w,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: acColor.withValues(alpha: 0.15),
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
