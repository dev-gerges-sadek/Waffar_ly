import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';

class AlertsInfoBanner extends StatelessWidget {
  const AlertsInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final warning = isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: warning.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: warning.withOpacity(0.30)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: warning, size: 16),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              l10n.anomalyDetectionInfo,
              style: TextStyle(fontSize: 11.sp, color: SHColors.text(context)),
            ),
          ),
        ],
      ),
    );
  }
}
