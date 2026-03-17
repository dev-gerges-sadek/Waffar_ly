// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/core.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../presentation/screens/settings_screen.dart';

class SmHomeBottomNavigationBar extends StatefulWidget {
  const SmHomeBottomNavigationBar({
    super.key,
    required this.roomSelectorNotifier,
    required this.onNavigate,
  });

  final ValueNotifier<int>                 roomSelectorNotifier;
  final void Function(Widget screen) onNavigate;

  @override
  State<SmHomeBottomNavigationBar> createState() =>
      _SmHomeBottomNavigationBarState();
}

class _SmHomeBottomNavigationBarState
    extends State<SmHomeBottomNavigationBar> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      widget.onNavigate(const SettingsScreen());
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final primary   = SHColors.primary(context);
    final hintColor = SHColors.hint(context);
    final cardColor = SHColors.card(context);
    AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: ValueListenableBuilder<int>(
        valueListenable: widget.roomSelectorNotifier,
        builder: (_, value, child) => AnimatedOpacity(
          duration: kThemeAnimationDuration,
          opacity: value != -1 ? 0 : 1,
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            transform:
                Matrix4.translationValues(0, value != -1 ? -30.0 : 0.0, 0),
            child: child,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isSelected: _selectedIndex == 0,
                primary: primary,
                hintColor: hintColor,
                onTap: () => _onItemTapped(0),
              ),
              _NavItem(
                icon: SHIcons.home,
                label: 'Home',
                isSelected: _selectedIndex == 1,
                primary: primary,
                hintColor: hintColor,
                onTap: () => _onItemTapped(1),
              ),
              // ── Center emergency FAB-like button ──────────────────────
              _EmergencyNavButton(primary: primary),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Emergency button inside nav bar ───────────────────────────────────────────
class _EmergencyNavButton extends StatelessWidget {
  const _EmergencyNavButton({required this.primary});
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmShutoff(context),
      child: Container(
        width: 52.w,
        height: 52.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.40),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.power_settings_new_rounded,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }

  Future<void> _confirmShutoff(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)),
        title: const Text(
          'Emergency Shutoff',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'This will turn OFF ALL devices immediately.\n\nAre you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: TextStyle(color: SHColors.hint(context))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Shut Off Everything',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All devices turned OFF'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

// ── Nav item ───────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.primary,
    required this.hintColor,
    required this.onTap,
  });

  final IconData icon;
  final String   label;
  final bool     isSelected;
  final Color    primary;
  final Color    hintColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? primary : hintColor, size: 22.sp),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? primary : hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
