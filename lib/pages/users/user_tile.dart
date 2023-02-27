import 'package:flutter/material.dart';

import 'package:swupp/pages/users/user_data.dart';

class UserTile extends StatelessWidget {
  final UserData user;

  const UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.black26,
          ),
          title: Text(user.fullName),
          subtitle: Text(user.email),
        ),
      ),
    );
  }
}
