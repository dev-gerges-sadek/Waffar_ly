// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../../../weather/cubit/weather_cubit.dart';
import '../../../weather/cubit/weather_states.dart';

/// Top row on HomeScreen: weather chip (left) + live dot (right).
class HomeInfoRow extends StatelessWidget {
  const HomeInfoRow({super.key, required this.onWeatherTap});

  final VoidCallback onWeatherTap;

  @override
  Widget build(BuildContext context) {
    final primary = SHColors.primary(context);
    final textColor = SHColors.text(context);

    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        String feelsLikeLabel = AppLocalizations.of(context).weather;
        if (state is WeatherSuccess && state.forecasts.isNotEmpty) {
          feelsLikeLabel =
              '${AppLocalizations.of(context).weather}  ${state.forecasts.first.feelsLike.toInt()}°C';
        }

        return Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              // Weather chip
              GestureDetector(
                onTap: onWeatherTap,
                child: Container(
                  padding:
                      EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: SHColors.warning(context).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                        color: SHColors.warning(context).withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wb_sunny_outlined,
                          color: SHColors.warning(context), size: 15.sp),
                      SizedBox(width: 5.w),
                      Text(
                        feelsLikeLabel,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: SHColors.warning(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Live dot
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary,
                  boxShadow: [
                    BoxShadow(
                        color: primary.withOpacity(0.45), blurRadius: 6),
                  ],
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                'Live',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
