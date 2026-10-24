import '../../../core/widgets/tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';

/// Horizontally scrollable row of smart-home quick-prompt chips.
/// All strings are sourced from [AppLocalizations].
class SuggestedPromptsBar extends StatelessWidget {
  const SuggestedPromptsBar({super.key, required this.onTap});

  final void Function(String prompt) onTap;

  @override
  Widget build(BuildContext context) {
    final primary = SHColors.primary(context);
    final l10n    = AppLocalizations.of(context);
    final prompts = [
      l10n.prompt1, l10n.prompt2, l10n.prompt3, l10n.prompt4,
      l10n.prompt5, l10n.prompt6, l10n.prompt7, l10n.prompt8,
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
        itemCount: prompts.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (_, i) => _PromptChip(
          label: prompts[i],
          primary: primary,
          onTap: () => onTap(prompts[i]),
        ),
      ),
    );
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => TapButton(
        onTap: onTap,
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: primary.withValues(alpha: 0.40)),
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
}
