// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../../../alert/screens/alerts_screen.dart';
import '../../../chatbot/screens/chatbot_screen.dart';
import '../../../energy/screens/energy_dashboard_screen.dart';
import '../../../weather/screens/weather_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.onNavigate});
  final void Function(Widget screen) onNavigate;

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final bgColor   = isDark
        ? SHColors.darkBackgroundColor
        : SHColors.lightBackgroundColor;
    final cardColor = SHColors.card(context);
    final primary   = SHColors.primary(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Drawer(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight:    Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
              child: Row(
                children: [
                  Container(
                    width: 46.w,
                    height: 46.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark
                            ? SHColors.darkPrimaryGradient
                            : SHColors.lightPrimaryGradient,
                      ),
                    ),
                    child: Icon(Icons.home_rounded,
                        color: Colors.white, size: 24.sp),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Smart Home',
                        style: TextStyle(
                            fontSize: 11.sp, color: hintColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),
            Divider(
                color: hintColor.withOpacity(0.15),
                indent: 20.w,
                endIndent: 20.w),
            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'FEATURES',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: hintColor,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // ── Feature tiles ────────────────────────────────────────────
            _DrawerTile(
              icon: Icons.wb_sunny_outlined,
              label: l10n.weather,
              color: Colors.orange,
              cardColor: cardColor,
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                onNavigate(const WeatherScreen());
              },
            ),
            _DrawerTile(
              icon: Icons.bolt_rounded,
              label: l10n.energyDashboard,
              color: primary,
              cardColor: cardColor,
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                onNavigate(const EnergyDashboardScreen());
              },
            ),
            _DrawerTile(
              icon: Icons.warning_amber_rounded,
              label: l10n.anomalyAlerts,
              color: SHColors.lightWarningColor,
              cardColor: cardColor,
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                onNavigate(const AlertsScreen());
              },
            ),
            _DrawerTile(
              icon: Icons.smart_toy_rounded,
              label: l10n.waffarAI,
              color: isDark
                  ? SHColors.darkSecondaryColor
                  : SHColors.lightSecondaryColor,
              cardColor: cardColor,
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                onNavigate(const ChatbotScreen());
              },
            ),

            const Spacer(),

            Divider(
                color: hintColor.withOpacity(0.15),
                indent: 20.w,
                endIndent: 20.w),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Text(
                'v1.0.0  ·  Waffar',
                style:
                    TextStyle(fontSize: 10.sp, color: hintColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single drawer tile ─────────────────────────────────────────────────────────
class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.cardColor,
    required this.textColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r)),
        tileColor: cardColor,
        leading: Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
          ),
          child: Icon(icon, color: color, size: 18.sp),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 13, color: color.withOpacity(0.6)),
      ),
    );
  }
}
