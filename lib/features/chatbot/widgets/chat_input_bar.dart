import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/sh_colors.dart';

/// Bottom input bar with RTL-aware send button.
/// Colours are fully resolved from [SHColors].
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSend,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary   = SHColors.primary(context);
    final cardColor = SHColors.card(context);
    final surface   = isDark ? SHColors.darkSurfaceColor : SHColors.lightSurfaceColor;

    // On-primary is always white in this design system
    final onPrimary = isDark
        ? SHColors.darkBackgroundColor
        : SHColors.lightBackgroundColor;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(
          top: BorderSide(
            color: hintColor.withOpacity(0.15),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              style: TextStyle(fontSize: 13.sp, color: textColor),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 12.sp, color: hintColor),
                filled: true,
                fillColor: surface,
                contentPadding: EdgeInsetsDirectional.symmetric(
                  horizontal: 14.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                // Mirror send icon for RTL
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.send_rounded
                    : Icons.send_rounded,
                color: onPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
