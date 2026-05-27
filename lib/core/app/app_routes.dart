// Barrel re-export — keeps backward compatibility.
import 'package:waffar_ly_app/core/router/router.dart';

// Legacy alias used in sign-in/sign-up screens
abstract class AppRoutes {
  static const String signin = AppRouter.signin;
  static const String signup = AppRouter.signup;
  static const String home   = AppRouter.home;
  static const String music  = AppRouter.music;
}
