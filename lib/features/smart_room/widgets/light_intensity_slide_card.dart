import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../core/core.dart';
import '../data/smart_room_repository.dart';

class LightIntensitySliderCard extends StatefulWidget {
  const LightIntensitySliderCard({required this.room, super.key});
  final SmartRoom room;

  @override
  State<LightIntensitySliderCard> createState() =>
      _LightIntensitySliderCardState();
}

class _LightIntensitySliderCardState extends State<LightIntensitySliderCard> {
  late double _intensity;
  late bool _lightsOn;

  final _repo = GetIt.I<SmartRoomRepository>();

  @override
  void initState() {
    super.initState();
    _intensity = (widget.room.lights.value / 100).clamp(0.0, 1.0);
    _lightsOn = widget.room.lights.isOn;
  }

  Future<void> _onIntensityChanged(double value) async {
    setState(() => _intensity = value);
    try {
      await _repo.updateLight(
        deviceId: 'Lamp_LR_0${widget.room.id}',
        isOn: _lightsOn,
        intensity: (value * 100).roundToDouble(),
      );
    } catch (e) {
      debugPrint('[LightIntensity] Failed to update light: $e');
    }
  }

  Future<void> _onToggle(bool val) async {
    setState(() => _lightsOn = val);
    try {
      await _repo.updateLight(
        deviceId: 'Lamp_LR_0${widget.room.id}',
        isOn: val,
      );
    } catch (e) {
      debugPrint('[LightIntensity] Failed to toggle light: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = SHColors.text(context);
    final primaryColor = SHColors.primary(context);
    final trackColor = SHColors.track(context);
    final hintColor = SHColors.hint(context);

    return SHCard(
      childrenPadding: EdgeInsets.all(12.w),
      children: [
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
                    color: _lightsOn ? primaryColor : hintColor,
                  ),
                ),
              ),
            ),
            SHSwitcher(value: _lightsOn, onChanged: _onToggle),
          ],
        ),
        Row(
          children: [
            Icon(SHIcons.lightMin, color: textColor, size: 18.sp),
            Expanded(
              child: Slider(
                value: _intensity,
                onChanged: _lightsOn ? _onIntensityChanged : null,
                activeColor: _lightsOn ? primaryColor : hintColor,
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
