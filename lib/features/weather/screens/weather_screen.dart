// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../cubit/weather_cubit.dart';
import '../cubit/weather_states.dart';
import '../models/weather_model.dart';
import '../widgets/weather_forecast_card.dart';
import '../widgets/weather_search_bar.dart';
import '../widgets/predictive_comfort_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(),
      child: const _WeatherView(),
    );
  }
}

class _WeatherView extends StatelessWidget {
  const _WeatherView();

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final bg        = SHColors.background(context);
    final primary   = SHColors.primary(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: isDark
                ? SHColors.darkBackgroundColor
                : SHColors.lightBackgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: textColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Weather',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(56.h),
              child: const WeatherSearchBar(),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 300.h, maxHeight: MediaQuery.of(context).size.height * 0.6),
                    child: Center(
                      child: CircularProgressIndicator(color: primary),
                    ),
                  );
                }

                if (state is WeatherFailure) {
                  return _ErrorView(message: state.message);
                }

                if (state is WeatherInitial) {
                  return _EmptyView(hintColor: hintColor, primary: primary);
                }

                if (state is WeatherSuccess) {
                  return _WeatherContent(forecasts: state.forecasts);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Weather content ──────────────────────────────────────────────────────────
class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.forecasts});
  final List<WeatherModel> forecasts;

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location header
          Row(
            children: [
              Icon(Icons.location_on_rounded,
                  color: SHColors.primary(context), size: 18),
              SizedBox(width: 4.w),
              Text(
                '${forecasts.first.cityName}, ${forecasts.first.country}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ── 3-day forecast cards ─────────────────────────────────────────
          Text(
            '3-DAY FORECAST',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: hintColor,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10.h),
          ...forecasts.map(
            (w) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: WeatherForecastCard(weather: w),
            ),
          ),

          // ── Predictive Comfort (AC recommendation) ───────────────────────
          if (forecasts.first.acRecommendation != null) ...[
            SizedBox(height: 6.h),
            PredictiveComfortCard(weather: forecasts.first),
          ],

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.hintColor, required this.primary});
  final Color hintColor;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 280.h, maxHeight: MediaQuery.of(context).size.height * 0.55),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny_outlined, size: 56, color: hintColor),
            SizedBox(height: 12.h),
            Text(
              'Search for a city to see the weather',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 200.h, maxHeight: MediaQuery.of(context).size.height * 0.4),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded,
                  size: 48, color: SHColors.hint(context)),
              SizedBox(height: 12.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.sp,
                    color: SHColors.hint(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
