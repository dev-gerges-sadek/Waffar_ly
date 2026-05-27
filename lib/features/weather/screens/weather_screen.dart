import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../cubit/weather_cubit.dart';
import '../cubit/weather_states.dart';
import '../models/weather_model.dart';
import '../widgets/predictive_comfort_card.dart';
import '../widgets/weather_forecast_card.dart';
import '../widgets/weather_search_bar.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => WeatherCubit(),
        child: const _WeatherView(),
      );
}

class _WeatherView extends StatelessWidget {
  const _WeatherView();

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);

    return Scaffold(
      backgroundColor: SHColors.background(context),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ────────────────────────────────────────────────
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
              l10n.weather,
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

          // ── Body ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: BlocBuilder<WeatherCubit, WeatherState>(
              builder: (_, state) {
                if (state is WeatherLoading) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 300.h,
                        maxHeight:
                            MediaQuery.of(context).size.height * 0.6),
                    child: const LoadingView(),
                  );
                }
                if (state is WeatherFailure) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 200.h,
                        maxHeight:
                            MediaQuery.of(context).size.height * 0.4),
                    child: ErrorView(
                        icon: Icons.cloud_off_rounded,
                        message: state.message),
                  );
                }
                if (state is WeatherInitial) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 280.h,
                        maxHeight:
                            MediaQuery.of(context).size.height * 0.55),
                    child: EmptyStateView(
                        icon: Icons.wb_sunny_outlined,
                        label: l10n.searchForCity),
                  );
                }
                if (state is WeatherSuccess) {
                  return _WeatherContent(
                      forecasts: state.forecasts, l10n: l10n);
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

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({
    required this.forecasts,
    required this.l10n,
  });

  final List<WeatherModel> forecasts;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary   = SHColors.primary(context);

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location header
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: primary, size: 18),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  '${forecasts.first.cityName}, ${forecasts.first.country}',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Section label
          Text(
            l10n.forecast3Day.toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: hintColor,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10.h),

          // Forecast cards
          ...forecasts.map((w) => Padding(
                padding: EdgeInsetsDirectional.only(bottom: 10.h),
                child: WeatherForecastCard(weather: w),
              )),

          // Predictive comfort
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
