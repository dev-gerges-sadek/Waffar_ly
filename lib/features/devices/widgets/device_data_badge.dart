import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/device_model.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';

enum DataSourceTag { simulation, hardware }

class DeviceDataBadge extends StatelessWidget {
  const DeviceDataBadge({
    super.key,
    required this.tag,
    required this.data,
    this.sensor,
  });

  final DataSourceTag  tag;
  final DeviceData?    data;
  final HardwareSensor? sensor;

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final isHw      = tag == DataSourceTag.hardware;
    final l10n      = AppLocalizations.of(context);
    final hintColor = SHColors.hint(context);
    final textColor = SHColors.text(context);
    final success   = isDark ? SHColors.darkSuccessColor : SHColors.lightSuccessColor;
    final warning   = isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;

    final Color accent = isHw
        ? (isDark ? SHColors.darkWarningColor  : SHColors.lightWarningColor)
        : (isDark ? SHColors.darkPrimaryColor  : SHColors.lightPrimaryColor);

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: accent.withOpacity(isDark ? 0.15 : 0.09),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accent.withOpacity(0.35), width: 1),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 5.w,
                  height: 5.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data != null ? accent : hintColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Flexible(
                  child: Text(
                    isHw ? l10n.hardware : l10n.simulation,
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w700,
                      color: accent,
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (isHw && sensor != null) ...[
                  SizedBox(width: 2.w),
                  _SensorStatusPill(sensor: sensor!, l10n: l10n),
                ],
              ],
            ),
            SizedBox(height: 0.5.h),

            if (data == null)
              Text(
                l10n.noData,
                style: TextStyle(fontSize: 10.sp, color: hintColor),
              )
            else ...[
              _DataRow(
                label: l10n.status,
                value: data!.isOn ? l10n.powerOn : l10n.powerOff,
                valueColor: data!.isOn ? success : hintColor,
                textColor: textColor,
              ),
              if (data!.watts != null)
                _DataRow(
                  label: l10n.watts,
                  value: '${data!.watts!.toStringAsFixed(1)} W',
                  textColor: textColor,
                  valueColor: sensor?.isWarning == true ? warning : null,
                ),
              if (data!.kwh != null)
                _DataRow(
                  label: l10n.kwh,
                  value: data!.kwh!.toStringAsFixed(2),
                  textColor: textColor,
                ),
              if (data!.volts != null)
                _DataRow(
                  label: l10n.volts,
                  value: '${data!.volts!.toStringAsFixed(1)} V',
                  textColor: textColor,
                ),
              if (data!.amps != null)
                _DataRow(
                  label: l10n.amps,
                  value: '${data!.amps!.toStringAsFixed(2)} A',
                  textColor: textColor,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SensorStatusPill extends StatelessWidget {
  const _SensorStatusPill({required this.sensor, required this.l10n});
  final HardwareSensor sensor;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final success  = isDark ? SHColors.darkSuccessColor : SHColors.lightSuccessColor;
    final warning  = isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;
    final errColor = isDark ? SHColors.darkErrorColor   : SHColors.lightErrorColor;
    final hint     = SHColors.hint(context);

    final (label, color) = switch (sensor.status) {
      SensorStatus.online  => ('● ${l10n.liveStatus}',    success),
      SensorStatus.warning => ('⚠ ${l10n.warningStatus}', warning),
      SensorStatus.offline => ('✕ ${l10n.offlineStatus}', errColor),
      SensorStatus.unknown => ('? ${l10n.unknownStatus}', hint),
    };

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 7.5.sp,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.value,
    required this.textColor,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color  textColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(bottom: 0.2.h),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                  fontSize: 9.5.sp,
                  color: textColor.withOpacity(0.5)),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? textColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );
}
