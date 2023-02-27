import 'package:flutter/cupertino.dart';

class UserData extends ChangeNotifier {
  final String fullName;
  final String email;
  final String location;
  UserData({
    required this.fullName,
    required this.email,
    required this.location,
  });
}
