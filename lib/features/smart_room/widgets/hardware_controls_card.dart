import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/shared/presentation/widgets/sh_card.dart';
import '../../../core/theme/sh_colors.dart';
import '../../../core/theme/sh_icons.dart';

class HardwareControlsCard extends StatelessWidget {
  const HardwareControlsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    // Dimmed/disabled appearance
    final disabledOpacity = 0.5;

    return Opacity(
      opacity: disabledOpacity,
      child: SHCard(
        childrenPadding: EdgeInsets.all(12.w),
        children: [
          // ── Header: title + power button (disabled) ────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hardware,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  // Disabled power button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: hintColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: hintColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          SHIcons.fan,
                          size: 14.sp,
                          color: hintColor.withOpacity(0.6),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'OFF',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: hintColor.withOpacity(0.6),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Disabled status indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: hintColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      l10n.unavailable,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: hintColor.withOpacity(0.5),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Info message ──────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: hintColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: hintColor.withOpacity(0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16.sp,
                  color: hintColor.withOpacity(0.6),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Hardware control is currently unavailable',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: hintColor.withOpacity(0.6),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
