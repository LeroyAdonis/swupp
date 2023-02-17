import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swupp/models/user_data.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({
    this.uid,
  });

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(
    String fullName,
    String email,
    String location,
  ) async {
    return await usersCollection.doc(uid).set({
      'full name': fullName,
      'email': email,
      'location': location,
    });
  }

  // User data list
  List<UserData> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((document) {
      return UserData(
          fullName: (document.data as DocumentSnapshot)['fullName'] ?? '',
          email: (document.data as DocumentSnapshot)['email'] ?? '',
          location: (document.data as DocumentSnapshot)['location'] ?? '');
    }).toList();
  }

  // Users stream
  Stream<List<UserData>> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }
}
