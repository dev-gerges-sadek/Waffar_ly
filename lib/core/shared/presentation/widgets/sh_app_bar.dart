// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/core/shared/domain/entities/smart_room.dart';
import 'package:waffar_ly_app/core/theme/sh_colors.dart';
import 'package:waffar_ly_app/core/theme/sh_icons.dart';


class ShAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShAppBar({
    this.showSettings = true,
    this.onSettingsTap,
    this.onMenuTap,
    super.key,
  });

  final bool showSettings;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode   = Theme.of(context).brightness == Brightness.dark;
    final buttonBgColor = isDarkMode ? SHColors.darkCardColor : SHColors.lightCardColor;
    final iconColor     = isDarkMode ? SHColors.darkTextColor  : SHColors.lightTextColor;
    const shadowColor   = Colors.black;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Hero(
        tag: 'app-bar-icon-1',
        child: Material(
          type: MaterialType.transparency,
          child: _AppBarButton(
            bgColor: buttonBgColor,
            shadowColor: shadowColor,
            isDark: isDarkMode,
            icon: Icon(SHIcons.menu, color: iconColor),
            onTap: onMenuTap ?? () {},
          ),
        ),
      ),
      actions: [
        // ✅ Search button — opens room search dialog
        Hero(
          tag: 'app-bar-icon-2',
          child: Material(
            type: MaterialType.transparency,
            child: _AppBarButton(
              bgColor: buttonBgColor,
              shadowColor: shadowColor,
              isDark: isDarkMode,
              icon: Icon(SHIcons.search, color: iconColor),
              onTap: () => _showRoomSearch(context),
            ),
          ),
        ),
        if (showSettings)
          Hero(
            tag: 'app-bar-icon-3',
            child: Material(
              type: MaterialType.transparency,
              child: _AppBarButton(
                bgColor: buttonBgColor,
                shadowColor: shadowColor,
                isDark: isDarkMode,
                icon: Icon(SHIcons.settings, color: iconColor),
                onTap: onSettingsTap ?? () {},
              ),
            ),
          ),
        SizedBox(width: 8.w),
      ],
    );
  }

  /// Opens a search modal that filters rooms and navigates on tap
  void _showRoomSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RoomSearchSheet(parentContext: context),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight + 8.h);
}

// ─── Small reusable AppBar button ─────────────────────────────────────────────
class _AppBarButton extends StatelessWidget {
  const _AppBarButton({
    required this.bgColor,
    required this.shadowColor,
    required this.isDark,
    required this.icon,
    required this.onTap,
  });

  final Color bgColor;
  final Color shadowColor;
  final bool  isDark;
  final Icon  icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: icon,
        iconSize: 24.sp,
      ),
    );
  }
}

// ─── Room Search Bottom Sheet ──────────────────────────────────────────────────
class _RoomSearchSheet extends StatefulWidget {
  const _RoomSearchSheet({required this.parentContext});
  final BuildContext parentContext;

  @override
  State<_RoomSearchSheet> createState() => _RoomSearchSheetState();
}

class _RoomSearchSheetState extends State<_RoomSearchSheet> {
  final _ctrl = TextEditingController();
  List<SmartRoom> _results = SmartRoom.fakeValues;

  void _filter(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      _results = q.isEmpty
          ? SmartRoom.fakeValues
          : SmartRoom.fakeValues
              .where((r) => r.name.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final bgColor   = isDark ? SHColors.darkCardColor : SHColors.lightCardColor;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary   = SHColors.primary(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: hintColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Search Rooms',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            SizedBox(height: 12.h),
            // Search field
            TextField(
              controller: _ctrl,
              onChanged: _filter,
              autofocus: true,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'e.g. Living Room, Kitchen...',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.search, color: hintColor),
                filled: true,
                fillColor: isDark
                    ? SHColors.darkSurfaceColor
                    : SHColors.lightSurfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: primary, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Results list
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Text(
                        'No rooms found',
                        style: TextStyle(color: hintColor),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: _results.length,
                      separatorBuilder: (_, _) => Divider(
                        color: hintColor.withOpacity(0.15),
                        height: 1,
                      ),
                      itemBuilder: (_, i) {
                        final room = _results[i];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 4.h),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset(
                              room.imageUrl,
                              width: 52.w,
                              height: 52.w,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 52.w,
                                height: 52.w,
                                color: primary.withOpacity(0.2),
                                child: Icon(Icons.home, color: primary),
                              ),
                            ),
                          ),
                          title: Text(
                            room.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              fontSize: 14.sp,
                            ),
                          ),
                          subtitle: Text(
                            '${room.temperature}° · Humidity ${room.airHumidity}%',
                            style: TextStyle(
                              color: hintColor,
                              fontSize: 11.sp,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: hintColor,
                          ),
                          onTap: () {
                            Navigator.pop(context); // close sheet
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
