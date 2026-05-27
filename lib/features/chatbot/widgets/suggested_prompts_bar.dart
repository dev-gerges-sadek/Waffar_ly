import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';

/// Horizontally scrollable row of smart-home quick-prompt chips.
/// All strings are sourced from [AppLocalizations].
class SuggestedPromptsBar extends StatelessWidget {
  const SuggestedPromptsBar({super.key, required this.onTap});

  final void Function(String prompt) onTap;

  // ── Prompt lists keyed to locale ─────────────────────────────────────────

  static const _promptsEn = [
    'What is the current AI status?',
    'Which device uses the most power?',
    'What is my current electricity bill?',
    'Is there an anomaly detected?',
    'What is the live wattage right now?',
    'Should I turn off the AC?',
    'Explain the CRITICAL warning',
    'How much will I pay this month?',
  ];

  static const _promptsAr = [
    'ما حالة الذكاء الاصطناعي الحالية؟',
    'أي جهاز يستهلك أكثر طاقة؟',
    'ما فاتورة الكهرباء الحالية؟',
    'هل تم اكتشاف خلل؟',
    'كم الواط المباشر الآن؟',
    'هل يجب إيقاف التكييف؟',
    'اشرح التحذير الحرج',
    'كم سأدفع هذا الشهر؟',
  ];

  @override
  Widget build(BuildContext context) {
    final primary = SHColors.primary(context);
    final l10n    = AppLocalizations.of(context);
    final prompts = l10n.isArabic ? _promptsAr : _promptsEn;

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
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: primary.withOpacity(0.40)),
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
