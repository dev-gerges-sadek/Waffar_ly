// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/shared/domain/entities/smart_room.dart';
import '../../../core/theme/sh_colors.dart';
import '../../devices/cubit/devices_cubit.dart';
import '../../devices/cubit/devices_states.dart';
import '../../devices/models/device_model.dart';
import '../../devices/widgets/device_card.dart';
import 'air_conditioner_controls_card.dart';
import 'light_and_time_switcher.dart';
import 'light_intensity_slide_card.dart';
import 'music_switchers.dart';

class RoomDetailsPageView extends StatefulWidget {
  const RoomDetailsPageView({
    required this.animation,
    required this.room,
    super.key,
  });

  final Animation<double> animation;
  final SmartRoom room;

  @override
  State<RoomDetailsPageView> createState() => _RoomDetailsPageViewState();
}

class _RoomDetailsPageViewState extends State<RoomDetailsPageView> {
  int _currentPage = 0;
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Animation<double> get _i1 => CurvedAnimation(
      parent: widget.animation,
      curve: const Interval(0.4, 1, curve: Curves.easeIn));

  Animation<double> get _i2 => CurvedAnimation(
      parent: widget.animation,
      curve: const Interval(0.6, 1, curve: Curves.easeIn));

  Animation<double> get _i3 => CurvedAnimation(
      parent: widget.animation,
      curve: const Interval(0.8, 1, curve: Curves.easeIn));

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final textColor = SHColors.text(context);
    final primary   = SHColors.primary(context);
    final hintColor = SHColors.hint(context);

    return BlocProvider(
      create: (_) => DevicesCubit()
        ..loadDevicesForRoom(
            kRoomIdToKey[widget.room.id] ?? 'living_room'),
      child: Column(
        children: [
          // ── Tabs ────────────────────────────────────────────────────
          SlideTransition(
            position: Tween(
                    begin: const Offset(0, -1), end: Offset.zero)
                .animate(widget.animation),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  _Tab(
                    label: l10n.controls,
                    icon:  Icons.tune_rounded,
                    selected: _currentPage == 0,
                    primary:  primary,
                    hint:     hintColor,
                    onTap:    () => _animateToPage(0),
                  ),
                  SizedBox(width: 8.w),
                  _Tab(
                    label: l10n.devices,
                    icon:  Icons.devices_rounded,
                    selected: _currentPage == 1,
                    primary:  primary,
                    hint:     hintColor,
                    onTap:    () => _animateToPage(1),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4)),
                    icon: Icon(Icons.keyboard_arrow_left,
                        color: textColor, size: 18),
                    label: Text(
                      l10n.back.toUpperCase(),
                      style: TextStyle(
                          color: textColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // ── Pages ────────────────────────────────────────────────────
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (p) => setState(() => _currentPage = p),
              children: [
                _ControlsPage(
                  room:      widget.room,
                  i1:        _i1,
                  i2:        _i2,
                  i3:        _i3,
                  textColor: textColor,
                ),
                _DevicesPage(
                    primary: primary, hintColor: hintColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Controls page ─────────────────────────────────────────────────────────────
class _ControlsPage extends StatelessWidget {
  const _ControlsPage({
    required this.room,
    required this.i1,
    required this.i2,
    required this.i3,
    required this.textColor,
  });

  final SmartRoom room;
  final Animation<double> i1, i2, i3;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: GoogleFonts.montserrat(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: textColor),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
        children: [
          // Lights + Music row
          SlideTransition(
            position: Tween(
                    begin: const Offset(0, 2), end: Offset.zero)
                .animate(i1),
            child: FadeTransition(
              opacity: i1,
              child: Row(
                children: [
                  Expanded(child: LightsAndTimerSwitchers(room: room)),
                  SizedBox(width: 12.w),
                  Expanded(child: MusicSwitchers(room: room)),
                ],
              ),
            ),
          ),

          SizedBox(height: 14.h),

          // Light intensity slider
          SlideTransition(
            position: Tween(
                    begin: const Offset(0, 2), end: Offset.zero)
                .animate(i2),
            child: FadeTransition(
              opacity: i2,
              child: LightIntensitySliderCard(room: room),
            ),
          ),

          SizedBox(height: 14.h),

          // AC controls
          SlideTransition(
            position: Tween(
                    begin: const Offset(0, 2), end: Offset.zero)
                .animate(i3),
            child: FadeTransition(
              opacity: i3,
              child: AirConditionerControlsCard(room: room),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Devices page ──────────────────────────────────────────────────────────────
class _DevicesPage extends StatelessWidget {
  const _DevicesPage({required this.primary, required this.hintColor});
  final Color primary, hintColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<DevicesCubit, DevicesState>(
      builder: (context, state) {
        if (state is DevicesLoading || state is DevicesInitial) {
          return Center(
              child: CircularProgressIndicator(color: primary));
        }

        if (state is DevicesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded,
                    size: 32.sp, color: hintColor),
                SizedBox(height: 8.h),
                Text(
                  'Could not load devices',
                  style: TextStyle(
                      color: hintColor, fontSize: 12.sp),
                ),
              ],
            ),
          );
        }

        final devices =
            state is DevicesLoaded ? state.devices : <DeviceModel>[];

        if (devices.isEmpty) {
          return Center(
            child: Text(
              l10n.noDevices,
              style: TextStyle(color: hintColor, fontSize: 12.sp),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 20.h),
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:    2,
            crossAxisSpacing:  8.w,
            mainAxisSpacing:   8.h,
            childAspectRatio:  0.68,
          ),
          itemCount: devices.length,
          itemBuilder: (_, i) => DeviceCard(device: devices[i]),
        );
      },
    );
  }
}

// ── Tab button ────────────────────────────────────────────────────────────────
class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.primary,
    required this.hint,
    required this.onTap,
  });

  final String   label;
  final IconData icon;
  final bool     selected;
  final Color    primary, hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: selected ? primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: selected
                ? primary.withOpacity(0.40)
                : Colors.transparent,
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon,
              size: 13.sp, color: selected ? primary : hint),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? primary : hint,
            ),
          ),
        ]),
      ),
    );
  }
}
