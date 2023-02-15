import 'package:flutter/material.dart';
import 'package:swupp/pages/page_builder.dart';

import '../components/tab_item.dart';

class ProductListings extends StatefulWidget {
  const ProductListings({
    Key? key,
    required this.productImage,
    required this.productName,
  }) : super(key: key);

  final String productImage;
  final String productName;

  @override
  State<ProductListings> createState() => _ProductListingsState();
}

class _ProductListingsState extends State<ProductListings> {
  List<ProductListings> listings = [
    const ProductListings(
      productImage: '',
      productName: 'Product name',
    ),
    const ProductListings(
      productImage: '',
      productName: 'Product name',
    ),
    const ProductListings(
      productImage: '',
      productName: 'Product name',
    ),
    const ProductListings(
      productImage: '',
      productName: 'Product name',
    ),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(
        itemCount: listings.length,
        itemBuilder: (context, index) {
          final product = listings[index];
          return Card(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.network(
                    product.productImage,
                    fit: BoxFit.fill,
                  ),
                  Text(product.productName),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
