import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../cubit/ai_energy_state.dart';
import 'ai_source_panel.dart';
import 'anomaly_alert_card.dart';
import 'dashboard_section_header.dart';
import 'energy_snapshot_card.dart';
import 'power_by_room_card.dart';
import 'section_divider.dart';
import 'stat_metric.dart';
import 'system_health_banner.dart';
import 'top_devices_card.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
    required this.state,
    required this.onRateTap,
  });

  final AiEnergyLoaded state;
  final VoidCallback onRateTap;

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final primary = SHColors.primary(context);
    final hint    = SHColors.hint(context);
    // Semantic color tokens — no raw Colors.*
    final warningColor  = SHColors.warning(context);
    final purpleAccent  = SHColors.chartBlue(context);   // chart accent for AI section
    final tealAccent    = SHColors.success(context);     // rooms section accent
    final goldAccent    = SHColors.rank(context, 1);     // top devices accent (gold)

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── System health banner ─────────────────────────────────────────
          SystemHealthBanner(
            status: state.systemHealth,
            severity: state.worstSeverity,
            worstDecision: state.simulator.aiDecision,
            totalWatts: state.totalLiveWatts,
            anomalyPct: state.maxAnomalyPct,
          ),
          SizedBox(height: 20.h),

          // ── System indicators ────────────────────────────────────────────
          DashboardSectionHeader(
            title: l10n.systemIndicatorsTitle,
            icon: Icons.auto_awesome_rounded,
            color: primary,
            subtitle: l10n.firestoreRealtimeSubtitle,
          ),
          SizedBox(height: 10.h),
          _SystemSummaryCard(state: state, primary: primary, l10n: l10n),
          SizedBox(height: 20.h),

          // ── Live energy snapshot ─────────────────────────────────────────
          DashboardSectionHeader(
            title: l10n.liveSnapshotTitle,
            icon: Icons.electric_bolt_rounded,
            color: primary,
            subtitle: l10n.firebaseRealtimeSubtitle,
          ),
          SizedBox(height: 10.h),
          EnergySnapshotCard(state: state),
          SizedBox(height: 22.h),
          const SectionDivider(),
          SizedBox(height: 14.h),

          // ── Anomaly alerts (only when active) ────────────────────────────
          if (state.hasAnomaly) ...[
            DashboardSectionHeader(
              title: l10n.anomalyAlertsTitle,
              icon: Icons.warning_amber_rounded,
              color: warningColor,
              subtitle: l10n.activeAnomalySubtitle,
            ),
            SizedBox(height: 10.h),
            if (state.simulator.isAnomaly)
              AnomalyAlertCard(
                result: state.simulator,
                sourceLabel: l10n.simulatorLabel,
              ),
            if (state.hardware.isAnomaly)
              AnomalyAlertCard(
                result: state.hardware,
                sourceLabel: l10n.hardwareDeviceLabel,
              ),
            SizedBox(height: 10.h),
            const SectionDivider(),
            SizedBox(height: 14.h),
          ],

          // ── AI analysis ──────────────────────────────────────────────────
          DashboardSectionHeader(
            title: l10n.aiAnalysisTitle,
            icon: Icons.psychology_rounded,
            color: purpleAccent,
            subtitle: l10n.simPlusEspSubtitle,
          ),
          SizedBox(height: 10.h),
          AiSourcePanel(
            simulator: state.simulator,
            hardware: state.hardware,
          ),
          SizedBox(height: 22.h),
          const SectionDivider(),
          SizedBox(height: 14.h),

          // ── Power by room ────────────────────────────────────────────────
          DashboardSectionHeader(
            title: l10n.powerByRoomTitle,
            icon: Icons.home_rounded,
            color: tealAccent,
            subtitle: '${state.roomBreakdown.length} ${l10n.activeRoomsSubtitle}',
          ),
          SizedBox(height: 10.h),
          PowerByRoomCard(
            roomBreakdown: state.roomBreakdown,
            totalKwh: state.totalKwh,
          ),
          SizedBox(height: 22.h),
          const SectionDivider(),
          SizedBox(height: 14.h),

          // ── Top devices ──────────────────────────────────────────────────
          DashboardSectionHeader(
            title: l10n.topDevicesTitle,
            icon: Icons.leaderboard_rounded,
            color: goldAccent,
            subtitle: l10n.topFiveSubtitle,
          ),
          SizedBox(height: 10.h),
          TopDevicesCard(topDevices: state.topDevices),
          SizedBox(height: 22.h),
          const SectionDivider(),
          SizedBox(height: 14.h),

          // ── Rate footer ──────────────────────────────────────────────────
          RateFooterCard(
            rate: state.electricityRate,
            primary: primary,
            onTap: onRateTap,
          ),
          SizedBox(height: 16.h),

          // ── Last updated ─────────────────────────────────────────────────
          Center(
            child: Text(
              '${l10n.lastUpdatedPrefix} ${_fmt(state.lastRefreshed)}',
              style: TextStyle(fontSize: 9.sp, color: hint),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}:'
      '${dt.second.toString().padLeft(2, '0')}';
}

// ── System summary card ───────────────────────────────────────────────────────

class _SystemSummaryCard extends StatelessWidget {
  const _SystemSummaryCard({
    required this.state,
    required this.primary,
    required this.l10n,
  });

  final AiEnergyLoaded state;
  final Color primary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final success = SHColors.success(context);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: SHColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: primary.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.liveSummaryLabel,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: SHColors.text(context),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: StatMetric(
                  icon: Icons.electric_bolt_rounded,
                  color: primary,
                  value: '${state.totalLiveWatts.toStringAsFixed(0)} W',
                  label: l10n.totalConsumptionLabel,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: StatMetric(
                  icon: Icons.safety_check_rounded,
                  color: success,
                  value: state.systemHealth.label(l10n.isArabic),
                  label: l10n.systemStatusLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Rate footer ───────────────────────────────────────────────────────────────

class RateFooterCard extends StatelessWidget {
  const RateFooterCard({
    super.key,
    required this.rate,
    required this.primary,
    required this.onTap,
  });

  final double rate;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: SHColors.card(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: primary.withOpacity(0.20)),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt_rounded, color: primary, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.electricityRateLabel,
                    style: TextStyle(
                        fontSize: 11.sp, color: SHColors.hint(context))),
                Text(
                  '${rate.toStringAsFixed(2)} ${l10n.electricityRateUnit}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: SHColors.text(context),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                l10n.editLabel,
                style: TextStyle(
                    fontSize: 11.sp,
                    color: onPrimary,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
