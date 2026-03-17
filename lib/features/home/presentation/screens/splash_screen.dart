// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waffar_ly_app/core/constants/app_constants.dart';
import 'package:waffar_ly_app/core/theme/sh_colors.dart';
import 'package:waffar_ly_app/features/auth/signin/signin_screen.dart';
import 'package:waffar_ly_app/features/home/presentation/screens/home_screen.dart';
import 'package:waffar_ly_app/features/home/presentation/screens/onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _fadeCtrl = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();

    Future.delayed(const Duration(seconds: 3), _navigate);
  }

  /// Auth guard + onboarding seen check
  Future<void> _navigate() async {
    if (!mounted) return;

    final user  = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final seen  = prefs.getBool(AppConstants.keySeenOnboarding) ?? false;

    if (!mounted) return;

    if (user != null) {
      // Already logged in → go Home directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (!seen) {
      // First time → Onboarding
      await prefs.setBool(AppConstants.keySeenOnboarding, true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      // Seen onboarding but not logged in → SignIn
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    }
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [
            SHColors.darkPrimaryColor.withOpacity(0.8),
            SHColors.darkSecondaryColor.withOpacity(0.9),
            SHColors.darkAccentColor.withOpacity(0.8),
          ]
        : [
            SHColors.lightPrimaryColor.withOpacity(0.8),
            SHColors.lightSecondaryColor.withOpacity(0.9),
            SHColors.lightAccentColor.withOpacity(0.8),
          ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1).animate(
                  CurvedAnimation(
                      parent: _scaleCtrl, curve: Curves.elasticOut),
                ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                        parent: _fadeCtrl, curve: Curves.easeIn),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/Logo.jpeg',
                      fit: BoxFit.contain,
                      height: 200.h,
                      width: 200.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(height: 24.h),
              FadeTransition(
                opacity: _fadeCtrl,
                child: Text(
                  'Waffar',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              FadeTransition(
                opacity: _fadeCtrl,
                child: Text(
                  'Smart Home Control',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
