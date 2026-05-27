import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/l10n/app_localizations.dart';
import '../firebase/auth_service.dart';
import 'states.dart';

class AuthCubit extends Cubit<AuthStates> {
  /// No-arg constructor — compatible with `BlocProvider(create: (_) => AuthCubit())`.
  /// Call [setLocale] before any auth action to enable localised error messages.
  /// Screens that create their own BlocProvider pass l10n directly via [AuthCubit.withL10n].
  AuthCubit() : super(IntialState());

  AuthCubit.withL10n(AppLocalizations l10n)
      : _l10n = l10n,
        super(IntialState());

  AppLocalizations? _l10n;
  final AuthService _authService = AuthService();

  /// Called by screens that already hold an [AppLocalizations] reference
  /// but use the globally-provided cubit (e.g. from main.dart).
  void setLocale(AppLocalizations l10n) => _l10n = l10n;

  // ── Validation ────────────────────────────────────────────────────────────

  bool _isValidEmail(String email) =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.trim());

  // ── Auth actions ──────────────────────────────────────────────────────────

  Future<void> signUp(String email, String password, String name) async {
    if (!_isValidEmail(email)) {
      emit(SignUpErrorState(_err((l) => l.errInvalidEmail)));
      return;
    }
    if (password.length < 8) {
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
    if (password.length < 6) {
      emit(LoginErrorState(_err((l) => l.errWeakPassword)));
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
    return selector(AppLocalizations(const Locale('en')));
  }

  String _mapFirebase(Object e) {
    final l10n = _l10n ?? AppLocalizations(const Locale('en'));
    final msg  = e.toString().toLowerCase();
    if (msg.contains('user-not-found'))       return l10n.errUserNotFound;
    if (msg.contains('wrong-password'))       return l10n.errWrongPassword;
    if (msg.contains('email-already-in-use')) return l10n.errEmailInUse;
    if (msg.contains('weak-password'))        return l10n.errWeakPassword;
    if (msg.contains('invalid-email'))        return l10n.errInvalidEmail;
    if (msg.contains('too-many-requests'))    return l10n.errTooManyRequests;
    if (msg.contains('network'))              return l10n.errNoNetwork;
    if (msg.contains('user-disabled'))        return l10n.errDisabledAccount;
    return l10n.errAuthGeneric;
  }
}
