// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:swupp/pages/page_builder.dart';
import 'package:swupp/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  late String _name;
  late String _lastName;
  late String _location;
  late String _email;
  late String _password;

  bool isValidEmail(String em) {
    String p = r'^[^@]+@[^@]+\.[^@]+';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
        // Perform register here
        addUserDetails();

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PageBuilder(),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future addUserDetails() async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': _name,
      'last name': _lastName,
      'email': _email,
      'location': _location,
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Registration'),
      // ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                // Center(
                //   child: Image.asset(
                //     "lib/images/swupp-logo-500x500-transparent.png",
                //     width: 250,
                //   ),
                // ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 40),
                ),
                Text(
                  'Please enter your details below',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (input) => _name = input!,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        hintText: 'Last name',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onSaved: (input) => _lastName = input!,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: const OutlineInputBorder(),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return 'Please enter your email';
                        }
                        if (!validator.email(input)) {
                          setState(() {
                            _isLoading = false;
                          });
                          return 'Provide a valid email address';
                        }
                        return null;
                      },
                      onSaved: (input) => _email = input!,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                      validator: (input) {
                        if (input!.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (input) => _password = input!,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_pin),
                        border: OutlineInputBorder(),
                        hintText: 'Location',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return 'Please enter your location';
                        }
                        return null;
                      },
                      onSaved: (input) => _location = input!,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Register'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: Text("Login"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
