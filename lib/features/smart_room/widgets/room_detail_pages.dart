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

class ControlsPage extends StatelessWidget {
  const ControlsPage({
    super.key,
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
        color: textColor,
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 20.h),
        children: [
          SlideTransition(
            position: Tween(
              begin: const Offset(0, 2),
              end: Offset.zero,
            ).animate(i1),
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
          SlideTransition(
            position: Tween(
              begin: const Offset(0, 2),
              end: Offset.zero,
            ).animate(i2),
            child: FadeTransition(
              opacity: i2,
              child: LightIntensitySliderCard(room: room),
            ),
          ),
          SizedBox(height: 14.h),
          SlideTransition(
            position: Tween(
              begin: const Offset(0, 2),
              end: Offset.zero,
            ).animate(i3),
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

class DevicesPage extends StatelessWidget {
  const DevicesPage({
    super.key,
    required this.primary,
    required this.hintColor,
  });
  final Color primary, hintColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<DevicesCubit, DevicesState>(
      builder: (context, state) {
        if (state is DevicesLoading || state is DevicesInitial) {
          return Center(child: CircularProgressIndicator(color: primary));
        }

        if (state is DevicesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded, size: 32.sp, color: hintColor),
                SizedBox(height: 8.h),
                Text(
                  l10n.errNoNetwork,
                  style: TextStyle(color: hintColor, fontSize: 12.sp),
                ),
              ],
            ),
          );
        }

        final devices = state is DevicesLoaded
            ? state.devices
            : <DeviceModel>[];

        if (devices.isEmpty) {
          return Center(
            child: Text(
              l10n.noDevices,
              style: TextStyle(color: hintColor, fontSize: 12.sp),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsetsDirectional.fromSTEB(12.w, 8.h, 12.w, 20.h),
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 0.68,
          ),
          itemCount: devices.length,
          itemBuilder: (_, i) => DeviceCard(device: devices[i]),
        );
      },
    );
  }
}

class RoomTabButton extends StatelessWidget {
  const RoomTabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.primary,
    required this.hint,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color primary, hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          // Colors.transparent → surface token at 0 opacity (same visual, compliant)
          color: selected
              ? primary.withOpacity(0.12)
              : SHColors.surface(context).withOpacity(0),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: selected
                ? primary.withOpacity(0.40)
                : SHColors.surface(context).withOpacity(0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, size: 13.sp, color: selected ? primary : hint),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected ? primary : hint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
