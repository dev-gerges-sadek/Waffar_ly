import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/devices_cubit.dart';
import '../cubit/devices_states.dart';
import '../models/device_model.dart';
import 'device_data_panel.dart';
import 'device_icon.dart';

void showDeviceDetailSheet(BuildContext context, DeviceModel device) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<DevicesCubit>(),
      child: _DeviceDetailSheet(device: device),
    ),
  );
}

class _DeviceDetailSheet extends StatelessWidget {
  const _DeviceDetailSheet({required this.device});
  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? SHColors.darkCardColor : SHColors.lightCardColor;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary = SHColors.primary(context);
    final amber = isDark
        ? SHColors.darkWarningColor
        : SHColors.lightWarningColor;
    final errColor = isDark
        ? SHColors.darkErrorColor
        : SHColors.lightErrorColor;
    final shadow = SHColors.shadow(context);
    final l10n = AppLocalizations.of(context);

    return BlocListener<DevicesCubit, DevicesState>(
      listener: (context, state) {
        if (state is DevicesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: errColor,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<DevicesCubit, DevicesState>(
        builder: (context, state) {
          DeviceModel current = device;
          if (state is DevicesLoaded) {
            current = state.devices.firstWhere(
              (d) => d.id == device.id,
              orElse: () => device,
            );
          }

          final isPowerOn = current.simulationData?.isOn ?? false;
          final hwOnline =
              current.hardwareSensor?.status == SensorStatus.online;

          return DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (_, scroll) => Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
                boxShadow: [
                  BoxShadow(
                    color: shadow,
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ListView(
                controller: scroll,
                padding: EdgeInsetsDirectional.fromSTEB(20.w, 12.h, 20.w, 32.h),
                children: [
                  _SheetHandle(hintColor: hintColor),
                  SizedBox(height: 24.h),

                  // 1. Header
                  _ModernSheetHeader(
                    device: current,
                    isPowerOn: isPowerOn,
                    hwOnline: hwOnline,
                    textColor: textColor,
                    hintColor: hintColor,
                    primary: primary,
                    l10n: l10n,
                    onPowerChanged: (val) => context
                        .read<DevicesCubit>()
                        .toggleSimulation(device.id, val),
                  ),
                  SizedBox(height: 24.h),

                  // 2. Parallel panels
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isPowerOn ? 1.0 : 0.45,
                    child: IgnorePointer(
                      ignoring: !isPowerOn,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 11,
                            child: DeviceDataPanel(
                              label: l10n.simulation,
                              accentColor: primary,
                              data: current.simulationData,
                              textColor: textColor,
                              hintColor: hintColor,
                              noDataText: l10n.noData,
                              statusLabel: l10n.status,
                              wattsLabel: l10n.watts,
                              kwhLabel: l10n.kwh,
                              voltsLabel: l10n.volts,
                              ampsLabel: l10n.amps,
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Hardware panel (display-only)
                          Expanded(
                            flex: 9,
                            child: Container(
                              height: 215.h,
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: amber.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: amber.withOpacity(0.08),
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        l10n.hardware.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w800,
                                          color: amber.withOpacity(0.5),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 24.w,
                                        height: 14.h,
                                        child: Transform.scale(
                                          scale: 0.6,
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: Switch.adaptive(
                                            value: false,
                                            activeColor: amber,
                                            onChanged: null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: amber.withOpacity(0.04),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.developer_board_rounded,
                                            size: 22.sp,
                                            color: amber.withOpacity(0.3),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          l10n.hwControl,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w700,
                                            color: textColor.withOpacity(0.5),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          l10n.hwSource,
                                          style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontWeight: FontWeight.w500,
                                            color: hintColor.withOpacity(0.4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // 3. Timestamp
                  if (current.simulationData?.lastUpdated != null && isPowerOn)
                    _LastUpdatedRow(
                      date: current.simulationData!.lastUpdated!.toLocal(),
                      label: l10n.lastUpdated,
                      hintColor: hintColor,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle({required this.hintColor});
  final Color hintColor;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 42.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: hintColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2.r),
      ),
    ),
  );
}

class _ModernSheetHeader extends StatelessWidget {
  const _ModernSheetHeader({
    required this.device,
    required this.isPowerOn,
    required this.hwOnline,
    required this.textColor,
    required this.hintColor,
    required this.primary,
    required this.l10n,
    required this.onPowerChanged,
  });

  final DeviceModel device;
  final bool isPowerOn, hwOnline;
  final Color textColor, hintColor, primary;
  final AppLocalizations l10n;
  final ValueChanged<bool> onPowerChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: isPowerOn
                ? primary.withOpacity(0.08)
                : hintColor.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            height: 26.h,
            width: 26.w,
            child: DeviceIcon(
              type: device.type,
              isOn: isPowerOn,
              hwOnline: hwOnline,
              primary: primary,
              hint: hintColor,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.translateDeviceOrRoomName(device.name),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3.h),
              Text(
                isPowerOn ? l10n.simSource : l10n.powerOff,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                  color: isPowerOn ? primary : hintColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        SizedBox(
          width: 34.w,
          height: 20.h,
          child: Transform.scale(
            scale: 0.72,
            alignment: AlignmentDirectional.centerEnd,
            child: Switch.adaptive(
              value: isPowerOn,
              activeColor: primary,
              onChanged: onPowerChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _LastUpdatedRow extends StatelessWidget {
  const _LastUpdatedRow({
    required this.date,
    required this.label,
    required this.hintColor,
  });
  final DateTime date;
  final String label;
  final Color hintColor;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.history_toggle_off_rounded,
        size: 12.sp,
        color: hintColor.withOpacity(0.5),
      ),
      SizedBox(width: 5.w),
      Text(
        '$label: ${DateFormat('MMM d, HH:mm').format(date)}',
        style: TextStyle(
          fontSize: 10.sp,
          color: hintColor.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
