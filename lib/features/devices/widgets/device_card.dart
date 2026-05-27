import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/devices_cubit.dart';
import '../models/device_model.dart';
import 'device_data_badge.dart';
import 'device_detail_sheet.dart';
import 'device_icon.dart';

class DeviceCard extends StatefulWidget {
  const DeviceCard({super.key, required this.device});
  final DeviceModel device;

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool _isSimulationTab = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = SHColors.card(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary = SHColors.primary(context);
    final surface = SHColors.surface(context);
    final shadow = SHColors.shadow(context);
    final hwColor = isDark
        ? SHColors.darkWarningColor
        : SHColors.lightWarningColor;
    final success = isDark
        ? SHColors.darkSuccessColor
        : SHColors.lightSuccessColor;
    final errColor = isDark
        ? SHColors.darkErrorColor
        : SHColors.lightErrorColor;

    final hwOnline =
        widget.device.hardwareSensor?.status == SensorStatus.online;
    final isPowerOn = widget.device.simulationData?.isOn ?? false;
    final activeColor = isPowerOn ? primary : hintColor.withOpacity(0.4);

    return GestureDetector(
      onTap: () => showDeviceDetailSheet(context, widget.device),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            // SHColors.surface at 0 opacity ≡ transparent — no raw Colors.transparent
            color: isPowerOn
                ? primary.withOpacity(0.3)
                : surface.withOpacity(0),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Opacity(
          opacity: isPowerOn ? 1.0 : 0.8,
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Icon row + hw status dot
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: activeColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        height: 22.h,
                        width: 22.w,
                        child: DeviceIcon(
                          type: widget.device.type,
                          isOn: isPowerOn,
                          hwOnline: hwOnline,
                          primary: primary,
                          hint: hintColor,
                        ),
                      ),
                    ),
                    Container(
                      width: 7.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                        color: hwOnline ? success : errColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // 2. Name + toggle
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.translateDeviceOrRoomName(widget.device.name),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      width: 28.w,
                      height: 18.h,
                      child: Transform.scale(
                        scale: 0.65,
                        alignment: AlignmentDirectional.centerEnd,
                        child: Switch.adaptive(
                          value: isPowerOn,
                          activeColor: primary,
                          onChanged: (val) => context
                              .read<DevicesCubit>()
                              .toggleSimulation(widget.device.id, val),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                // 3. Segmented source slider
                Container(
                  height: 30.h,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      _SourceTab(
                        label: l10n.simulation,
                        selected: _isSimulationTab,
                        color: primary,
                        cardColor: cardColor,
                        hintColor: hintColor,
                        shadow: shadow,
                        onTap: () => setState(() => _isSimulationTab = true),
                      ),
                      _SourceTab(
                        label: l10n.hardware,
                        selected: !_isSimulationTab,
                        color: hwColor,
                        cardColor: cardColor,
                        hintColor: hintColor,
                        shadow: shadow,
                        onTap: () => setState(() => _isSimulationTab = false),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // 4. Dynamic content area
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: !isPowerOn
                      ? Container(
                          key: const ValueKey('power_off_view'),
                          height: 75.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: hintColor.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Center(
                            child: Text(
                              l10n.powerOff,
                              style: TextStyle(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w600,
                                color: hintColor.withOpacity(0.35),
                              ),
                            ),
                          ),
                        )
                      : _isSimulationTab
                      ? SizedBox(
                          key: const ValueKey('simulation_data'),
                          height: 75.h,
                          width: double.infinity,
                          child: DeviceDataBadge(
                            tag: DataSourceTag.simulation,
                            data: widget.device.simulationData,
                          ),
                        )
                      : Container(
                          key: const ValueKey('hardware_offline'),
                          height: 75.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: hwColor.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: hwColor.withOpacity(0.06),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_off_rounded,
                                size: 15.sp,
                                color: hwColor.withOpacity(0.25),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                l10n.hardwareOffline,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: hwColor.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 12.h),

                // 5. Footer hint
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.unfold_more_rounded,
                        size: 11.sp,
                        color: hintColor.withOpacity(0.4),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        l10n.tapDetails,
                        style: TextStyle(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w500,
                          color: hintColor.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SourceTab extends StatelessWidget {
  const _SourceTab({
    required this.label,
    required this.selected,
    required this.color,
    required this.cardColor,
    required this.hintColor,
    required this.shadow,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color, cardColor, hintColor, shadow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected
                ? cardColor
                : SHColors.surface(context).withOpacity(0),
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: selected
                ? [BoxShadow(color: shadow, blurRadius: 3)]
                : [],
          ),
          alignment: AlignmentDirectional.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? color : hintColor.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
