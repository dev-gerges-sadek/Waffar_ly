// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';

class AllClearView extends StatelessWidget {
  const AllClearView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: SHColors.lightSeverityNormal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_outline_rounded,
                color: SHColors.severity(context, 'normal'), size: 48),
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.allClearMessage,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: SHColors.text(context),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            l10n.noAnomaliesSubtitle,
            style: TextStyle(fontSize: 13.sp, color: SHColors.hint(context)),
          ),
        ],
      ),
    );
  }
}
