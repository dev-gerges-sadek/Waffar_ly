import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/shared/domain/entities/smart_room.dart';
import '../../../core/theme/sh_colors.dart';

class RoomHeroAppBar extends StatelessWidget {
  const RoomHeroAppBar({super.key, required this.room});
  final SmartRoom room;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = SHColors.primary(context);
    final success = SHColors.success(context);
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    // Semi-transparent overlay: dark scrim over hero image
    final scrim = isDark
        ? SHColors.darkShadowColor.withOpacity(0.6)
        : SHColors.lightShadowColor.withOpacity(0.5);

    return SliverAppBar(
      expandedHeight: 230.h,
      pinned: true,
      stretch: true,
      backgroundColor: isDark
          ? SHColors.darkBackgroundColor
          : SHColors.lightBackgroundColor,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: scrim,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: onPrimary,
            size: 18,
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 10.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: scrim,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 7, color: success),
              SizedBox(width: 5.w),
              Text(
                l10n.live,
                style: TextStyle(
                  color: onPrimary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              room.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: primary.withOpacity(0.2),
                child: Icon(Icons.home, size: 80, color: primary),
              ),
            ),
            // Gradient scrim — uses shadow token, not hardcoded Color(0x...)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                  colors: [
                    SHColors.lightShadowColor,
                    SHColors.darkShadowColor.withOpacity(0.75),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      l10n.translateDeviceOrRoomName(room.name),
                      style: TextStyle(
                        color: onPrimary,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 8.w,
                    children: [
                      _HeaderPill(
                        label: '${room.temperature.toInt()}°C',
                        icon: Icons.thermostat_rounded,
                        onPrimary: onPrimary,
                        scrim: scrim,
                      ),
                      _HeaderPill(
                        label: '${room.airHumidity.toInt()}% ${l10n.humidity}',
                        icon: Icons.water_drop_outlined,
                        onPrimary: onPrimary,
                        scrim: scrim,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({
    required this.label,
    required this.icon,
    required this.onPrimary,
    required this.scrim,
  });
  final String label;
  final IconData icon;
  final Color onPrimary, scrim;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: scrim,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: onPrimary.withOpacity(0.8)),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
