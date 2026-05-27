import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/shared/domain/entities/smart_room.dart';
import '../../../core/theme/sh_colors.dart';
import '../../devices/cubit/devices_cubit.dart';
import '../../devices/models/device_model.dart';
import 'room_detail_pages.dart';

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
        curve: const Interval(0.4, 1, curve: Curves.easeIn),
      );

  Animation<double> get _i2 => CurvedAnimation(
        parent: widget.animation,
        curve: const Interval(0.6, 1, curve: Curves.easeIn),
      );

  Animation<double> get _i3 => CurvedAnimation(
        parent: widget.animation,
        curve: const Interval(0.8, 1, curve: Curves.easeIn),
      );

  void _animateToPage(int page) => _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final textColor = SHColors.text(context);
    final primary   = SHColors.primary(context);
    final hint      = SHColors.hint(context);
    final isRtl     = Directionality.of(context) == TextDirection.rtl;

    return BlocProvider(
      create: (_) => DevicesCubit()
        ..loadDevicesForRoom(kRoomIdToKey[widget.room.id] ?? 'living_room'),
      child: Column(
        children: [
          // ── Tabs ──────────────────────────────────────────────────
          SlideTransition(
            position: Tween(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(widget.animation),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Expanded(
                    child: RoomTabButton(
                      label: l10n.controls,
                      icon: Icons.tune_rounded,
                      selected: _currentPage == 0,
                      primary: primary,
                      hint: hint,
                      onTap: () => _animateToPage(0),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: RoomTabButton(
                      label: l10n.devices,
                      icon: Icons.devices_rounded,
                      selected: _currentPage == 1,
                      primary: primary,
                      hint: hint,
                      onTap: () => _animateToPage(1),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // RTL-safe back button: mirror chevron direction
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 6, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(
                      isRtl
                          ? Icons.keyboard_arrow_right
                          : Icons.keyboard_arrow_left,
                      color: textColor,
                      size: 18,
                    ),
                    label: Text(
                      l10n.back.toUpperCase(),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // ── Pages ──────────────────────────────────────────────────
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (p) => setState(() => _currentPage = p),
              children: [
                ControlsPage(
                  room: widget.room,
                  i1: _i1,
                  i2: _i2,
                  i3: _i3,
                  textColor: textColor,
                ),
                DevicesPage(primary: primary, hintColor: hint),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
