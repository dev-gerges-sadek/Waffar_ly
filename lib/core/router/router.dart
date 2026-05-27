import 'package:flutter/material.dart';
import '../../features/auth/signin/signin_screen.dart';
import '../../features/auth/signup/sign_up_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/splash_screen.dart';
import '../../features/music/screens/music_screen.dart';

/// Single source of truth for all named routes.
/// Push with: Navigator.pushNamed(context, AppRouter.home)
abstract class AppRouter {
  static const String splash  = '/';
  static const String signin  = '/signin';
  static const String signup  = '/signup';
  static const String home    = '/home';
  static const String music   = '/music';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fade(const SplashScreen());
      case signin:
        return _slide(const SignInScreen());
      case signup:
        return _slide(const SignUpScreen());
      case home:
        return _fade(const HomeScreen());
      case music:
        return _slide(const MusicScreen());
      default:
        return _fade(const SplashScreen());
    }
  }

  static PageRouteBuilder<T> _fade<T>(Widget page) => PageRouteBuilder(
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      );

  static PageRouteBuilder<T> _slide<T>(Widget page) => PageRouteBuilder(
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, anim, _, child) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 280),
      );
}
