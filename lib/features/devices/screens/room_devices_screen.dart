// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/shared/domain/entities/smart_room.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/devices_cubit.dart';
import '../cubit/devices_states.dart';
import '../models/device_model.dart';
import '../widgets/device_card.dart';

class RoomDevicesScreen extends StatelessWidget {
  const RoomDevicesScreen({super.key, required this.room});
  final SmartRoom room;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DevicesCubit()
            ..loadDevicesForRoom(kRoomIdToKey[room.id] ?? 'living_room'),
      child: _RoomDevicesView(room: room),
    );
  }
}

class _RoomDevicesView extends StatelessWidget {
  const _RoomDevicesView({required this.room});
  final SmartRoom room;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = SHColors.background(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary = SHColors.primary(context);
    final amber = isDark
        ? SHColors.darkWarningColor
        : SHColors.lightWarningColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible hero header ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 230.h,
            pinned: true,
            stretch: true,
            backgroundColor: isDark
                ? SHColors.darkBackgroundColor
                : SHColors.lightBackgroundColor,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 7,
                      color: Colors.greenAccent.shade400,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Live',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    room.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: primary.withOpacity(0.2),
                      child: Icon(Icons.home, size: 80, color: primary),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                  // Room name + pills
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ FittedBox يلف النص بس — مش الـ Column كله
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            room.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),

                        Row(
                          children: [
                            _HeaderPill(
                              label: '${room.temperature.toInt()}°C',
                              icon: Icons.thermostat_rounded,
                            ),
                            SizedBox(width: 8.w),
                            _HeaderPill(
                              label: '${room.airHumidity.toInt()}% humidity',
                              icon: Icons.water_drop_outlined,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Legend bar ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isDark
                    ? SHColors.darkSurfaceColor.withOpacity(0.5)
                    : SHColors.lightSurfaceColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  _LegendChip(label: 'Simulation', color: primary),
                  SizedBox(width: 8.w),
                  _LegendChip(label: 'Hardware', color: amber),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      'Tap a card for full details',
                      style: TextStyle(fontSize: 10.sp, color: hintColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Section title ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 2.h),
              child: Text(
                'DEVICES',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: hintColor,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // ── Device grid ──────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
            sliver: BlocBuilder<DevicesCubit, DevicesState>(
              builder: (context, state) {
                if (state is DevicesLoading || state is DevicesInitial) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: primary),
                          SizedBox(height: 12.h),
                          Text(
                            'Connecting to Firebase…',
                            style: TextStyle(fontSize: 12.sp, color: hintColor),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is DevicesError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off_rounded,
                            size: 40,
                            color: hintColor,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Could not load devices',
                            style: TextStyle(color: textColor, fontSize: 14.sp),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            state.message,
                            style: TextStyle(color: hintColor, fontSize: 11.sp),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final devices = state is DevicesLoaded
                    ? state.devices
                    : <DeviceModel>[];

                if (devices.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.devices_other, size: 48, color: hintColor),
                          SizedBox(height: 12.h),
                          Text(
                            'No devices configured for this room',
                            style: TextStyle(color: hintColor, fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final onCount = devices
                    .where((d) => d.simulationData?.isOn == true)
                    .length;

                return SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          children: [
                            _SummaryChip(
                              label: '$onCount ON',
                              color: Colors.greenAccent.shade400,
                            ),
                            SizedBox(width: 8.w),
                            _SummaryChip(
                              label: '${devices.length - onCount} OFF',
                              color: hintColor,
                            ),
                            SizedBox(width: 8.w),
                            _SummaryChip(
                              label: '${devices.length} total',
                              color: primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.68,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => DeviceCard(device: devices[i]),
                        childCount: devices.length,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small widgets ─────────────────────────────────────────────────────────────

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white70),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
