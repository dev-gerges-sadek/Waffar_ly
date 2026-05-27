import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/ai_cubit.dart';
import '../cubit/ai_states.dart';
import '../widgets/ai_result_card.dart';

class AiDashboardScreen extends StatelessWidget {
  const AiDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiCubit()..startMonitoring(),
      child: const _AiDashboardView(),
    );
  }
}

class _AiDashboardView extends StatelessWidget {
  const _AiDashboardView();

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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 18.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.waffarAI,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          // Live indicator
          Container(
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.greenAccent.shade400,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  l10n.live,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.greenAccent.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<AiCubit, AiState>(
        builder: (context, state) {
          if (state is AiLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primary),
                  SizedBox(height: 12.h),
                  Text(
                    'Analyzing system state…',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: SHColors.hint(context),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is AiError) {
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

          if (state is AiLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Simulator section ──────────────────────────────────
                  Text(
                    'Simulator Analysis',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  AiResultCard(aiResult: state.simulatorResult),

                  SizedBox(height: 24.h),

                  // ── Hardware section ───────────────────────────────────
                  Text(
                    'Hardware Analysis',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  AiResultCard(aiResult: state.hardwareResult),

                  SizedBox(height: 24.h),

                  // ── Information note ───────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.blue,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'AI analysis updates in real-time as devices consume energy. Monitor probabilities to detect anomalies early.',
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
