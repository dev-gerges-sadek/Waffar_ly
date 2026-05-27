import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AppException implements Exception {
  const AppException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Returns a localised, user-facing error string.
/// All string literals live in [AppLocalizations] — none are hardcoded here.
String handleError(Object e, BuildContext context) {
  final l = AppLocalizations.of(context);

  if (e is FirebaseAuthException) {
    return switch (e.code) {
      'user-not-found'         => l.errUserNotFound,
      'wrong-password'         => l.errWrongPassword,
      'email-already-in-use'   => l.errEmailInUse,
      'weak-password'          => l.errWeakPassword,
      'invalid-email'          => l.errInvalidEmail,
      'too-many-requests'      => l.errTooManyRequests,
      'network-request-failed' => l.errNoNetwork,
      'user-disabled'          => l.errDisabledAccount,
      'operation-not-allowed'  => l.errOperationNotAllowed,
      _                        => l.errAuthGeneric,
    };
  }

  if (e is AppException) return e.message;

  final msg = e.toString().toLowerCase();
  if (msg.contains('network') || msg.contains('socket')) {
    return l.errNoNetwork;
  }
  return l.errGeneric;
}
