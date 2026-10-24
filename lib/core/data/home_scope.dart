import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/app_constants.dart';

/// Multi-tenant data root.
///
/// Every household's data lives under `homes/{homeId}/...` so one user can
/// never read or command another household's devices (enforced by
/// `firestore.rules`). Today a home is owned by exactly one account and its
/// id equals the owner's uid; sharing can later be added through the
/// `members` field of the home document without changing any path.
class HomeScope {
  HomeScope({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : db = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore db;
  final FirebaseAuth _auth;

  /// Id of the signed-in user's home. Throws if nobody is signed in so a
  /// query can never silently fall back to a shared/global path.
  String get homeId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('HomeScope used while signed out');
    }
    return uid;
  }

  DocumentReference<Map<String, dynamic>> get home =>
      db.collection('homes').doc(homeId);

  CollectionReference<Map<String, dynamic>> col(String name) =>
      AppConstants.useHomeScope ? home.collection(name) : db.collection(name);

  /// Creates the home document on first sign-in (idempotent).
  Future<void> ensureHome() async {
    if (!AppConstants.useHomeScope) return;
    final ref = home;
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'owner': homeId,
        'members': <String>[homeId],
        'created_at': FieldValue.serverTimestamp(),
      });
    }
  }
}
