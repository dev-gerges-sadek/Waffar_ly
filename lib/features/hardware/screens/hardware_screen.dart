import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/hardware_cubit.dart';
import '../cubit/hardware_states.dart';
import '../widgets/hardware_device_card.dart';

class HardwareMonitorScreen extends StatelessWidget {
  const HardwareMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HardwareCubit()..startMonitoring(),
      child: const _HardwareMonitorView(),
    );
  }
}

class _HardwareMonitorView extends StatelessWidget {
  const _HardwareMonitorView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = SHColors.background(context);
    final textColor = SHColors.text(context);
    final primary = SHColors.primary(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark
            ? SHColors.darkBackgroundColor
            : SHColors.lightBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: textColor, size: 18.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.hardwareMonitor,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HardwareCubit, HardwareState>(
        builder: (context, state) {
          if (state is HardwareLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primary),
                  SizedBox(height: 12.h),
                  Text(
                    'Scanning for hardware…',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: SHColors.hint(context),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is HardwareError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: Colors.red.withOpacity(0.6),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: SHColors.hint(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is HardwareLoaded) {
            if (state.devices.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.router_rounded,
                      size: 64.sp,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      l10n.noHardware,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: SHColors.hint(context),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Waiting for ESP32 devices to connect…',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: SHColors.hint(context),
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Status summary ────────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: state.isConnected
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: state.isConnected
                            ? Colors.green.withOpacity(0.3)
                            : Colors.orange.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: state.isConnected
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.isConnected ? '✅ Connected' : '🟠 Reconnecting',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: state.isConnected
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                              Text(
                                '${state.devices.length} device(s) detected',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: SHColors.hint(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ── Device list ────────────────────────────────────────
                  Text(
                    'Connected Devices',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.devices.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, index) {
                      final device = state.devices[index];
                      return HardwareDeviceCard(device: device);
                    },
                  ),

                  SizedBox(height: 20.h),

                  // ── Information note ───────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: Colors.blue, size: 16.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Real-time monitoring of ESP32 hardware devices. Green = Connected, Orange = Reconnecting, Red = Offline.',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.blue[700],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
