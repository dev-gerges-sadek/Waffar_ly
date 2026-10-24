import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../cubit/ai_energy_cubit.dart';
import '../cubit/ai_energy_state.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_body.dart';

class AiEnergyDashboardScreen extends StatelessWidget {
  const AiEnergyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AiEnergyCubit>()..startListening(),
      child: const _DashboardView(),
    );
  }
}

/// Accepts Arabic-Indic digits and the Arabic decimal separator.
String _normaliseNumber(String raw) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final buf = StringBuffer();
  for (final ch in raw.trim().characters) {
    final i = arabic.indexOf(ch);
    if (i >= 0) {
      buf.write(i);
    } else if (ch == '٫' || ch == ',' || ch == '،') {
      buf.write('.');
    } else {
      buf.write(ch);
    }
  }
  return buf.toString();
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  void _showRateDialog(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final ctrl    = TextEditingController();
    final primary = SHColors.primary(context);
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          l10n.electricityRateTitle,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: l10n.electricityRateHint,
            suffixText: l10n.electricityRateSuffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.cancel,
                style: TextStyle(color: SHColors.hint(context))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              final rate = double.tryParse(_normaliseNumber(ctrl.text));
              if (rate != null && rate > 0) {
                context.read<AiEnergyCubit>().updateRate(rate);
              }
              Navigator.pop(dialogCtx);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final primary   = SHColors.primary(context);
    final textColor = SHColors.text(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: SHColors.background(context),
      appBar: DashboardAppBar(
        isDark: isDark,
        primary: primary,
        textColor: textColor,
        onSettings: () => _showRateDialog(context),
      ),
      body: BlocBuilder<AiEnergyCubit, AiEnergyState>(
        builder: (context, state) => switch (state) {
          AiEnergyLoading() || AiEnergyInitial() =>
            _LoadingShell(primary: primary),
          AiEnergyError(:final message) => _ErrorShell(
              message: message,
              primary: primary,
              onRetry: () => context.read<AiEnergyCubit>().startListening(),
            ),
          AiEnergyLoaded() => RefreshIndicator(
              color: primary,
              onRefresh: () => context.read<AiEnergyCubit>().refresh(),
              child: DashboardBody(
                state: state,
                onRateTap: () => _showRateDialog(context),
              ),
            ),
        },
      ),
    );
  }
}

class _LoadingShell extends StatefulWidget {
  const _LoadingShell({required this.primary});
  final Color primary;

  @override
  State<_LoadingShell> createState() => _LoadingShellState();
}

class _LoadingShellState extends State<_LoadingShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget box(double h) => AnimatedBuilder(
      animation: _pulse,
      builder: (_, _) => Container(
        height: h,
        decoration: BoxDecoration(
          color: SHColors.hint(context)
              .withValues(alpha: 0.08 + 0.10 * _pulse.value),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );

    return Semantics(
      label: l10n.dashLoadingTitle,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            box(86.h),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(child: box(104.h)),
                SizedBox(width: 10.w),
                Expanded(child: box(104.h)),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(child: box(104.h)),
                SizedBox(width: 10.w),
                Expanded(child: box(104.h)),
              ],
            ),
            SizedBox(height: 20.h),
            box(160.h),
            SizedBox(height: 16.h),
            Text(
              l10n.dashLoadingTitle,
              style: TextStyle(fontSize: 12.sp, color: SHColors.hint(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorShell extends StatelessWidget {
  const _ErrorShell({
    required this.message,
    required this.primary,
    required this.onRetry,
  });

  final String message;
  final Color primary;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final errColor  = isDark ? SHColors.darkErrorColor : SHColors.lightErrorColor;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48.sp, color: errColor),
            SizedBox(height: 12.h),
            Text(l10n.noData,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: SHColors.text(context)),
                textAlign: TextAlign.center),
            SizedBox(height: 6.h),
            Text(l10n.dashErrorHint,
                style:
                    TextStyle(fontSize: 11.sp, color: SHColors.hint(context)),
                textAlign: TextAlign.center),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                padding:
                    EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 11.h),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
