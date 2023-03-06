import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String profileImageUrl;
  const ProfilePage({
    Key? key,
    required this.name,
    required this.email,
    required this.profileImageUrl,
  }) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool imageUploaded = false;

  File? _image;

  final picker = ImagePicker();

  final double radius;

  String? _profilePicUrl;

  _ProfilePageState({this.radius = 60});

  void _chooseImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 80,
      maxHeight: 80,
      imageQuality: 100,
    );
    setState(() {
      _image = File(pickedFile!.path);
      imageUploaded = true;
    });

    if (_image == null) return;

    final user = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users/${user!.uid}/profile_pic.jpg');
    final uploadTask = storageRef.putFile(_image!);
    await uploadTask.whenComplete(() => null);

    final downloadUrl = await storageRef.getDownloadURL();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_pic_url', downloadUrl);

    setState(() {
      _profilePicUrl = downloadUrl;
    });

    user.updatePhotoURL(downloadUrl);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'profile_pic_url': downloadUrl});
  }

  @override
  void initState() {
    super.initState();

    _getImage();

    final user = FirebaseAuth.instance.currentUser;

    if (_profilePicUrl == null && user != null) {
      FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/profile_pic.jpg')
          .getDownloadURL()
          .then((downloadUrl) {
        setState(() {
          _profilePicUrl = downloadUrl;
        });
      }).catchError((error) {
        print('Error getting profile pic URL: $error');
      });
    }
  }

  void _getImage() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('profile_pic_url');
    if (url != null) {
      setState(() {
        _image = NetworkImage(url) as File?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            children: [
              Row(children: [],),
              if (_profilePicUrl != null)
                CircleAvatar(
                  radius: radius,
                  backgroundImage: NetworkImage(_profilePicUrl!),
                )
              else if (_image != null)
                CircleAvatar(
                  radius: radius,
                  backgroundImage: FileImage(_image!),
                )
              else
                GestureDetector(
                  onTap: (() {
                    _chooseImage();
                  }),
                  child: CircleAvatar(
                    radius: radius,
                    child: const Center(child: Icon(Icons.camera_alt_outlined)),
                  ),
                ),
              const SizedBox(height: 20),
              Text('Logged in as: ${user!.displayName}', ),
            ],
          ),
        ),
      ),
    );
  }
}
