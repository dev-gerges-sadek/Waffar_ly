// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/core/theme/sh_colors.dart';
import 'package:waffar_ly_app/core/theme/sh_icons.dart';
import 'room_search_sheet.dart';

class ShAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShAppBar({
    this.showSettings = true,
    this.onSettingsTap,
    this.onMenuTap,
    super.key,
  });

  final bool         showSettings;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final isDark       = Theme.of(context).brightness == Brightness.dark;
    final buttonBgColor = isDark ? SHColors.darkCardColor : SHColors.lightCardColor;
    final iconColor     = isDark ? SHColors.darkTextColor  : SHColors.lightTextColor;
    final shadowColor = isDark ? SHColors.darkShadowColor : SHColors.lightShadowColor;

    return AppBar(
      elevation:       0,
      backgroundColor: Colors.transparent,
      // Flutter automatically mirrors leading/actions for RTL
      automaticallyImplyLeading: false,
      leading: Hero(
        tag: 'app-bar-icon-1',
        child: Material(
          type: MaterialType.transparency,
          child: _AppBarButton(
            bgColor:     buttonBgColor,
            shadowColor: shadowColor,
            isDark:      isDark,
            icon:        Icon(SHIcons.menu, color: iconColor),
            onTap:       onMenuTap ?? () {},
          ),
        ),
      ),
      actions: [
        Hero(
          tag: 'app-bar-icon-2',
          child: Material(
            type: MaterialType.transparency,
            child: _AppBarButton(
              bgColor:     buttonBgColor,
              shadowColor: shadowColor,
              isDark:      isDark,
              icon:        Icon(SHIcons.search, color: iconColor),
              onTap:       () => _showRoomSearch(context),
            ),
          ),
        ),
        if (showSettings)
          Hero(
            tag: 'app-bar-icon-3',
            child: Material(
              type: MaterialType.transparency,
              child: _AppBarButton(
                bgColor:     buttonBgColor,
                shadowColor: shadowColor,
                isDark:      isDark,
                icon:        Icon(SHIcons.settings, color: iconColor),
                onTap:       onSettingsTap ?? () {},
              ),
            ),
          ),
        SizedBox(width: 8.w),
      ],
    );
  }

  void _showRoomSearch(BuildContext context) {
    showModalBottomSheet(
      context:          context,
      isScrollControlled: true,
      backgroundColor:  Colors.transparent,
      builder:          (_) => const RoomSearchSheet(),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight + 8.h);
}

// ── Small reusable AppBar button ─────────────────────────────────────────────

class _AppBarButton extends StatelessWidget {
  const _AppBarButton({
    required this.bgColor,
    required this.shadowColor,
    required this.isDark,
    required this.icon,
    required this.onTap,
  });

  final Color bgColor, shadowColor;
  final bool  isDark;
  final Icon  icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color:        bgColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color:     shadowColor.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon:      icon,
        iconSize:  24.sp,
      ),
    );
  }
}

// ── Back-button AppBar variant ────────────────────────────────────────────────

class ShBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShBackAppBar({
    super.key,
    required this.title,
    this.trailing,
  });

  final String  title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? SHColors.darkTextColor : SHColors.lightTextColor;
    final isRtl     = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      elevation:       0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          isRtl
              ? Icons.arrow_forward_ios_outlined
              : Icons.arrow_back_ios_new_rounded,
          color: iconColor,
          size:  20,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      title:   title.isEmpty ? null : Text(title),
      actions: trailing != null
          ? [trailing!, SizedBox(width: 8.w)]
          : null,
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);
}
