import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../core/l10n/app_localizations.dart';

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

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _lightsOn = widget.room.lights.isOn;
    _timerOn  = widget.room.timer.isOn;
  }

  Future<void> _toggleLights(bool val) async {
    setState(() => _lightsOn = val);
    try {
      await _firestore
          .collection('device_states')
          .doc('Lamp_LR_0${widget.room.id}')
          .set({'status': val ? 'ON' : 'OFF'}, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> _toggleTimer(bool val) async {
    setState(() => _timerOn = val);
    // Timer is a local preference — no Firebase needed
  }

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final textColor = SHColors.text(context);

    return SHCard(
      childrenPadding: EdgeInsets.all(12.w),
      children: [
        // Lights column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.lights,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor)),
            SizedBox(height: 8.h),
            SHSwitcher(
              value: _lightsOn,
              onChanged: _toggleLights,
              icon: const Icon(SHIcons.lightBulbOutline),
            ),
          ],
        ),
        // Timer column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.timer,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor)),
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
              onChanged: _toggleTimer,
            ),
          ],
        ),
      ],
    );
  }
}
