//login states
sealed class AuthStates {}

class IntialState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {
  final String error;
  LoginErrorState(this.error);
}


//signUp states
class SignUpLoadingState extends AuthStates {}

class SignUpSuccessState extends AuthStates {}

class SignUpErrorState extends AuthStates {
  final String error;
  SignUpErrorState(this.error);
}


//sign out state
class SignOutState extends AuthStates {}


//forget password states
class ResetPasswordLoadingState extends AuthStates {}
class ResetPasswordSuccessState extends AuthStates {}
class ResetPasswordErrorState extends AuthStates {
  final String error;
  ResetPasswordErrorState(this.error);
}