import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomDrawerHeader extends StatefulWidget {
  final String name;
  final String email;
  final String profileImageUrl;

  CustomDrawerHeader({
    super.key,
    required this.name,
    required this.email,
    required this.profileImageUrl,
  });

  @override
  State<CustomDrawerHeader> createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  bool imageUploaded = false;

  File? _image;

  final picker = ImagePicker();

  void _chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
      imageUploaded = true;
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
    return Padding(
      padding: EdgeInsets.zero,
      child: DrawerHeader(
          decoration: const BoxDecoration(color: Color(0xff171815)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUploaded && _image != null)
                ClipRRect(
                  child: Image.file(
                    _image!,
                    fit: BoxFit.contain,
                    width: 30,
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    _chooseImage();
                  },
                  child: Text('Choose image'),
                ),
              if (imageUploaded && _image != null)
                TextButton(
                  onPressed: () {
                    _uploadImage();
                    this.dispose();
                  },
                  child: const Text('Upload'),
                )
              else
                const Text(''),
              Text(
                widget.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                widget.email,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          )),
    );
  }
}
