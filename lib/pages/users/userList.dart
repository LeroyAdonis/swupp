import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swupp/pages/users/user_tile.dart';

import 'user_data.dart';

class UserList extends ChangeNotifier {

  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context);

    // users.forEach((users) {
    //   print(users.fullName);
    //   print(users.email);
    //   print(users.location);
    // });

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserTile(user: users[index]);
        });
  }
}
