import 'package:firebase_auth/firebase_auth.dart';

class AppException implements Exception {
  const AppException(this.message);
  final String message;
  @override
  String toString() => message;
}


String handleError(Object e) {
  if (e is FirebaseAuthException) {
    return switch (e.code) {
      'user-not-found'        => 'No account found with this email.',
      'wrong-password'        => 'Incorrect password. Please try again.',
      'email-already-in-use'  => 'This email is already registered.',
      'weak-password'         => 'Password must be at least 6 characters.',
      'invalid-email'         => 'Please enter a valid email address.',
      'too-many-requests'     => 'Too many attempts. Please wait and try again.',
      'network-request-failed'=> 'No internet connection.',
      'user-disabled'         => 'This account has been disabled.',
      'operation-not-allowed' => 'This sign-in method is not enabled.',
      _                       => 'Authentication error. Please try again.',
    };
  }
  if (e is AppException) return e.message;
  final msg = e.toString();
  if (msg.contains('network') || msg.contains('socket')) {
    return 'No internet connection.';
  }
  return 'Something went wrong. Please try again.';
}
