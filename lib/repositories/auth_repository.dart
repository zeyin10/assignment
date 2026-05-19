import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/app_user.dart';

class AuthRepository extends ChangeNotifier {
  final _auth      = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  AppUser? currentUser;

  AuthRepository() {
    _auth.authStateChanges().listen(_onAuthChanged);
  }

  bool get isLoggedIn => currentUser != null;

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(displayName);

    final user = AppUser(
      uid:         cred.user!.uid,
      email:       email,
      displayName: displayName,
    );
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
    currentUser = user;
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Set a temporary user immediately so isLoggedIn = true
    // and the router can redirect. _onAuthChanged will fill in
    // the full profile from Firestore once it's available.
    currentUser = AppUser(
      uid:         cred.user!.uid,
      email:       email,
      displayName: cred.user!.displayName ?? '',
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }

  Future<void> _onAuthChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      currentUser = null;
      notifyListeners();
      return;
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        currentUser = AppUser.fromMap(doc.data()!);
      } else {
        final newUser = AppUser(
          uid:         firebaseUser.uid,
          email:       firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
        await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());
        currentUser = newUser;
      }
    } catch (_) {
      // Firestore offline — keep the temporary currentUser that was
      // set in signIn() so the app still opens normally.
    }

    notifyListeners();
  }
}