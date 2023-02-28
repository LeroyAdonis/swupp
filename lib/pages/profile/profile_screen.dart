import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null) ...[
              Image.file(_image!),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: chooseImage,
              child: const Text('Choose Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            Text('Logged in as: ${user!.displayName}'),
          ],
        ),
      ),
    );
  }
}
