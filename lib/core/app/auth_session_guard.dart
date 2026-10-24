import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../router/router.dart';

/// Watches the Firebase session. If a signed-in user disappears (signed out
/// on another device, account disabled, token revoked) the app is sent back
/// to the sign-in screen instead of staying on stale protected screens.
class AuthSessionGuard extends StatefulWidget {
  const AuthSessionGuard({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  State<AuthSessionGuard> createState() => _AuthSessionGuardState();
}

class _AuthSessionGuardState extends State<AuthSessionGuard> {
  StreamSubscription<User?>? _sub;
  bool _hadUser = FirebaseAuth.instance.currentUser != null;

  @override
  void initState() {
    super.initState();
    _sub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _hadUser = true;
        return;
      }
      if (!_hadUser) return;
      _hadUser = false;
      widget.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRouter.signin,
        (_) => false,
      );
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
