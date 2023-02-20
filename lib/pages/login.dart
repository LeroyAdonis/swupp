import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:swupp/pages/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swupp/services/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool error = false;
  String SignIneError = '';

  final AuthService _auth = AuthService();

  Future<void> _submit() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        _formKey.currentState?.save();
        await _auth.signInWithEmailAndPassword(email, password);
        dynamic result =
            await _auth.signInWithEmailAndPassword(email, password);
        if (result == null) {
          setState(() {
            SignIneError = 'could not sign in with those credentials';
            _isLoading = false;
          });
        }
        //         .registerWithEmailAndPassword(email, password);
        // await FirebaseAuth.instance
        //     .signInWithEmailAndPassword(email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          'The password is invalid or the user does not have a password.') {
        openDialog();
      } else if (e.email == null) {
        openEmailErrorDialog();
      }
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Scaffold(
                key: _scaffoldKey,
                backgroundColor: const Color.fromRGBO(244, 247, 252, 1),
                // appBar: AppBar(
                //   title: const Text("Swupppp"),
                // ),

                body: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50.0,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(
                                "lib/images/swupp-logo-500x500-transparent.png",
                                width: 250,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          const Text(
                            'Sign in here!',
                            style: TextStyle(fontSize: 30),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: emailController,
                              onChanged: ((value) {
                                setState(() => email = value);
                              }),
                              validator: (input) {
                                if (input!.isEmpty) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return 'Provide an email';
                                }
                                if (!validator.email(input)) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return 'Provide a valid email address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: const OutlineInputBorder(),
                                hintText: 'Email',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              // onSaved: (input) => _email = input!,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: passwordController,
                              onChanged: ((value) {
                                setState(() => password = value);
                              }),
                              validator: (input) {
                                if (input!.length < 6) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return 'Password must have 6+ chars';
                                }
                                // if (!validator.password(input)) {
                                //   setState(() {
                                //     _isLoading = false;
                                //   });
                                //   return 'Password must contain 1 Caps letter, 1 num';
                                // }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                border: const OutlineInputBorder(),
                                hintText: 'Password',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              // onSaved: (input) => _password = input!,
                              obscureText: true,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              //forgot password screen
                            },
                            child: const Text(
                              'Forgot Password',
                            ),
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
                              //   try {
                              //     if (_formKey.currentState!.validate()) {
                              //       await _auth.signInWithEmailAndPassword(
                              //           email, password);
                              //       setState(() {
                              //         _isLoading = false;
                              //       });
                              //     }
                              //   } on FirebaseAuthException catch (e) {
                              //     if (e.message ==
                              //         'There is no user record corresponding to this identifier. The user may have been deleted.') {
                              //       openDialog();
                              //     } else if (e.email == null) {
                              //       openEmailErrorDialog();
                              //     }
                              //   }
                              // }),
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Sign in'),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            SignIneError,
                            style: const TextStyle(color: Colors.red),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegistrationScreen()),
                                  );
                                },
                                child: const Text('Sign up'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Password'),
          actions: [
            IconButton(
              onPressed: close,
              icon: const Icon(EvaIcons.close),
            ),
          ],
        ),
      );
  Future openEmailErrorDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Email is not found.'),
          actions: [
            IconButton(
              onPressed: close,
              icon: const Icon(EvaIcons.close),
            ),
          ],
        ),
      );

  void close() {
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
  }
}
