// ============================================================================
// top_devices_card.dart
// Ranked list of top 5 energy-consuming devices.
// Gold / silver / bronze colours for top 3 ranks, relative consumption bars.
// ============================================================================

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../models/energy_record.dart';

class TopDevicesCard extends StatelessWidget {
  const TopDevicesCard({super.key, required this.topDevices});
  final List<EnergyRecord> topDevices;

  @override
  Widget build(BuildContext context) {
    if (topDevices.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final maxKwh = topDevices.first.kwh;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: SHColors.card(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: SHColors.hint(context).withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Row(
            children: [
              Icon(
                Icons.leaderboard_rounded,
                size: 14.sp,
                color: SHColors.rank(context, 0),
              ),
              SizedBox(width: 6.w),
              Text(
                l10n.topConsumingDevices,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: SHColors.rank(context, 0),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Device rows
          ...topDevices.asMap().entries.map(
            (entry) => DeviceRow(
              rank: entry.key + 1,
              record: entry.value,
              maxKwh: maxKwh,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual device row (exported for reuse) ────────────────────────────────

class DeviceRow extends StatelessWidget {
  const DeviceRow({
    super.key,
    required this.rank,
    required this.record,
    required this.maxKwh,
  });

  final int rank;
  final EnergyRecord record;
  final double maxKwh;

  Color _rankColor(BuildContext context) {
    switch (rank) {
      case 1:
        return SHColors.rank(context, 1);
      case 2:
        return SHColors.rank(context, 2);
      case 3:
        return SHColors.rank(context, 3);
      default:
        return SHColors.primary(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final rankColor = _rankColor(context);
    final pct = maxKwh > 0 ? record.kwh / maxKwh : 0.0;

    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 8.h),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 11.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: SHColors.background(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: rank <= 3
              ? rankColor.withOpacity(0.25)
              : SHColors.hint(context).withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank circle
              Container(
                width: 30.w,
                height: 30.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rankColor.withOpacity(0.15),
                  border: Border.all(color: rankColor.withOpacity(0.35)),
                ),
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w800,
                    color: rankColor,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Device name + watts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translateDeviceOrRoomName(record.deviceName),
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${record.watts.toStringAsFixed(1)} ${l10n.watts}',
                      style: TextStyle(fontSize: 9.sp, color: hintColor),
                    ),
                  ],
                ),
              ),

              // kWh value
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    record.kwh.toStringAsFixed(3),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: rankColor,
                    ),
                  ),
                  Text(
                    l10n.kwh,
                    style: TextStyle(fontSize: 8.sp, color: hintColor),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 7.h),

          // Relative consumption bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              minHeight: 4.h,
              backgroundColor: rankColor.withOpacity(0.10),
              valueColor: AlwaysStoppedAnimation(rankColor.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
