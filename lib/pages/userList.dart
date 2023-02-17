import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_data.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    // final users = Provider.of<List<UserData>>(context);

    // users.forEach((users) {
    //   print(users.fullName);
    //   print(users.email);
    //   print(users.location);
    // });

    final users = Provider.of<QuerySnapshot>(context);
    // print(users.docs);

    for (var doc in users.docs) {
      print(doc.data);
    }
    return Container();
  }
}
