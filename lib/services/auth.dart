import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swupp/models/user.dart' as firebaseUser;
import 'package:swupp/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BuildContext? get context => null;

  //create user obj based on FirebaseUser
  firebaseUser.User? _userFromFirebaseUser(User user) {
    // ignore: unnecessary_null_comparison
    return user != null
        ? firebaseUser.User(fullName: user.displayName, email: user.email)
        : null;
  }

  // auth change user stream
  Stream<firebaseUser.User?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print(user);
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await DatabaseService(uid: user?.uid).updateUserData(
        'Leroy Adonis',
        'leroy@gmail.com',
        'Johannesburg',
      );
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      // ScaffoldMessenger.of(context!).showSnackBar(
      //   SnackBar(content: Text(e.message.toString())),
      // );
      return null;
    }
  }
}
