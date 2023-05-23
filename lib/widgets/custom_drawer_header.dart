import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool uploadingImage = false;

  File? _image;

  final picker = ImagePicker();

  final double radius;

  String? _profilePicUrl;

  _CustomDrawerHeaderState({this.radius = 40});

  void _chooseImage() async {
    if (!imageUploaded) {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        // maxWidth: 80,
        // maxHeight: 80,
        imageQuality: 100,
      );
      setState(() {
        _image = File(pickedFile!.path);
        imageUploaded = true;
        _profilePicUrl = null; // reset the profile pic URL
      });

      if (_image == null) return;

      setState(() {
        uploadingImage = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users/${user!.uid}/profile_pic.jpg');
      // Delete the previous image
      final prevImage = await storageRef.getDownloadURL().catchError((_) {});
      if (prevImage != null) {
        await FirebaseStorage.instance.refFromURL(prevImage).delete();
      }
      final uploadTask = storageRef.putFile(_image!);
      await uploadTask.whenComplete(() => null);

      final downloadUrl = await storageRef.getDownloadURL();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('profile_pic_url', downloadUrl);

      setState(() {
        _profilePicUrl = downloadUrl;
        uploadingImage = false;
      });

      user.updatePhotoURL(downloadUrl);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profile_pic_url': downloadUrl});
    }
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
    return Padding(
      padding: EdgeInsets.zero,
      child: DrawerHeader(
          decoration: const BoxDecoration(color: Color(0xff62cdf6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (_profilePicUrl != null)
                    GestureDetector(
                      onTap: (() {
                        _chooseImage();
                      }),
                      child: CircleAvatar(
                        radius: radius,
                        backgroundImage:
                            CachedNetworkImageProvider(_profilePicUrl!),
                      ),
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
                        child: const Center(
                            child: Icon(Icons.camera_alt_outlined)),
                      ),
                    ),
                  if (uploadingImage)
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                ],
              ),
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
