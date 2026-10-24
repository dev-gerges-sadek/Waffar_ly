import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../emergency/data/emergency_repository.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../../../emergency/cubit/emergency_cubit.dart';
import '../../../emergency/cubit/emergency_state.dart';

/// Red circular emergency shutoff button shown in the nav bar.
/// Provides its own BlocProvider — safe to place anywhere.
class EmergencyNavButton extends StatelessWidget {
  const EmergencyNavButton({super.key, required this.primary});
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => EmergencyCubit(GetIt.I<EmergencyRepository>()),
      child: BlocListener<EmergencyCubit, EmergencyState>(
        listener: (ctx, state) {
          if (state is EmergencyDone) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(!state.hardwareSent
                  ? l10n.emergencyHardwareFailed
                  : state.turnedOffCount > 0
                      ? '✓ ${l10n.devicesTurnedOff(state.turnedOffCount)}'
                      : l10n.allAlreadyOff),
              backgroundColor: state.hardwareSent
                  ? SHColors.severity(context, 'normal')
                  : SHColors.error(context),
              duration: Duration(seconds: state.hardwareSent ? 2 : 6),
            ));
          } else if (state is EmergencyError) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(l10n.emergencyFailed),
              backgroundColor: SHColors.error(context),
              duration: const Duration(seconds: 3),
            ));
          }
        },
        child: Builder(
          builder: (ctx) => Semantics(
            button: true,
            label: l10n.emergencyShutoff,
            child: GestureDetector(
            onTap: () => _confirmShutoff(ctx),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SHColors.error(context),
                boxShadow: [
                  BoxShadow(
                    color: SHColors.error(context).withValues(alpha: 0.40),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(Icons.power_settings_new_rounded,
                    color: Theme.of(context).colorScheme.onPrimary, size: 24.sp),
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmShutoff(BuildContext context) async {
    unawaited(HapticFeedback.heavyImpact());

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)),
        title: Text(AppLocalizations.of(context).emergencyShutoff,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
            AppLocalizations.of(context).shutoffConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).cancelLabel,
                style: TextStyle(color: SHColors.hint(context))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SHColors.error(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context).shutoffEverythingLabel,
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).emergencyActivated),
        backgroundColor: SHColors.warning(context),
        duration: const Duration(seconds: 2),
      ));
      unawaited(context.read<EmergencyCubit>().shutoffAll());
    }
  }
}

// ── Nav item ──────────────────────────────────────────────────────────────────

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.primary,
    required this.hintColor,
    required this.onTap,
  });

  final IconData     icon;
  final String       label;
  final bool         isSelected;
  final Color        primary;
  final Color        hintColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? primary : hintColor, size: 22.sp),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? primary : hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
