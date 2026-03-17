import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/core.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../weather/cubit/weather_cubit.dart';
import '../../../weather/cubit/weather_states.dart';
import '../../../weather/screens/weather_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../widgets/home_drawer.dart';
import '../widgets/lighted_background.dart';
import '../widgets/page_indicators.dart';
import '../widgets/smart_room_page_view.dart';
import '../widgets/sm_home_bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController          = PageController(viewportFraction: 0.8);
  final ValueNotifier<double> _pageNotifier         = ValueNotifier(0);
  final ValueNotifier<int>    _roomSelectorNotifier  = ValueNotifier(-1);
  final GlobalKey<ScaffoldState> _scaffoldKey        = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }

  void _onPageChanged() => _pageNotifier.value = _pageController.page ?? 0;

  void _navigateTo(Widget screen) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final textColor = SHColors.text(context);

    return BlocProvider(
      create: (_) => WeatherCubit(),
      child: LightedBackground(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          drawer: HomeDrawer(onNavigate: _navigateTo),
          appBar: ShAppBar(
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            onSettingsTap: () => _navigateTo(const SettingsScreen()),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 12.h),

                // ── Weather + Emergency row ────────────────────────────
                _HomeInfoRow(
                  onWeatherTap: () => _navigateTo(const WeatherScreen()),
                ),

                SizedBox(height: 14.h),

                // ── Section title ──────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.selectRoom.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // ── Room PageView ──────────────────────────────────────
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      SmartRoomsPageView(
                        pageNotifier: _pageNotifier,
                        roomSelectorNotifier: _roomSelectorNotifier,
                        controller: _pageController,
                      ),
                      Positioned.fill(
                        top: null,
                        child: Column(
                          children: [
                            PageIndicators(
                              roomSelectorNotifier: _roomSelectorNotifier,
                              pageNotifier: _pageNotifier,
                            ),
                            SmHomeBottomNavigationBar(
                              roomSelectorNotifier: _roomSelectorNotifier,
                              onNavigate: _navigateTo,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Info row: Weather + Emergency shutoff ──────────────────────────────────────
class _HomeInfoRow extends StatelessWidget {
  const _HomeInfoRow({required this.onWeatherTap});
  final VoidCallback onWeatherTap;

  @override
  Widget build(BuildContext context) {
    final primary = SHColors.primary(context);

    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        String feelsLikeLabel = AppLocalizations.of(context).weather;
        if (state is WeatherSuccess && state.forecasts.isNotEmpty) {
          feelsLikeLabel =
              '${AppLocalizations.of(context).weather}  ${state.forecasts.first.feelsLike.toInt()}°C';
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              // Weather chip
              GestureDetector(
                onTap: onWeatherTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.orange.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                        // ignore: deprecated_member_use
                        color: Colors.orange.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wb_sunny_outlined,
                          color: Colors.orange, size: 15.sp),
                      SizedBox(width: 5.w),
                      Text(
                        feelsLikeLabel,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Live dot indicator
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary,
                  boxShadow: [
                    BoxShadow(
                        // ignore: deprecated_member_use
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
                  color: SHColors.text(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
