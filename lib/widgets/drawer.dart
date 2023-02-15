// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:swupp/components/menu_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swupp/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swupp/read%20data/get_user_name.dart';

import 'custom_drawer_header.dart';

final _firestore = FirebaseFirestore.instance;
// FirebaseUser loggedInFirebaseUser;
// final FirebaseAuth auth = FirebaseAuth.instance;

// ignore: prefer_typing_uninitialized_variables
var loggedInUser;

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  static ValueNotifier<String> userEmail = ValueNotifier('');
  static ValueNotifier<String> userName = ValueNotifier('');

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? name = '';
  String? email = '';

  // void userStream() async {
  List<String> docIds = [];

  Future getDocId() async {
    await _firestore.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIds.add(document.reference.id);
            },
          ),
        );
    // await for (var snapShot in _firestore.collection('users').snapshots()) {
    //   for (var user in snapShot.docs) {
    //     print(user.data());
    //   }
    // }
  }

  // Future getUser() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('email', isEqualTo: auth.currentUser)
  //       .get();
  // }

  User? _user;

  // ignore: prefer_typing_uninitialized_variables
  Map<String, dynamic>? _userData;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
    // getUser();
  }

  void _getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      setState(() {
        _user = user;
        getDocId();
      });

      if (_user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection("users")
            .doc(_user?.uid)
            .get();
        print(_userData);

        setState(() {
          _userData = (userData.data() as Map<String, dynamic>?);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // void userStream() async {
  //   await for (var snapShot in _firestore.collection('users').snapshots()) {
  //     for (var user in snapShot.docs) {
  //       print(user.data());
  //     }
  //   }
  // }

  // void getUser() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('user_id')
  //       .get();
  //   setState(() {
  //     name = snapshot.data()!['first name'];
  //     email = snapshot.data()!['email'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF4F7FC),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // UserAccountsDrawerHeader(
          //   decoration: BoxDecoration(color: Colors.grey[900]),
          //   currentAccountPicture: ClipOval(
          //     child: Image.asset(
          //       "lib/images/swupp-logo.png",
          //     ),
          //   ),
          //   accountName: FutureBuilder(
          //     future: getDocId(),
          //     builder: ((context, snapshot) {
          //       return ListView.builder(
          //         itemCount: docIds.length,
          //         itemBuilder: ((context, index) {
          //           return ListTile(
          //             textColor: Colors.white,
          //             title: GetUserName(
          //               documentId: docIds[index],
          //             ),
          //           );
          //         }),
          //       );
          //     }),
          //   ),
          //   // accountName: ValueListenableBuilder(
          //   //   valueListenable: MyDrawer.userName,
          //   //   builder: (BuildContext context, String newValue, Widget? child) {
          //   //     return const Text('');
          //   //   },
          //   // ),
          //   accountEmail: ValueListenableBuilder(
          //     valueListenable: MyDrawer.userEmail,
          //     builder: (BuildContext context, String newValue, Widget? child) {
          //       return Text(newValue);
          //     },
          //   ),
          // ),
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: _userData != null
                ? Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                _userData!['https://picsum.photos/400']),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _userData!['first name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _user!.email.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                : Container(),
          ),
          MenuListTile(
            icon: Icons.message,
            text: 'NOTIFICATIONS',
            onTap: () {},
          ),
          MenuListTile(icon: Icons.note, text: 'TERMS OF USE', onTap: () {}),
          MenuListTile(
            icon: Icons.logout,
            text: 'SIGN OUT',
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}

// mixin FirebaseUser {}
