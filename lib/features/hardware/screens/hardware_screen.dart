import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../../ai_dashboard/cubit/ai_energy_cubit.dart';
import '../cubit/device_control_cubit.dart';
import '../cubit/device_control_state.dart';
import '../cubit/hardware_cubit.dart';
import '../cubit/hardware_states.dart';
import '../models/hardware_device.dart';
import '../widgets/hw_connection_indicator.dart';
import '../widgets/hardware_data_panel.dart';

class HardwareScreen extends StatelessWidget {
  const HardwareScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HardwareCubit()..startListening()),
          BlocProvider(create: (_) => DeviceControlCubit()),
          BlocProvider(
              create: (_) => GetIt.I<AiEnergyCubit>()..startListening()),
        ],
        child: const _HardwareView(),
      );
}

class _HardwareView extends StatelessWidget {
  const _HardwareView();

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);
    final primary   = SHColors.primary(context);
    final amber     = isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;
    final l10n      = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: SHColors.background(context),
      appBar: AppBar(
        backgroundColor: isDark
            ? SHColors.darkBackgroundColor
            : SHColors.lightBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.memory_rounded, color: amber, size: 20.sp),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                l10n.hardwareMonitor,
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          BlocBuilder<HardwareCubit, HardwareState>(
            builder: (context, state) {
              final status = state is HardwareLoaded
                  ? state.connectionStatus
                  : HwConnectionStatus.disconnected;
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: Center(
                    child: HwConnectionIndicator(status: status)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
                icon: Icons.developer_board_rounded,
                title: l10n.hardwareDevices,
                color: amber),
            SizedBox(height: 10.h),
            BlocBuilder<HardwareCubit, HardwareState>(
              builder: (context, state) {
                if (state is HardwareLoaded && state.devices.isNotEmpty) {
                  return _DeviceDataCard(
                      device: state.devices.first,
                      color: amber,
                      l10n: l10n);
                }
                return _EmptyTile(
                  icon: Icons.cloud_off_rounded,
                  message:
                      '${l10n.noHardwareConnected}.\n${l10n.allDeviceDataFromAi}.',
                  color: amber,
                );
              },
            ),
            SizedBox(height: 24.h),
            _SectionTitle(
                icon: Icons.gamepad_rounded,
                title: l10n.deviceControl,
                color: amber),
            SizedBox(height: 10.h),
            _ControlPanel(l10n: l10n),
            SizedBox(height: 24.h),
            _SectionTitle(
                icon: Icons.auto_awesome_rounded,
                title: '${l10n.aiAnalysis} — Real_Device_01',
                color: primary),
            SizedBox(height: 10.h),
            HardwareDataPanel(
                deviceId: 'Real_Device_01', onDataLoaded: (_) {}),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });
  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 6.w),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      );
}

class _EmptyTile extends StatelessWidget {
  const _EmptyTile({
    required this.icon,
    required this.message,
    required this.color,
  });
  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32.sp, color: color.withOpacity(0.5)),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: SHColors.hint(context),
                  height: 1.5),
            ),
          ],
        ),
      );
}


// ── Control panel — writes relayState to Control/Real_Device_01 ──────────────

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceControlCubit, DeviceControlState>(
      builder: (context, state) {
        final isDark      = Theme.of(context).brightness == Brightness.dark;
        final primary     = SHColors.primary(context);
        final cardColor   = SHColors.card(context);
        final textColor   = SHColors.text(context);
        final hintColor   = SHColors.hint(context);
        final success     = isDark ? SHColors.darkSuccessColor : SHColors.lightSuccessColor;
        final errColor    = isDark ? SHColors.darkErrorColor   : SHColors.lightErrorColor;
        final isLoading   = state is DeviceControlLoading;

        // Resolve current relay state from cubit state
        final relayOn = state is RelayToggleSuccess
            ? state.relayState
            : false;

        final stateColor = relayOn ? success : errColor;

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: primary.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ─────────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.developer_board_rounded,
                      color: primary, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    l10n.realDeviceControl,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  // Live sync indicator
                  if (state is RelayToggleSuccess && state.fromFirestore)
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_done_rounded,
                              size: 10.sp, color: success),
                          SizedBox(width: 3.w),
                          Text(
                            l10n.isArabic ? 'متزامن' : 'Synced',
                            style: TextStyle(
                                fontSize: 8.sp,
                                color: success,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 14.h),

              // ── Relay toggle card ──────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: stateColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: stateColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    // State icon
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        relayOn
                            ? Icons.power_rounded
                            : Icons.power_off_rounded,
                        key: ValueKey(relayOn),
                        color: stateColor,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Label + sub-label
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.deviceStatus,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: hintColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              relayOn ? l10n.powerOn : l10n.powerOff,
                              key: ValueKey(relayOn),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: stateColor,
                              ),
                            ),
                          ),
                          Text(
                            'Control/Real_Device_01 → relayState',
                            style: TextStyle(
                                fontSize: 8.sp,
                                color: hintColor.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),

                    // Toggle switch or loading indicator
                    isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primary,
                            ),
                          )
                        : Switch.adaptive(
                            value: relayOn,
                            activeColor: success,
                            onChanged: (val) => context
                                .read<DeviceControlCubit>()
                                .toggleRelayState(val),
                          ),
                  ],
                ),
              ),

              // ── Error banner ───────────────────────────────────────
              if (state is DeviceControlError) ...[
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: errColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded,
                          color: errColor, size: 16.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          '${l10n.error}${state.message}',
                          style: TextStyle(
                              fontSize: 10.sp, color: errColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ── Data row + device card (bottom of file) ───────────────────────────────────

class _DeviceDataCard extends StatelessWidget {
  const _DeviceDataCard({
    required this.device,
    required this.color,
    required this.l10n,
  });
  final HardwareDevice device;
  final Color color;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final success   = isDark ? SHColors.darkSuccessColor : SHColors.lightSuccessColor;
    final warning   = isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(device.displayName,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor)),
          SizedBox(height: 12.h),
          _DataRow(label: l10n.voltage,
              value: '${device.voltage.toStringAsFixed(2)} V',
              color: color),
          SizedBox(height: 8.h),
          _DataRow(label: l10n.amperes,
              value: '${device.current.toStringAsFixed(2)} A',
              color: color),
          SizedBox(height: 8.h),
          _DataRow(label: l10n.watts,
              value: '${device.power.toStringAsFixed(2)} W',
              color: color),
          SizedBox(height: 8.h),
          _DataRow(
            label: l10n.status,
            value: device.status ?? l10n.notAvailable,
            color: device.status == 'ON' ? success : warning,
          ),
          SizedBox(height: 8.h),
          _DataRow(
            label: l10n.lastUpdated,
            value: device.lastUpdated != null
                ? '${device.lastUpdated!.toLocal()}'.split('.')[0]
                : l10n.notAvailable,
            color: hintColor,
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label, value;
  final Color  color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11.sp, color: SHColors.hint(context))),
          Text(value,
              style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      );
}
