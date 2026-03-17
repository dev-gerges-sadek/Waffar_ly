// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/core/theme/sh_colors.dart';
import 'package:waffar_ly_app/features/auth/signin/signin_screen.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int index = 0;
  final PageController controller = PageController();

  final List<Map<String, String>> pages = [
    {
      'title': 'Control all your devices',
      'desc': 'Manage your smart home easily and efficiently from one place.',
      'image': 'assets/images/OnboardingScreen1.png',
    },
    {
      'title': 'Beautiful interface',
      'desc': 'A comfortable and modern user experience designed for you.',
      'image': 'assets/images/OnboardingScreen2.png',
    },
    {
      'title': 'Get Started',
      'desc': 'Start controlling your home now with advanced features.',
      'image': 'assets/images/OnboardingScreen3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ كل الألوان بتيجي من الـ theme مش hardcoded
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor  = SHColors.primary(context);
    final hintColor     = SHColors.hint(context);
    final bgColor       = SHColors.background(context);
    final trackColor    = isDark ? SHColors.darkTrackColor : SHColors.lightTrackColor;
    final secondaryColor = isDark ? SHColors.darkSecondaryColor : SHColors.lightSecondaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Skip Button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: hintColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => index = i),
                itemBuilder: (_, i) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primaryColor.withOpacity(0.1),
                                secondaryColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                            ),
                          ),
                          child: Image.asset(
                            pages[i]['image']!,
                            height: 200.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          pages[i]['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: SHColors.text(context), // ✅ theme-aware
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          pages[i]['desc']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: hintColor, // ✅ theme-aware
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40.h),
            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  height: 8.h,
                  width: index == i ? 24.w : 8.w,
                  decoration: BoxDecoration(
                    color: index == i ? primaryColor : trackColor, // ✅
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            // Next / Get Started Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.4),
                  ),
                  onPressed: () {
                    if (index < pages.length - 1) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                    }
                  },
                  child: Text(
                    index == pages.length - 1 ? 'Get Started' : 'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
