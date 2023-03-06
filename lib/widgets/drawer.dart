import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:swupp/components/menu_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swupp/pages/profile/profile_screen.dart';
import 'package:swupp/pages/users/userList.dart';
import 'package:swupp/services/auth.dart';
import 'package:swupp/services/database.dart';
import 'package:swupp/widgets/custom_drawer_header.dart';

import '../pages/main_page.dart';

final _firestore = FirebaseFirestore.instance;
// FirebaseUser loggedInFirebaseUser;
// final FirebaseAuth auth = FirebaseAuth.instance;

// ignore: prefer_typing_uninitialized_variables
var loggedInUser;

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? name = '';
  String? email = '';
  String? profileImage = '';
  bool imageUploaded = false;

  final _auth = FirebaseAuth.instance;

  File? _image;
  final picker = ImagePicker();

  void chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  void _uploadImage() async {
    if (_image == null) return;

    final user = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users/${user!.uid}/profile_pic.jpg');
    final uploadTask = storageRef.putFile(_image!);
    await uploadTask.whenComplete(() => null);

    final downloadUrl = await storageRef.getDownloadURL();

    user.updatePhotoURL(downloadUrl);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'profile_pic_url': downloadUrl});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF4F7FC),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          CustomDrawerHeader(
            name: _auth.currentUser!.displayName.toString(),
            email: _auth.currentUser!.email.toString(),
            profileImageUrl: imageUploaded
                ? Image.file(_image!).toString()
                : Image.asset(
                    "/lib/images/swupp-logo.png",
                    width: 30,
                  ).toString(),
          ),
          MenuListTile(
            icon: Icons.person,
            text: 'PROFILE',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                      email: email.toString(),
                      name: name.toString(),
                      profileImageUrl: _image.toString()),
                ),
              );
            },
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: ((context) => MainPage()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// mixin FirebaseUser {}
