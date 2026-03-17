// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../models/weather_model.dart';

class WeatherForecastCard extends StatelessWidget {
  const WeatherForecastCard({super.key, required this.weather});
  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final cardColor = SHColors.card(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary   = SHColors.primary(context);

    // Color based on temperature
    final tempColor = weather.isHot
        ? Colors.orange
        : weather.isCold
            ? Colors.blue.shade300
            : primary;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Weather icon
          Image.network(
            weather.iconUrl,
            width: 48.w,
            height: 48.w,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) =>
                Icon(Icons.wb_sunny_outlined, color: primary, size: 40),
          ),
          SizedBox(width: 12.w),

          // Date + condition
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(weather.date),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  weather.condition,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                // Humidity + Wind
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.water_drop_outlined,
                      label: '${weather.humidity.toInt()}%',
                      color: Colors.blue.shade300,
                    ),
                    SizedBox(width: 8.w),
                    _StatChip(
                      icon: Icons.air,
                      label: '${weather.windKph.toInt()} km/h',
                      color: hintColor,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Temperature
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${weather.avgTemp.toInt()}°C',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: tempColor,
                ),
              ),
              Text(
                '${weather.minTemp.toInt()}° / ${weather.maxTemp.toInt()}°',
                style: TextStyle(fontSize: 10.sp, color: hintColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
    } catch (_) {
      return date;
    }
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        SizedBox(width: 3.w),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: color),
        ),
      ],
    );
  }
}
