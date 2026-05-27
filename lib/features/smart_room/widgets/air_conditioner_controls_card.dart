// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/core.dart';
import '../data/smart_room_repository.dart';

class AirConditionerControlsCard extends StatefulWidget {
  const AirConditionerControlsCard({required this.room, super.key});
  final SmartRoom room;

  @override
  State<AirConditionerControlsCard> createState() =>
      _AirConditionerControlsCardState();
}

class _AirConditionerControlsCardState
    extends State<AirConditionerControlsCard> {
  late bool _isOn;
  late int _temp;
  int _fanSpeed = 2;
  String _mode = 'Cool';

  // Injected — no direct FirebaseFirestore
  final _repo = GetIt.I<SmartRoomRepository>();

  static const Map<String, int> _modeDefaultTemp = {
    'Cool': 20,
    'Heat': 24,
    'Fan': 22,
    'Dry': 22,
  };

  @override
  void initState() {
    super.initState();
    _isOn = widget.room.airCondition.isOn;
    final raw = widget.room.airCondition.value;
    _temp = (raw < 16 || raw > 30) ? 20 : raw;
  }

  Future<void> _setMode(String mode) async {
    if (!_isOn) return;
    setState(() {
      _mode = mode;
      _temp = _modeDefaultTemp[mode] ?? 20;
    });
    await _push();
  }

  Future<void> _changeTemp(int delta) async {
    if (!_isOn) return;
    final next = _temp + delta;
    if (next < 16 || next > 30) return;
    setState(() => _temp = next);
    await _push();
  }

  Future<void> _togglePower(bool val) async {
    setState(() => _isOn = val);
    await _push();
  }

  Future<void> _push() async {
    try {
      await _repo.updateAc(
        roomId: int.parse(widget.room.id),
        isOn: _isOn,
        temperature: _temp.toInt(),
        mode: _mode,
        fanSpeed: _fanSpeed,
      );
    } catch (e) {
      debugPrint('[AirconditionerControls] Failed to update AC: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary = SHColors.primary(context);
    final track = SHColors.track(context);

    final modes = [
      _ModeData(SHIcons.snowFlake, l10n.cool, 'Cool'),
      _ModeData(Icons.whatshot_outlined, l10n.heat, 'Heat'),
      _ModeData(SHIcons.wind, l10n.fan, 'Fan'),
      _ModeData(SHIcons.waterDrop, l10n.dry, 'Dry'),
    ];
    final speedLabels = ['', l10n.low, l10n.mid, l10n.high];

    return SHCard(
      childrenPadding: EdgeInsets.all(12.w),
      children: [
        // ── Header: title + power + temp ─────────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.airConditioning,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: SHSwitcher(
                    icon: const Icon(SHIcons.fan),
                    value: _isOn,
                    onChanged: _togglePower,
                  ),
                ),
                const Spacer(),
                _TempBtn(
                  icon: Icons.remove,
                  enabled: _isOn,
                  primary: primary,
                  hintColor: hintColor,
                  onTap: () => _changeTemp(-1),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w),
                  child: Text(
                    '$_temp°',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: _isOn ? textColor : hintColor,
                    ),
                  ),
                ),
                _TempBtn(
                  icon: Icons.add,
                  enabled: _isOn,
                  primary: primary,
                  hintColor: hintColor,
                  onTap: () => _changeTemp(1),
                ),
              ],
            ),
          ],
        ),

        // ── Mode row ──────────────────────────────────────────────────
        Row(
          children: [
            ...modes.map(
              (m) => Padding(
                padding: EdgeInsetsDirectional.only(end: 8.w),
                child: _ModeBtn(
                  icon: m.icon,
                  label: m.label,
                  selected: _mode == m.key,
                  enabled: _isOn,
                  primary: primary,
                  hintColor: hintColor,
                  onTap: () => _setMode(m.key),
                ),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Icon(SHIcons.fan, size: 14, color: _isOn ? primary : hintColor),
                Text(
                  speedLabels[_fanSpeed],
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: _isOn ? primary : hintColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Fan speed slider ──────────────────────────────────────────
        Row(
          children: [
            Icon(Icons.toys_outlined, size: 16, color: hintColor),
            Expanded(
              child: Slider(
                value: _fanSpeed.toDouble(),
                min: 1,
                max: 3,
                divisions: 2,
                activeColor: _isOn ? primary : hintColor,
                inactiveColor: track,
                onChanged: _isOn
                    ? (v) => setState(() {
                        _fanSpeed = v.round();
                        _push();
                      })
                    : null,
              ),
            ),
            Text(
              speedLabels[_fanSpeed],
              style: TextStyle(
                fontSize: 10.sp,
                color: hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        // ── Humidity ──────────────────────────────────────────────────
        Row(
          children: [
            Container(
              width: 120.w,
              height: 50.h,
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(width: 10, color: track),
              ),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    Icon(SHIcons.waterDrop, color: hintColor, size: 18.sp),
                    SizedBox(width: 4.w),
                    Text(
                      l10n.airHumidity,
                      style: GoogleFonts.montserrat(
                        fontSize: 10.sp,
                        color: hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${widget.room.airHumidity.toInt()}%',
                      style: TextStyle(color: textColor, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Mode data ─────────────────────────────────────────────────────────────────

class _ModeData {
  const _ModeData(this.icon, this.label, this.key);
  final IconData icon;
  final String label;
  final String key;
}

// ── Temperature button ────────────────────────────────────────────────────────

class _TempBtn extends StatelessWidget {
  const _TempBtn({
    required this.icon,
    required this.enabled,
    required this.primary,
    required this.hintColor,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final Color primary;
  final Color hintColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? primary.withOpacity(0.1)
              : hintColor.withOpacity(0.08),
        ),
        child: Icon(icon, size: 18.sp, color: enabled ? primary : hintColor),
      ),
    );
  }
}

// ── Mode button ───────────────────────────────────────────────────────────────

class _ModeBtn extends StatelessWidget {
  const _ModeBtn({
    required this.icon,
    required this.label,
    required this.selected,
    required this.enabled,
    required this.primary,
    required this.hintColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool enabled;
  final Color primary;
  final Color hintColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = selected && enabled;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: active ? primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: active ? primary : hintColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16.sp, color: active ? primary : hintColor),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 8.sp,
                color: active ? primary : hintColor,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
