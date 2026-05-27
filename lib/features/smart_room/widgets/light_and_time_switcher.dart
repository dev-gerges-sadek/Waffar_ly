import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../core/core.dart';
import '../data/smart_room_repository.dart';

class LightsAndTimerSwitchers extends StatefulWidget {
  const LightsAndTimerSwitchers({required this.room, super.key});
  final SmartRoom room;

  @override
  State<LightsAndTimerSwitchers> createState() =>
      _LightsAndTimerSwitchersState();
}

class _LightsAndTimerSwitchersState extends State<LightsAndTimerSwitchers> {
  late bool _lightsOn;
  late bool _timerOn;

  final _repo = GetIt.I<SmartRoomRepository>();

  @override
  void initState() {
    super.initState();
    _lightsOn = widget.room.lights.isOn;
    _timerOn = widget.room.timer.isOn;
  }

  Future<void> _toggleLights(bool val) async {
    setState(() => _lightsOn = val);
    try {
      await _repo.updateLight(
        deviceId: 'Lamp_LR_0${widget.room.id}',
        isOn: val,
      );
    } catch (e) {
      debugPrint('[LightTimeSwitcher] Failed to toggle light: $e');
    }
  }

  // Timer is local-only — no Firebase write needed
  void _toggleTimer(bool val) => setState(() => _timerOn = val);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = SHColors.text(context);

    return SHCard(
      childrenPadding: EdgeInsets.all(12.w),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.lights,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            SizedBox(height: 8.h),
            SHSwitcher(
              value: _lightsOn,
              onChanged: _toggleLights,
              icon: const Icon(SHIcons.lightBulbOutline),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.timer,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                const BlueLightDot(),
              ],
            ),
            SizedBox(height: 8.h),
            SHSwitcher(
              icon: _timerOn
                  ? const Icon(SHIcons.timer)
                  : const Icon(SHIcons.timerOff),
              value: _timerOn,
              onChanged: (_) => _toggleTimer(!_timerOn),
            ),
          ],
        ),
      ],
    );
  }
}
