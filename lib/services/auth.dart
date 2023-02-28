import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:swupp/models/user.dart' as firebaseUser;
import 'package:swupp/services/database.dart';
import 'package:swupp/pages/login.dart';

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
      // print(user);
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          'The password is invalid or the user does not have a password.') {}
      print(e.toString());
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword(
      String fullName, String email, String password, String location) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // await user!.updateDisplayName(fullName);

      await addUserToDatabase(user!, fullName, email, location);

      await DatabaseService(uid: user.uid).updateUserData(
        _auth.currentUser!.displayName.toString(),
        user.email.toString(),
        location,
      );
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addUserToDatabase(
      User user, String fullName, String email, String location) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return users
        .doc(user.uid)
        .set({
          'full name': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'location': location
        })
        .then((value) => user.updateDisplayName(fullName))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
