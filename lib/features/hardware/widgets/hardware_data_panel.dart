import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';

class HardwareDataPanel extends StatefulWidget {
  const HardwareDataPanel({
    super.key,
    required this.deviceId,
    required this.onDataLoaded,
  });

  final String deviceId;
  final Function(Map<String, dynamic>)? onDataLoaded;

  @override
  State<HardwareDataPanel> createState() => _HardwareDataPanelState();
}

class _HardwareDataPanelState extends State<HardwareDataPanel> {
  late Stream<DocumentSnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _buildStream();
  }

  Stream<DocumentSnapshot> _buildStream() => FirebaseFirestore.instance
      .collection('ai_results')
      .doc(widget.deviceId)
      .snapshots();

  void _refresh() => setState(() => _stream = _buildStream());

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final primary = SHColors.primary(context);
    final hint    = SHColors.hint(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: _stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: primary));
        }
        if (snap.hasError) {
          return _StatusCard(
            icon: Icons.error_outline,
            color: SHColors.error(context),
            message: '${l10n.error}${snap.error}',
            buttonLabel: l10n.retry,
            onTap: _refresh,
          );
        }
        if (!snap.hasData || !snap.data!.exists) {
          return _StatusCard(
            icon: Icons.cloud_off_rounded,
            color: hint,
            message: '${l10n.noData} — ${widget.deviceId}',
            buttonLabel: l10n.retry,
            onTap: _refresh,
          );
        }

        final data = snap.data!.data() as Map<String, dynamic>;
        widget.onDataLoaded?.call(data);

        return _DataPanel(data: data, onRefresh: _refresh);
      },
    );
  }
}

// ── Full data panel ───────────────────────────────────────────────────────────

class _DataPanel extends StatelessWidget {
  const _DataPanel({required this.data, required this.onRefresh});
  final Map<String, dynamic> data;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary   = SHColors.primary(context);
    final success   = SHColors.success(context);
    final warning   = SHColors.warning(context);
    final errColor  = SHColors.error(context);

    final decisionColor = _decisionColor(context, data['ai_decision']);
    final anomalyPct =
        (data['prob_anomaly_pct'] as num?)?.toDouble() ?? 0.0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Real_Device_01',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
              ),
              IconButton(
                onPressed: onRefresh,
                icon:
                    Icon(Icons.refresh_rounded, size: 18.sp, color: primary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: l10n.retry,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ── Energy metrics ─────────────────────────────────────────
          _SectionLabel(
              icon: '⚡',
              title: l10n.energyDashboard,
              color: primary),
          SizedBox(height: 8.h),
          _Row(l10n.watts,
              '${(data['watts'] as num?)?.toStringAsFixed(2) ?? "0"} W',
              warning, hintColor),
          _Row(l10n.voltage,
              '${(data['voltage'] as num?)?.toStringAsFixed(2) ?? "0"} V',
              primary, hintColor),
          _Row(l10n.amperes,
              '${(data['amperes'] as num?)?.toStringAsFixed(2) ?? "0"} A',
              primary, hintColor),
          _Row(l10n.kwh,
              '${(data['kwh_consumed'] as num?)?.toStringAsFixed(2) ?? "0"} kWh',
              SHColors.chartBlue(context), hintColor),
          _Row(l10n.cost,
              '${(data['cost_so_far_egp'] as num?)?.toStringAsFixed(2) ?? "0"} EGP',
              success, hintColor),
          SizedBox(height: 12.h),
          Divider(color: hintColor.withOpacity(0.2)),
          SizedBox(height: 12.h),

          // ── AI analysis ────────────────────────────────────────────
          _SectionLabel(icon: '🤖', title: l10n.aiAnalysis, color: primary),
          SizedBox(height: 8.h),
          _DecisionBadge(
              decision: data['ai_decision'] as String? ?? l10n.notAvailable,
              color: decisionColor),
          SizedBox(height: 8.h),
          _Row(
            l10n.recommendation,
            data['recommendation'] as String? ?? l10n.notAvailable,
            hintColor,
            hintColor,
            multiLine: true,
          ),
          SizedBox(height: 8.h),
          _Row(
            // l10n fallback for 'Anomaly Risk' and 'Normal Confidence'
            l10n.anomaly,
            '${anomalyPct.toStringAsFixed(1)}%',
            anomalyPct > 50 ? errColor : success,
            hintColor,
          ),
          _Row(
            l10n.normal,
            '${(data['prob_normal_pct'] as num?)?.toStringAsFixed(1) ?? "0"}%',
            success,
            hintColor,
          ),
          SizedBox(height: 12.h),
          Divider(color: hintColor.withOpacity(0.2)),
          SizedBox(height: 12.h),

          // ── Environment ────────────────────────────────────────────
          _SectionLabel(
              icon: '🌡️', title: l10n.temperature, color: primary),
          SizedBox(height: 8.h),
          _Row(
            l10n.temperature,
            '${(data['temperature_c'] as num?)?.toStringAsFixed(1) ?? "0"}°C',
            primary, hintColor,
          ),
          _Row(
            l10n.humidity,
            '${(data['humidity_pct'] as num?)?.toStringAsFixed(1) ?? "0"}%',
            primary, hintColor,
          ),
          _Row(
            l10n.lastUpdated,
            data['last_update'] as String? ?? l10n.notAvailable,
            hintColor, hintColor,
            fontSize: 10,
          ),
        ],
      ),
    );
  }

  Color _decisionColor(BuildContext context, dynamic decision) {
    final d = (decision as String?)?.toUpperCase() ?? '';
    if (d.contains('CRITICAL')) return SHColors.severity(context, 'critical');
    if (d.contains('DANGER'))   return SHColors.severity(context, 'danger');
    if (d.contains('WARNING'))  return SHColors.severity(context, 'warning');
    if (d.contains('ANOMALY'))  return SHColors.severity(context, 'danger');
    return SHColors.severity(context, 'normal');
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.title,
    required this.color,
  });
  final String icon, title;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
        '$icon $title',
        style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.5),
      );
}

class _Row extends StatelessWidget {
  const _Row(
    this.label,
    this.value,
    this.valueColor,
    this.hintColor, {
    this.multiLine = false,
    this.fontSize  = 11.0,
  });
  final String label, value;
  final Color  valueColor, hintColor;
  final bool   multiLine;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(bottom: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: multiLine
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Text(label,
                style: TextStyle(fontSize: fontSize.sp, color: hintColor)),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                maxLines: multiLine ? 3 : 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      );
}

class _DecisionBadge extends StatelessWidget {
  const _DecisionBadge(
      {required this.decision, required this.color});
  final String decision;
  final Color  color;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsetsDirectional.symmetric(
            horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Text(
          decision,
          style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: color),
        ),
      );
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.color,
    required this.message,
    required this.buttonLabel,
    this.onTap,
  });
  final IconData icon;
  final Color    color;
  final String   message, buttonLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.sp, color: color, height: 1.4),
            ),
            if (onTap != null) ...[
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onTap,
                  icon: Icon(Icons.refresh_rounded, size: 16.sp),
                  label: Text(buttonLabel),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color),
                    foregroundColor: color,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}
