import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffar_ly_app/core/data_source/firebase/auth_service.dart';
import 'package:waffar_ly_app/core/helper/error_handler.dart';
import 'package:waffar_ly_app/features/auth/cubit/states.dart';


class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(IntialState());

  final AuthService _authService = AuthService();

  void signUp(String email, String password, String name) async {
    if (!_validateEmail(email))    { emit(SignUpErrorState('Invalid email format.')); return; }
    if (password.length < 8)       { emit(SignUpErrorState('Password must be at least 8 characters.')); return; }
    if (name.trim().isEmpty)       { emit(SignUpErrorState('Please enter your name.')); return; }

    emit(SignUpLoadingState());
    try {
      await _authService.signUp(email.trim(), password, name.trim());
      emit(SignUpSuccessState());
    } catch (e) {
      emit(SignUpErrorState(handleError(e)));
    }
  }

  void login(String email, String password) async {
    if (!_validateEmail(email))    { emit(LoginErrorState('Invalid email format.')); return; }
    if (password.length < 6)       { emit(LoginErrorState('Password too short.')); return; }

    emit(LoginLoadingState());
    try {
      await _authService.signIn(email.trim(), password);
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(handleError(e)));
    }
  }

  void signOut() async {
    await _authService.signOut();
    emit(SignOutState());
  }

  void signInWithGoogle() async {
    emit(LoginLoadingState());
    try {
      await _authService.signInWithGoogle();
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(handleError(e)));
    }
  }

  void resetPassword(String email) async {
    if (email.isEmpty) { emit(ResetPasswordErrorState('Please enter your email first.')); return; }
    if (!_validateEmail(email)) { emit(ResetPasswordErrorState('Invalid email format.')); return; }

    emit(ResetPasswordLoadingState());
    try {
      await _authService.resetPassword(email.trim());
      emit(ResetPasswordSuccessState());
    } catch (e) {
      emit(ResetPasswordErrorState(handleError(e)));
    }
  }

  bool _validateEmail(String email) =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.trim());
}
