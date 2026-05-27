import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waffar_ly_app/features/auth/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 🟢 Sign Up
  Future<void> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set(
            UserModel(
              email: email,
              name: name,
            ).toJson(),
          );
    } catch (e) {
      rethrow;
    }
  }

  // 🔵 Sign In
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
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
    try {
 
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception("Google sign in was cancelled by user");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken, 
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          "name": user.displayName ?? "",
          "email": user.email ?? "",
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}