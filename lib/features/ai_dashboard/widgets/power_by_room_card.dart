// ============================================================================
// power_by_room_card.dart
// Room-by-room energy breakdown with colour-coded progress bars.
// High-consumption rooms shift toward red/orange.
// ============================================================================

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../models/energy_record.dart';

class PowerByRoomCard extends StatelessWidget {
  const PowerByRoomCard({
    super.key,
    required this.roomBreakdown,
    required this.totalKwh,
  });

  final List<RoomEnergy> roomBreakdown;
  final double totalKwh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primary = SHColors.primary(context);

    if (roomBreakdown.isEmpty) {
      return _EmptyRooms(l10n: l10n);
    }

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
              Icon(Icons.home_rounded, size: 14.sp, color: primary),
              SizedBox(width: 6.w),
              Text(
                l10n.powerByRoomTitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 7.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${totalKwh.toStringAsFixed(2)} ${l10n.kwh}',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Room rows
          ...roomBreakdown.asMap().entries.map(
            (entry) => _RoomRow(
              room: entry.value,
              total: totalKwh,
              rank: entry.key,
              isTop: entry.key == 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Room row ──────────────────────────────────────────────────────────────────

class _RoomRow extends StatelessWidget {
  const _RoomRow({
    required this.room,
    required this.total,
    required this.rank,
    required this.isTop,
  });

  final RoomEnergy room;
  final double total;
  final int rank;
  final bool isTop;

  Color _barColor(double pct, BuildContext context) {
    if (pct > 0.40) return SHColors.severity(context, 'critical');
    if (pct > 0.25) return SHColors.severity(context, 'danger');
    if (pct > 0.15) return SHColors.severity(context, 'warning');
    return SHColors.primary(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final pct = total > 0 ? room.totalKwh / total : 0.0;
    final barColor = _barColor(pct, context);

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Rank badge
              Container(
                width: 20.w,
                height: 20.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: barColor.withOpacity(0.15),
                ),
                child: Text(
                  '${rank + 1}',
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                    color: barColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  l10n.translateDeviceOrRoomName(room.roomName),
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: textColor,
                    fontWeight: isTop ? FontWeight.w700 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // kWh + %
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${room.totalKwh.toStringAsFixed(2)} ',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: barColor,
                      ),
                    ),
                    TextSpan(
                      text: '${l10n.kwh}  ',
                      style: TextStyle(fontSize: 8.5.sp, color: hintColor),
                    ),
                    TextSpan(
                      text: '${(pct * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              minHeight: 6.h,
              backgroundColor: barColor.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyRooms extends StatelessWidget {
  const _EmptyRooms({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      color: SHColors.card(context),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Center(
      child: Column(
        children: [
          Icon(Icons.home_outlined, size: 32.sp, color: SHColors.hint(context)),
          SizedBox(height: 8.h),
          Text(
            l10n.isArabic ? 'لا توجد بيانات للغرف' : 'No room data available',
            style: TextStyle(fontSize: 12.sp, color: SHColors.hint(context)),
          ),
        ],
      ),
    ),
  );
}
