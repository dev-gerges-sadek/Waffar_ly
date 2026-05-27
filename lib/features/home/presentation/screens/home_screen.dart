import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/core.dart';
import '../../../../features/smart_room/cubit/smart_room_cubit.dart';
import '../../../weather/cubit/weather_cubit.dart';
import '../../../weather/screens/weather_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_info_row.dart';
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
  final _pageController         = PageController(viewportFraction: 0.8);
  final ValueNotifier<double> _pageNotifier         = ValueNotifier(0);
  final ValueNotifier<int>    _roomSelectorNotifier = ValueNotifier(-1);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WeatherCubit()),
        // SmartRoomCubit is shared by PageView + PageIndicators
        BlocProvider(
          create: (_) => GetIt.I<SmartRoomCubit>()..loadRooms(),
        ),
      ],
      child: LightedBackground(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          drawer: HomeDrawer(onNavigate: _navigateTo),
          appBar: ShAppBar(
            onMenuTap:     () => _scaffoldKey.currentState?.openDrawer(),
            onSettingsTap: () => _navigateTo(const SettingsScreen()),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 12.h),
                HomeInfoRow(
                    onWeatherTap: () => _navigateTo(const WeatherScreen())),
                SizedBox(height: 14.h),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
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
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      SmartRoomsPageView(
                        pageNotifier:         _pageNotifier,
                        roomSelectorNotifier: _roomSelectorNotifier,
                        controller:           _pageController,
                      ),
                      Positioned.fill(
                        top: null,
                        child: Column(
                          children: [
                            PageIndicators(
                              roomSelectorNotifier: _roomSelectorNotifier,
                              pageNotifier:         _pageNotifier,
                            ),
                            SmHomeBottomNavigationBar(
                              roomSelectorNotifier: _roomSelectorNotifier,
                              onNavigate:           _navigateTo,
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
