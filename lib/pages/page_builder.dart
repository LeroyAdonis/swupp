// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swupp/components/tab_item.dart';
import 'package:swupp/pages/items_details_page.dart';
import 'package:swupp/pages/sign_in_screen.dart';
import 'package:swupp/pages/main_page.dart';
import 'package:swupp/pages/home_page.dart';
import 'package:swupp/pages/popular_products.dart';
import 'package:swupp/pages/product_listings.dart';
import 'package:swupp/pages/sign_up_screen.dart';
import 'package:swupp/widgets/tabbar_material_widget.dart';
import 'package:swupp/pages/products/list_of_products_screen.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({super.key});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  int index = 0;

  final pages = <Widget>[
    HomePage(),
    ProductList(userId: ''),
    PopularProducts(
      image: Image.asset('/lib/images/swupp-logo-500x500-transparent.png')
          .toString(),
      name: Text('Name').toString(),
      icon: Icon(Icons.abc),
    ),
    ProductListings(productImage: '', productName: ''),
    // PopularProducts(image: '', name: '', icon: SizedBox())
    ItemsDetailsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff62cdf6),
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: TabBarMaterialWidget(
        index: index,
        onChangedTab: onChangedTab,
      ),
      body: pages[index],
    );
  }

  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }
}
