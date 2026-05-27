import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/features/chatbot/cubit/chatbot_states.dart';
import '../../../../core/theme/sh_colors.dart';

/// Single chat bubble.
/// - User messages: primary background, align to message-end (RTL-safe).
/// - AI messages  : card background, align to message-start.
/// Border radii flip correctly regardless of text direction.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.primaryColor,
    required this.cardColor,
    required this.textColor,
  });

  final ChatMessage message;
  final Color primaryColor;
  final Color cardColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    // Resolve on-primary text from theme — never hardcode white/black
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onPrimaryText =
        isDark ? SHColors.darkBackgroundColor : SHColors.lightBackgroundColor;

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 14.r,
              backgroundColor: primaryColor.withOpacity(0.15),
              child: Icon(
                Icons.smart_toy_rounded,
                color: primaryColor,
                size: 14,
              ),
            ),
            SizedBox(width: 6.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 14.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: isUser ? primaryColor : cardColor,
                borderRadius: _bubbleRadius(isUser, context),
                boxShadow: [
                  BoxShadow(
                    color: SHColors.text(context).withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isUser ? onPrimaryText : textColor,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) SizedBox(width: 6.w),
        ],
      ),
    );
  }

  /// Returns border radii with a "tail" pointing toward the correct side,
  /// and mirrors correctly in RTL.
  BorderRadius _bubbleRadius(bool isUser, BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final r     = 16.r;
    const kTail = 4.0;

    if (isUser) {
      // User bubble tail is at bottom-end
      return isRtl
          ? BorderRadius.only(
              topLeft: Radius.circular(r),
              topRight: Radius.circular(r),
              bottomLeft: const Radius.circular(kTail),
              bottomRight: Radius.circular(r),
            )
          : BorderRadius.only(
              topLeft: Radius.circular(r),
              topRight: Radius.circular(r),
              bottomLeft: Radius.circular(r),
              bottomRight: const Radius.circular(kTail),
            );
    } else {
      // AI bubble tail is at bottom-start
      return isRtl
          ? BorderRadius.only(
              topLeft: Radius.circular(r),
              topRight: Radius.circular(r),
              bottomLeft: Radius.circular(r),
              bottomRight: const Radius.circular(kTail),
            )
          : BorderRadius.only(
              topLeft: Radius.circular(r),
              topRight: Radius.circular(r),
              bottomLeft: const Radius.circular(kTail),
              bottomRight: Radius.circular(r),
            );
    }
  }
}
