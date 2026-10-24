import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waffar_ly_app/core/data/home_scope.dart';
import 'package:waffar_ly_app/features/auth/models/user_model.dart';

/// Thrown when the user dismisses the Google account picker.
class AuthCancelledException implements Exception {
  const AuthCancelledException();
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final HomeScope _home = HomeScope();

  // 🟢 Sign Up
  Future<void> signUp(String email, String password, String name) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(UserModel(email: email, name: name).toJson());

    await _home.ensureHome();

    // Best effort: proves the address belongs to the user.
    try {
      await user.sendEmailVerification();
    } catch (_) {}
  }

  // 🔵 Sign In
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _ensureHomeSafely();
  }

  /// Existing accounts get their home created lazily on first sign-in.
  Future<void> _ensureHomeSafely() async {
    try {
      await _home.ensureHome();
    } catch (_) {
      // Non-fatal: the dashboard shows its normal empty/error state.
    }
  }

  // 🔴 Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut(); 
    await _auth.signOut();
  }

  // 🟠 Forget Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // 🟣 Sign In With Google
  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw const AuthCancelledException();

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
      }, SetOptions(merge: true));
      await _ensureHomeSafely();
    }
  }
}
