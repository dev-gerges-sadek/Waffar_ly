import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/sh_colors.dart';
import 'cubit/emergency_cubit.dart';
import 'cubit/emergency_state.dart';

class EmergencyShutoffButton extends StatelessWidget {
  const EmergencyShutoffButton({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => EmergencyCubit(),
        child: const _EmergencyBtn(),
      );
}

class _EmergencyBtn extends StatelessWidget {
  const _EmergencyBtn();

  Future<void> _confirmAndShutoff(BuildContext context) async {
    HapticFeedback.heavyImpact();
    final l10n     = AppLocalizations.of(context);
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final errColor = isDark ? SHColors.darkErrorColor : SHColors.lightErrorColor;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)),
        title: Text(l10n.emergencyShutoff,
            style: const TextStyle(fontWeight: FontWeight.w700)),
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
              backgroundColor: errColor,
              foregroundColor: onPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            child: Text(l10n.shutOffAll),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final warnColor = isDark
          ? SHColors.darkWarningColor
          : SHColors.lightWarningColor;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.emergencyActivated),
        backgroundColor: warnColor,
        duration: const Duration(seconds: 2),
      ));
      context.read<EmergencyCubit>().shutoffAll();
    } else {
      debugPrint('[EmergencyShutoffButton] User cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n     = AppLocalizations.of(context);
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final errColor = isDark ? SHColors.darkErrorColor : SHColors.lightErrorColor;
    final successColor = isDark ? SHColors.darkSuccessColor : SHColors.lightSuccessColor;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return BlocListener<EmergencyCubit, EmergencyState>(
      listener: (ctx, state) {
        if (state is EmergencyDone) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(state.turnedOffCount > 0
                ? '✓ ${state.turnedOffCount} ${l10n.devices} ${l10n.powerOff}'
                : '${l10n.devices} ${l10n.powerOff}'),
            backgroundColor: successColor,
            duration: const Duration(seconds: 2),
          ));
        } else if (state is EmergencyError) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: errColor,
          ));
        }
      },
      child: BlocBuilder<EmergencyCubit, EmergencyState>(
        builder: (ctx, state) => GestureDetector(
          onTap: () => _confirmAndShutoff(ctx),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: errColor,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: errColor.withOpacity(0.30),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.power_settings_new_rounded,
                    color: onPrimary, size: 16.sp),
                SizedBox(width: 5.w),
                Text(
                  l10n.allOff,
                  style: TextStyle(
                    color: onPrimary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
