import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/l10n/app_localizations.dart';
import '../firebase/auth_service.dart';
import 'states.dart';

class AuthCubit extends Cubit<AuthStates> {
  /// No-arg constructor — compatible with `BlocProvider(create: (_) => AuthCubit())`.
  /// Call [setLocale] before any auth action to enable localised error messages.
  /// Screens that create their own BlocProvider pass l10n directly via [AuthCubit.withL10n].
  AuthCubit({AuthService? authService})
      : _authService = authService ?? GetIt.I<AuthService>(),
        super(InitialState());

  AuthCubit.withL10n(AppLocalizations l10n, {AuthService? authService})
      : _l10n = l10n,
        _authService = authService ?? GetIt.I<AuthService>(),
        super(InitialState());

  AppLocalizations? _l10n;
  final AuthService _authService;

  /// Called by screens that already hold an [AppLocalizations] reference
  /// but use the globally-provided cubit (e.g. from main.dart).
  void setLocale(AppLocalizations l10n) => _l10n = l10n;

  // ── Validation ────────────────────────────────────────────────────────────

  bool _isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  /// Sign-up policy: ≥ 8 chars with at least one letter and one digit.
  static bool isStrongPassword(String p) =>
      p.length >= 8 &&
      RegExp(r'[A-Za-z؀-ۿ]').hasMatch(p) &&
      RegExp(r'\d').hasMatch(p);

  // ── Auth actions ──────────────────────────────────────────────────────────

  Future<void> signUp(String email, String password, String name) async {
    if (!_isValidEmail(email)) {
      emit(SignUpErrorState(_err((l) => l.errInvalidEmail)));
      return;
    }
    if (!isStrongPassword(password)) {
      emit(SignUpErrorState(_err((l) => l.errWeakPassword)));
      return;
    }
    if (name.trim().isEmpty) {
      emit(SignUpErrorState(_err((l) => l.name)));
      return;
    }

    emit(SignUpLoadingState());
    try {
      await _authService.signUp(email.trim(), password, name.trim());
      emit(SignUpSuccessState());
    } catch (e) {
      emit(SignUpErrorState(_mapFirebase(e)));
    }
  }

  Future<void> login(String email, String password) async {
    if (!_isValidEmail(email)) {
      emit(LoginErrorState(_err((l) => l.errInvalidEmail)));
      return;
    }
    if (password.isEmpty) {
      emit(LoginErrorState(_err((l) => l.errPasswordRequired)));
      return;
    }

    emit(LoginLoadingState());
    try {
      await _authService.signIn(email.trim(), password);
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(_mapFirebase(e)));
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    emit(SignOutState());
  }

  Future<void> signInWithGoogle() async {
    emit(LoginLoadingState());
    try {
      await _authService.signInWithGoogle();
      emit(LoginSuccessState());
    } on AuthCancelledException {
      emit(InitialState());
    } catch (e) {
      emit(LoginErrorState(_mapFirebase(e)));
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      emit(ResetPasswordErrorState(_err((l) => l.email)));
      return;
    }
    if (!_isValidEmail(email)) {
      emit(ResetPasswordErrorState(_err((l) => l.errInvalidEmail)));
      return;
    }

    emit(ResetPasswordLoadingState());
    try {
      await _authService.resetPassword(email.trim());
      emit(ResetPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
      // Same answer whether or not the account exists (no user enumeration).
      if (e.code == 'user-not-found') {
        emit(ResetPasswordSuccessState());
      } else {
        emit(ResetPasswordErrorState(_mapFirebase(e)));
      }
    } catch (e) {
      emit(ResetPasswordErrorState(_mapFirebase(e)));
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Reads a localised string if l10n is available; falls back to the
  /// English string defined in AppLocalizations (always present).
  String _err(String Function(AppLocalizations) selector) {
    if (_l10n != null) return selector(_l10n!);
    // Fallback: construct a default EN instance for the error string
    return selector(lookupAppLocalizations(const Locale('en')));
  }

  String _mapFirebase(Object e) {
    final l10n = _l10n ?? lookupAppLocalizations(const Locale('en'));
    if (e is FirebaseAuthException) {
      return switch (e.code) {
        // One message for all credential failures — avoids user enumeration.
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' =>
          l10n.errInvalidCredentials,
        'email-already-in-use' => l10n.errEmailInUse,
        'weak-password' => l10n.errWeakPassword,
        'invalid-email' => l10n.errInvalidEmail,
        'too-many-requests' => l10n.errTooManyRequests,
        'network-request-failed' => l10n.errNoNetwork,
        'user-disabled' => l10n.errDisabledAccount,
        'operation-not-allowed' => l10n.errOperationNotAllowed,
        _ => l10n.errAuthGeneric,
      };
    }
    final msg = e.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('socket')) {
      return l10n.errNoNetwork;
    }
    return l10n.errAuthGeneric;
  }
}
