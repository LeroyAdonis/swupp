import 'package:flutter/material.dart';
import '../pages/login.dart';

class MyTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  Function myValidator;
  final Widget textIcon;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.myValidator,
    required this.textIcon,
  });

  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        validator: ((input) {}),
        decoration: InputDecoration(
          prefixIcon: textIcon,
          border: const OutlineInputBorder(),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.white,
        ),
        onSaved: (input) => _email = input!,
      ),
    );
  }
}
