// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/sh_colors.dart';
import 'cubit/emergency_cubit.dart';

class EmergencyShutoffButton extends StatelessWidget {
  const EmergencyShutoffButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmergencyCubit(),
      child: const _EmergencyBtn(),
    );
  }
}

class _EmergencyBtn extends StatelessWidget {
  const _EmergencyBtn();

  Future<void> _confirmAndShutoff(BuildContext context) async {
    HapticFeedback.heavyImpact();
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          l10n.emergencyShutoff,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(l10n.shutoffConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel,
                style: TextStyle(color: SHColors.hint(context))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            child: Text(l10n.shutOffAll,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<EmergencyCubit>().shutoffAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<EmergencyCubit, EmergencyState>(
      listener: (context, state) {
        if (state is EmergencyDone) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.turnedOffCount > 0
                  ? '✓ ${state.turnedOffCount} devices turned OFF'
                  : 'All devices were already OFF'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is EmergencyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<EmergencyCubit, EmergencyState>(
        builder: (context, state) {
          final isRunning = state is EmergencyRunning;

          return GestureDetector(
            onTap: isRunning ? null : () => _confirmAndShutoff(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isRunning
                    ? Colors.red.withOpacity(0.55)
                    : Colors.red,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isRunning)
                    SizedBox(
                      width: 15.w,
                      height: 15.w,
                      child: const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  else
                    Icon(Icons.power_settings_new_rounded,
                        color: Colors.white, size: 16.sp),
                  SizedBox(width: 5.w),
                  Text(
                    isRunning ? l10n.shuttingOff : l10n.allOff,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
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
