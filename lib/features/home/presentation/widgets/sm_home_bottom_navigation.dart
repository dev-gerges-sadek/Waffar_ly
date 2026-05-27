// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../screens/settings_screen.dart';
import 'emergency_nav_button.dart';

/// Bottom navigation bar for the Home screen.
/// Slides out when a room selector overlay is visible.
class SmHomeBottomNavigationBar extends StatefulWidget {
  const SmHomeBottomNavigationBar({
    super.key,
    required this.roomSelectorNotifier,
    required this.onNavigate,
  });

  final ValueNotifier<int> roomSelectorNotifier;
  final void Function(Widget) onNavigate;

  @override
  State<SmHomeBottomNavigationBar> createState() =>
      _SmHomeBottomNavigationBarState();
}

class _SmHomeBottomNavigationBarState extends State<SmHomeBottomNavigationBar> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) widget.onNavigate(const SettingsScreen());
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final primary = SHColors.primary(context);
    final hintColor = SHColors.hint(context);
    final cardColor = SHColors.card(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: ValueListenableBuilder<int>(
        valueListenable: widget.roomSelectorNotifier,
        builder: (_, value, child) => AnimatedOpacity(
          duration: kThemeAnimationDuration,
          opacity: value != -1 ? 0 : 1,
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            transform: Matrix4.translationValues(
              0,
              value != -1 ? -30.0 : 0.0,
              0,
            ),
            child: child,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: SHColors.shadow(context),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.person_outline_rounded,
                label: l10n.settings,
                isSelected: _selectedIndex == 0,
                primary: primary,
                hintColor: hintColor,
                onTap: () => _onItemTapped(0),
              ),
              NavItem(
                icon: SHIcons.home,
                label: l10n.appName,
                isSelected: _selectedIndex == 1,
                primary: primary,
                hintColor: hintColor,
                onTap: () => _onItemTapped(1),
              ),
              EmergencyNavButton(primary: primary),
            ],
          ),
        ),
      ),
    );
  }
}
