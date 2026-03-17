import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../core/l10n/app_localizations.dart';

class LightIntensitySliderCard extends StatefulWidget {
  const LightIntensitySliderCard({required this.room, super.key});
  final SmartRoom room;

  @override
  State<LightIntensitySliderCard> createState() =>
      _LightIntensitySliderCardState();
}

class _LightIntensitySliderCardState
    extends State<LightIntensitySliderCard> {
  late double _intensity;
  late bool   _lightsOn;

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _intensity = (widget.room.lights.value / 100).clamp(0.0, 1.0);
    _lightsOn  = widget.room.lights.isOn;
  }

  Future<void> _onIntensityChanged(double value) async {
    setState(() => _intensity = value);
    try {
      await _firestore
          .collection('device_states')
          .doc('Lamp_LR_0${widget.room.id}')
          .set({
        'intensity':    (value * 100).round(),
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> _onToggle(bool val) async {
    setState(() => _lightsOn = val);
    try {
      await _firestore
          .collection('device_states')
          .doc('Lamp_LR_0${widget.room.id}')
          .set({
        'status':       val ? 'ON' : 'OFF',
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n         = AppLocalizations.of(context);
    final textColor    = SHColors.text(context);
    final primaryColor = SHColors.primary(context);
    final trackColor   = SHColors.track(context);

    return SHCard(
      childrenPadding: EdgeInsets.all(12.w),
      children: [
        // Header: label + percentage + toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  l10n.lightIntensity,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${(_intensity * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: _lightsOn ? primaryColor : SHColors.hint(context),
                  ),
                ),
              ),
            ),
            SHSwitcher(
              value: _lightsOn,
              onChanged: _onToggle,
            ),
          ],
        ),

        // Slider row
        Row(
          children: [
            Icon(SHIcons.lightMin, color: textColor, size: 18.sp),
            Expanded(
              child: Slider(
                value: _intensity,
                onChanged: _lightsOn ? _onIntensityChanged : null,
                activeColor:   _lightsOn ? primaryColor : SHColors.hint(context),
                inactiveColor: trackColor,
              ),
            ),
            Icon(SHIcons.lightMax, color: textColor, size: 18.sp),
          ],
        ),
      ],
    );
  }
}
