import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';

/// AppBar trailing: AI avatar, name/subtitle, and a clear-chat icon button.
class ChatAppBarTitle extends StatelessWidget {
  const ChatAppBarTitle({
    super.key,
    required this.onClear,
    required this.clearTooltip,
  });

  final VoidCallback onClear;
  final String clearTooltip;

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final primary   = SHColors.primary(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // AI avatar
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primary.withOpacity(0.15),
          ),
          child: Icon(Icons.smart_toy_rounded, color: primary, size: 20),
        ),
        SizedBox(width: 10.w),

        // Name + subtitle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.waffarAI,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            Text(
              l10n.smartAssist,
              style: TextStyle(fontSize: 10.sp, color: hintColor),
            ),
          ],
        ),
        SizedBox(width: 12.w),

        // Clear chat
        IconButton(
          icon: Icon(Icons.refresh_rounded, color: textColor, size: 20),
          onPressed: onClear,
          tooltip: clearTooltip,
        ),
      ],
    );
  }
}
