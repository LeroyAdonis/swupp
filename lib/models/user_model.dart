import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String firstName;
  String lastName;
  String email;
  String location;
  // Timestamp accountCreated;
  UserModel(
      // this.accountCreated,
      this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.location);
}
