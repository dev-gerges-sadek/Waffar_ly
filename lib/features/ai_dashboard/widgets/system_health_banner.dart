// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/features/ai_dashboard/cubit/ai_energy_state.dart';
import 'package:waffar_ly_app/features/ai_dashboard/models/ai_result.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';

class SystemHealthBanner extends StatefulWidget {
  const SystemHealthBanner({
    super.key,
    required this.status,
    required this.severity,
    required this.worstDecision,
    required this.totalWatts,
    required this.anomalyPct,
  });

  final SystemHealthStatus status;
  final AiSeverity         severity;
  final String             worstDecision;
  final double             totalWatts;
  final int                anomalyPct;

  @override
  State<SystemHealthBanner> createState() => _SystemHealthBannerState();
}

class _SystemHealthBannerState extends State<SystemHealthBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double>   _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _startOrStop();
  }

  @override
  void didUpdateWidget(covariant SystemHealthBanner old) {
    super.didUpdateWidget(old);
    if (old.status != widget.status) _startOrStop();
  }

  void _startOrStop() {
    if (widget.status == SystemHealthStatus.critical ||
        widget.status == SystemHealthStatus.caution) {
      _pulseCtrl.repeat(reverse: true);
    } else {
      _pulseCtrl
        ..stop()
        ..value = 1.0;
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Color _bannerColor(BuildContext ctx) => switch (widget.status) {
        SystemHealthStatus.healthy  => SHColors.severity(context, 'normal'),
        SystemHealthStatus.caution  => SHColors.severity(context, 'warning'),
        SystemHealthStatus.critical => SHColors.severity(context, 'critical'),
        SystemHealthStatus.loading  => SHColors.primary(ctx),
      };

  String _subtitle(AppLocalizations l10n) {
    final w = widget.totalWatts.toStringAsFixed(0);
    final p = widget.anomalyPct;
    return switch (widget.status) {
      SystemHealthStatus.healthy  => l10n.allClearMessage,
      SystemHealthStatus.caution  =>
        l10n.isArabic
            ? 'احتمالية شذوذ $p% • $w ${l10n.watts}'
            : 'Anomaly prob $p% • $w ${l10n.watts} active',
      SystemHealthStatus.critical =>
        l10n.isArabic
            ? 'تحذير! شذوذ حرج مكتشف • $w ${l10n.watts}'
            : 'Warning! Critical anomaly • $w ${l10n.watts}',
      SystemHealthStatus.loading  =>
        l10n.isArabic ? 'جارٍ تحليل البيانات…' : 'Analysing data…',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final color   = _bannerColor(context);
    final isAlert = widget.status == SystemHealthStatus.critical ||
                    widget.status == SystemHealthStatus.caution;

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) =>
          Opacity(opacity: _pulseAnim.value, child: child),
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(isDark ? 0.22 : 0.14),
              color.withOpacity(isDark ? 0.08 : 0.04),
            ],
            begin: AlignmentDirectional.centerStart,
            end:   AlignmentDirectional.centerEnd,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: color.withOpacity(isAlert ? 0.55 : 0.30),
            width: isAlert ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color:      color.withOpacity(isDark ? 0.15 : 0.08),
              blurRadius: 20,
              offset:     const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Status icon
            Container(
              width:  46.w,
              height: 46.w,
              decoration: BoxDecoration(
                shape:  BoxShape.circle,
                color:  color.withOpacity(0.18),
                border: Border.all(color: color.withOpacity(0.4)),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.status.emoji,
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
            SizedBox(width: 14.w),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.systemStatusLabel}: '
                    '${widget.status.label(l10n.isArabic)}',
                    style: TextStyle(
                      fontSize:   14.sp,
                      fontWeight: FontWeight.w800,
                      color:      color,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    _subtitle(l10n),
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color:    SHColors.text(context).withOpacity(0.7),
                      height:   1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Live dot
            _LiveDot(
              color:   color,
              isAlive: widget.status != SystemHealthStatus.loading,
              l10n:    l10n,
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveDot extends StatefulWidget {
  const _LiveDot({
    required this.color,
    required this.isAlive,
    required this.l10n,
  });
  final Color            color;
  final bool             isAlive;
  final AppLocalizations l10n;

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) => Container(
            width:  8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(0.4 + 0.6 * _ctrl.value),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          widget.l10n.liveBadgeLabel,
          style: TextStyle(
            fontSize:   7.5.sp,
            color:      widget.color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
