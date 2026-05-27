import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    super.key,
    required this.isDark,
    required this.primary,
    required this.textColor,
    required this.onSettings,
  });

  final bool isDark;
  final Color primary;
  final Color textColor;
  final VoidCallback onSettings;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [SHColors.darkBackgroundColor,
                 SHColors.darkBackgroundColor.withOpacity(0.95)]
              : [SHColors.lightBackgroundColor,
                 SHColors.lightBackgroundColor.withOpacity(0.97)],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(color: primary.withOpacity(0.10), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              _BackButton(primary: primary, textColor: textColor),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).dashboardTitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        height: 1.1,
                      ),
                    ),
                    Row(
                      children: [
                        _AiChip(primary: primary),
                        SizedBox(width: 5.w),
                        LiveBadge(color: primary),
                      ],
                    ),
                  ],
                ),
              ),
              _SettingsButton(primary: primary, onTap: onSettings),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.primary, required this.textColor});
  final Color primary, textColor;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 16.sp,
          ),
        ),
      );
}

class _AiChip extends StatelessWidget {
  const _AiChip({required this.primary});
  final Color primary;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          'AI', // product brand token — intentionally always English
          style: TextStyle(
            fontSize: 7.5.sp,
            color: primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.primary, required this.onTap});
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.tune_rounded, color: primary, size: 18.sp),
        ),
      );
}

/// Pulsing LIVE badge — pulse color from SHColors.success, no raw Colors.green.
class LiveBadge extends StatefulWidget {
  const LiveBadge({super.key, required this.color});
  final Color color;

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final success = SHColors.success(context);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) => Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: success.withOpacity(0.15 + 0.10 * _ctrl.value),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: success.withOpacity(0.6 + 0.4 * _ctrl.value),
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              AppLocalizations.of(context).liveBadgeLabel,
              style: TextStyle(
                fontSize: 7.5.sp,
                color: success,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
