// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/anomaly_cubit.dart';
import '../cubit/anomaly_states.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnomalyCubit()..startMonitoring(),
      child: const _AnomalyView(),
    );
  }
}

class _AnomalyView extends StatelessWidget {
  const _AnomalyView();

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final bg        = SHColors.background(context);
    final textColor = SHColors.text(context);
    final primary   = SHColors.primary(context);

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
          'Anomaly Alerts',
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: textColor),
        ),
        actions: [
          // Live indicator
          Container(
            margin: EdgeInsets.only(right: 12.w),
            padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle,
                    size: 7, color: Colors.greenAccent.shade400),
                SizedBox(width: 4.w),
                Text(
                  'Monitoring',
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.greenAccent.shade400,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<AnomalyCubit, AnomalyState>(
        builder: (context, state) {
          if (state is AnomalyLoading || state is AnomalyInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primary),
                  SizedBox(height: 12.h),
                  Text(
                    'Collecting device readings…',
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: SHColors.hint(context)),
                  ),
                ],
              ),
            );
          }

          if (state is AnomalyError) {
            return Center(
              child: Text(state.message,
                  style: TextStyle(color: SHColors.hint(context))),
            );
          }

          if (state is AnomalyLoaded) {
            if (state.allClear) {
              return _AllClearView(primary: primary);
            }
            return _AlertsList(alerts: state.alerts);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── All clear ─────────────────────────────────────────────────────────────────
class _AllClearView extends StatelessWidget {
  const _AllClearView({required this.primary});
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline_rounded,
                color: Colors.green, size: 48),
          ),
          SizedBox(height: 16.h),
          Text(
            'All Clear',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: SHColors.text(context),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'No unusual power consumption detected.',
            style: TextStyle(
                fontSize: 13.sp, color: SHColors.hint(context)),
          ),
        ],
      ),
    );
  }
}

// ── Alerts list ───────────────────────────────────────────────────────────────
class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.alerts});
  final List<AnomalyAlert> alerts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _InfoBanner(),
        SizedBox(height: 12.h),
        ...alerts.map((a) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _AlertCard(alert: a),
            )),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Colors.orange, size: 16),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Detected by Z-score analysis on live kWh readings from Firebase.',
              style: TextStyle(
                  fontSize: 11.sp, color: SHColors.text(context)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});
  final AnomalyAlert alert;

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    final severityColor = switch (alert.severity) {
      AnomalySeverity.high   => Colors.red,
      AnomalySeverity.medium => Colors.orange,
      AnomalySeverity.low    => Colors.amber,
    };
    final severityLabel = switch (alert.severity) {
      AnomalySeverity.high   => 'HIGH',
      AnomalySeverity.medium => 'MEDIUM',
      AnomalySeverity.low    => 'LOW',
    };

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: SHColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
            color: severityColor.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: severityColor.withOpacity(isDark ? 0.15 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  severityLabel,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w800,
                    color: severityColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  alert.deviceName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              Icon(Icons.warning_amber_rounded,
                  color: severityColor, size: 18.sp),
            ],
          ),
          SizedBox(height: 10.h),

          // Message
          Text(
            alert.message,
            style: TextStyle(
                fontSize: 12.sp, color: textColor, height: 1.5),
          ),
          SizedBox(height: 10.h),

          // Stats row
          Row(
            children: [
              _StatChip(
                label: 'Current',
                value: '${alert.currentKwh.toStringAsFixed(3)} kWh',
                color: severityColor,
              ),
              SizedBox(width: 8.w),
              _StatChip(
                label: 'Average',
                value: '${alert.avgKwh.toStringAsFixed(3)} kWh',
                color: hintColor,
              ),
              SizedBox(width: 8.w),
              _StatChip(
                label: 'Z-score',
                value: alert.zScore.toStringAsFixed(1),
                color: severityColor,
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Timestamp
          Text(
            'Detected at ${DateFormat('HH:mm · d MMM').format(alert.detectedAt)}',
            style: TextStyle(fontSize: 10.sp, color: hintColor),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip(
      {required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: color)),
          Text(label,
              style: TextStyle(
                  fontSize: 9.sp,
                  color: SHColors.hint(context))),
        ],
      ),
    );
  }
}
