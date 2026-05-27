// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
import '../../../auth/signin/signin_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _index = 0;
  final _ctrl = PageController();

  List<Map<String, String>> _pages(AppLocalizations l10n) => [
    {
      'title': l10n.isArabic ? 'تحكّم في أجهزتك بسهولة' : 'Control all your devices',
      'desc':  l10n.isArabic
          ? 'أدِر منزلك الذكي بكفاءة من مكان واحد.'
          : 'Manage your smart home easily and efficiently from one place.',
      'image': 'assets/images/OnboardingScreen1.png',
    },
    {
      'title': l10n.isArabic ? 'تصميم جميل وعصري' : 'Beautiful interface',
      'desc':  l10n.isArabic
          ? 'تجربة مستخدم مريحة وعصرية مصممة خصيصاً لك.'
          : 'A comfortable and modern user experience designed for you.',
      'image': 'assets/images/OnboardingScreen2.png',
    },
    {
      'title': l10n.isArabic ? 'ابدأ الآن' : 'Get Started',
      'desc':  l10n.isArabic
          ? 'ابدأ التحكم في منزلك الآن بمزايا متقدمة.'
          : 'Start controlling your home now with advanced features.',
      'image': 'assets/images/OnboardingScreen3.png',
    },
  ];

  void _next(BuildContext context) {
    final pages = _pages(AppLocalizations.of(context));
    if (_index < pages.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n        = AppLocalizations.of(context);
    final pages       = _pages(l10n);
    final primary     = SHColors.primary(context);
    final hint        = SHColors.hint(context);
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final trackColor  = isDark ? SHColors.darkTrackColor : SHColors.lightTrackColor;
    final secondary   = isDark ? SHColors.darkSecondaryColor : SHColors.lightSecondaryColor;
    final onPrimary   = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: SHColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),

            // Skip
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 20.w),
                child: TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                  ),
                  child: Text(
                    l10n.isArabic ? 'تخطّى' : 'Skip',
                    style: TextStyle(fontSize: 14.sp, color: hint),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                            colors: [
                              primary.withOpacity(0.10),
                              secondary.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: primary.withOpacity(0.20)),
                        ),
                        child: Image.asset(pages[i]['image']!,
                            height: 200.h, fit: BoxFit.contain),
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        pages[i]['title']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          color: SHColors.text(context),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        pages[i]['desc']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: hint,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 40.h),

            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 5.w),
                  height: 8.h,
                  width: _index == i ? 24.w : 8.w,
                  decoration: BoxDecoration(
                    color: _index == i ? primary : trackColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // CTA button
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)),
                    elevation: 4,
                    shadowColor: primary.withOpacity(0.4),
                  ),
                  onPressed: () => _next(context),
                  child: Text(
                    _index == pages.length - 1
                        ? (l10n.isArabic ? 'ابدأ الآن' : 'Get Started')
                        : (l10n.isArabic ? 'التالي' : 'Next'),
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
