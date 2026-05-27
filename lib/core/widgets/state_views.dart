import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/sh_colors.dart';
import '../l10n/app_localizations.dart';

/// Centered loading spinner with an optional message.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final primary = SHColors.primary(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primary),
          if (message != null) ...[
            SizedBox(height: 12.h),
            Text(
              message!,
              style: TextStyle(
                fontSize: 12.sp,
                color: SHColors.hint(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Centered error state with icon, title, and optional subtitle.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.cloud_off_rounded,
  });

  final String message;

  /// Falls back to l10n.errGeneric title if null.
  final String? title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hint = SHColors.hint(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: hint),
            SizedBox(height: 12.h),
            Text(
              title ?? l10n.errGeneric,
              style: TextStyle(
                color: SHColors.text(context),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: hint, fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }
}

/// Centered empty state with icon and label.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.label,
    this.icon = Icons.inbox_rounded,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final hint = SHColors.hint(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 52, color: hint),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(color: hint, fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
