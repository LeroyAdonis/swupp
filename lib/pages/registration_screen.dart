// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:swupp/models/user.dart';
import 'package:swupp/pages/page_builder.dart';
import 'package:swupp/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swupp/services/auth.dart';
import 'package:swupp/models/user.dart' as firebaseUser;
import 'package:swupp/services/database.dart';

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

  // late String _fullName;
  // late String _lastName;
  // late String _location;
  String fullName = '';
  String email = '';
  String password = '';
  String location = '';

  bool isValidEmail(String em) {
    String p = r'^[^@]+@[^@]+\.[^@]+';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  bool _isLoading = false;

  final AuthService _auth = AuthService();
  final firebaseUser.User? user = firebaseUser.User();
  final DatabaseService data = DatabaseService();

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        // await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //     email: email.trim(), password: password.trim());
        // // Perform register here
        // addUserDetails();

        await _auth.registerWithEmailAndPassword(
            fullName, email, password, location);
        setState(() {
          _isLoading = true;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PageBuilder(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future addUserDetails() async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': fullName,
      // 'last name': _lastName,
      'email': email,
      'location': location,
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
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(244, 247, 252, 1),
            )
          : Scaffold(
              backgroundColor: Color.fromRGBO(244, 247, 252, 1),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "lib/images/sign_up.png",
                              fit: BoxFit.contain,
                            ),
                            Text(
                              'Sign up here!',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: TextFormField(
                              onChanged: ((value) {
                                setState(() => fullName = value);
                              }),
                              controller: nameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                                hintText: 'Full Name',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (input) {
                                if (input!.isEmpty) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                              onSaved: (input) => fullName = input!,
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Container(
                        //     child: TextFormField(
                        //       controller: lastNameController,
                        //       decoration: InputDecoration(
                        //         prefixIcon: Icon(Icons.person),
                        //         border: OutlineInputBorder(),
                        //         hintText: 'Last name',
                        //         hintStyle: TextStyle(color: Colors.grey.shade400),
                        //         filled: true,
                        //         fillColor: Colors.white,
                        //       ),
                        //       validator: (input) {
                        //         if (input!.isEmpty) {
                        //           setState(() {
                        //             _isLoading = false;
                        //           });
                        //           return 'Please enter your last name';
                        //         }
                        //         return null;
                        //       },
                        //       onSaved: (input) => _lastName = input!,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: TextFormField(
                              controller: emailController,
                              onChanged: ((value) {
                                setState(() => email = value);
                              }),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: const OutlineInputBorder(),
                                hintText: 'Email',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
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
                              onSaved: (input) => email = input!,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: TextFormField(
                              controller: passwordController,
                              onChanged: ((value) {
                                setState(() => password = value);
                              }),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                border: const OutlineInputBorder(),
                                hintText: 'Password',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
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
                              onSaved: (input) => password = input!,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: TextFormField(
                              controller: locationController,
                              onChanged: ((value) {
                                setState(() => location = value);
                              }),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.location_pin),
                                border: OutlineInputBorder(),
                                hintText: 'Location',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
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
                              onSaved: (input) => location = input!,
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
                              backgroundColor: Color(0xff62cdf6),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: _submit,
                            // onPressed: (() async {
                            //   setState(() {
                            //     _isLoading = true;
                            //   });
                            //   if (_formKey.currentState!.validate()) {
                            //     dynamic result = await _auth
                            //         .registerWithEmailAndPassword(email, password);
                            //   }
                            // }),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Sign up'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Sign in'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
