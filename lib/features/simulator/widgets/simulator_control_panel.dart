import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/simulator_cubit.dart';
import '../cubit/simulator_states.dart';

class SimulatorControlPanel extends StatelessWidget {
  const SimulatorControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SimulatorCubit(),
      child: const _SimulatorPanel(),
    );
  }
}

class _SimulatorPanel extends StatelessWidget {
  const _SimulatorPanel();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = SHColors.card(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return BlocBuilder<SimulatorCubit, SimulatorState>(
      builder: (context, state) {
        final isRunning = state is SimulatorRunning;
        final activeDevices = state is SimulatorRunning
            ? state.activeDevices
            : 0;

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isRunning
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
            ),
            boxShadow: [
              if (isRunning)
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────────────────
              Row(
                children: [
                  Icon(
                    Icons.simulation_rounded,
                    color: isRunning ? Colors.green : Colors.orange,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.simulatorMode,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        Text(
                          isRunning
                              ? l10n.simulatorRunning
                              : 'Click to activate simulator',
                          style: TextStyle(fontSize: 10.sp, color: hintColor),
                        ),
                      ],
                    ),
                  ),
                  // Status indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isRunning
                          ? Colors.green.withOpacity(0.15)
                          : Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isRunning ? Colors.green : Colors.orange,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          isRunning ? 'ACTIVE' : 'IDLE',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: isRunning ? Colors.green : Colors.orange,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // ── Active devices counter ─────────────────────────────────
              if (isRunning)
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Devices',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: hintColor,
                        ),
                      ),
                      Text(
                        '$activeDevices / 13',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

              if (isRunning) SizedBox(height: 12.h),

              // ── Action buttons ─────────────────────────────────────────
              if (state is SimulatorError)
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Error: ${state.message}',
                    style: TextStyle(fontSize: 10.sp, color: Colors.red),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(
                          isRunning
                              ? Icons.stop_rounded
                              : Icons.play_arrow_rounded,
                          size: 16.sp,
                        ),
                        label: Text(
                          isRunning
                              ? l10n.stopSimulation
                              : l10n.startSimulation,
                          style: TextStyle(fontSize: 11.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRunning
                              ? Colors.red.withOpacity(0.8)
                              : Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () {
                          if (isRunning) {
                            context.read<SimulatorCubit>().stopSimulation();
                          } else {
                            context.read<SimulatorCubit>().startSimulation();
                          }
                        },
                      ),
                    ),
                  ],
                ),

              SizedBox(height: 8.h),

              // ── Info text ──────────────────────────────────────────────
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Simulator generates realistic power consumption patterns. Voltage, current, and kWh accumulate in real-time.',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.blue[700],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
