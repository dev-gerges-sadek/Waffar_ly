import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/shared/domain/entities/smart_room.dart';
import '../../../core/theme/sh_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../cubit/devices_cubit.dart';
import '../cubit/devices_states.dart';
import '../models/device_model.dart';
import '../widgets/widgets.dart';

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
    final l10n = AppLocalizations.of(context);
    final primary = SHColors.primary(context);
    final hint = SHColors.hint(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final amber = isDark
        ? SHColors.darkWarningColor
        : SHColors.lightWarningColor;

    return Scaffold(
      backgroundColor: SHColors.background(context),
      body: CustomScrollView(
        slivers: [
          RoomHeroAppBar(room: room),

          // ── Legend bar ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: DeviceLegendBar(
              simulationColor: primary,
              hardwareColor: amber,
            ),
          ),

          // ── Section label ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 2.h),
              child: Text(
                l10n.devices.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: hint,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // ── Device grid ───────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 32.h),
            sliver: BlocBuilder<DevicesCubit, DevicesState>(
              buildWhen: (p, c) =>
                  c is DevicesLoaded ||
                  c is DevicesLoading ||
                  c is DevicesError,
              builder: (_, state) => _DeviceGridContent(
                state: state,
                primary: primary,
                hint: hint,
                l10n: l10n,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grid content ──────────────────────────────────────────────────────────────

class _DeviceGridContent extends StatelessWidget {
  const _DeviceGridContent({
    required this.state,
    required this.primary,
    required this.hint,
    required this.l10n,
  });

  final DevicesState state;
  final Color primary, hint;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (state is DevicesLoading || state is DevicesInitial) {
      return const SliverFillRemaining(child: LoadingView());
    }
    if (state is DevicesError) {
      return SliverFillRemaining(
        child: ErrorView(
          icon: Icons.wifi_off_rounded,
          title: l10n.noDevices,
          message: (state as DevicesError).message,
        ),
      );
    }

    final devices = state is DevicesLoaded
        ? (state as DevicesLoaded).devices
        : <DeviceModel>[];

    if (devices.isEmpty) {
      return SliverFillRemaining(
        child: EmptyStateView(icon: Icons.devices_other, label: l10n.noDevices),
      );
    }

    final onCount = devices.where((d) => d.isOn).length;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsDirectional.only(bottom: 12.h),
            child: DeviceSummaryChips(
              onCount: onCount,
              offCount: devices.length - onCount,
              total: devices.length,
              primaryColor: primary,
              hintColor: hint,
            ),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.64,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, i) => DeviceCard(device: devices[i]),
            childCount: devices.length,
          ),
        ),
      ],
    );
  }
}
