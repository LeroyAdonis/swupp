import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductCard {
  final String title;
  final String description;
  final String imageUrl;

  ProductCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class ProductList extends StatelessWidget {
  final String userId;

  ProductList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('products')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<ProductCard> products = [];

        snapshot.data!.docs.forEach((doc) {
          products.add(ProductCard(
            title: doc['title'],
            description: doc['description'],
            imageUrl: doc['imageUrl'],
          ));
        });

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: <Widget>[
                  Image.network(products[index].imageUrl),
                  Text(products[index].title),
                  Text(products[index].description),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class UploadProduct extends StatefulWidget {
  final String userId;

  UploadProduct({required this.userId});

  @override
  _UploadProductState createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  String? _title;
  String? _description;
  String? _imageUrl;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images/${widget.userId}/${DateTime.now()}.jpg');

      final uploadTask = storageRef.putFile(
        File(pickedFile.path),
      );
      await uploadTask.whenComplete(() => null);

      final downloadUrl = await storageRef.getDownloadURL();

      final String url = downloadUrl;

      setState(() {
        _imageUrl = url;
      });
    }
  }

  void _submitForm() {
    final CollectionReference productsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('products');

    productsRef.add({
      'title': _title,
      'description': _description,
      'imageUrl': _imageUrl,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            onChanged: (value) {
              setState(() {
                _title = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            onChanged: (value) {
              setState(() {
                _description = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Choose Image'),
            onPressed: _uploadImage,
          ),
          SizedBox(height: 20),
          _imageUrl != null
              ? Image.network(_imageUrl!)
              : Placeholder(
                  fallbackHeight: 200,
                ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Submit'),
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }
}
