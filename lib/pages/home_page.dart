import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:swupp/components/menu_list_tile.dart';
import 'package:swupp/widgets/drawer.dart';

import '../models/trade_item_card.dart';
import '../models/trade_item_card_details.dart';
// import 'package:swupp/api/unsplash_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<String> docIDs = [];

  bool _isLoading = false;

  Future getDocID() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: auth.currentUser)
        .get();
  }

  void inputData() {
    final User? user = auth.currentUser;

    // here you write the codes to input the data into firestore
    // MyDrawer.userEmail.value = user!.email!;
    // MyDrawer.userName.value = user.uid;
  }

  @override
  void initState() {
    // inputData();
    super.initState();
    // getData();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 247, 252, 1),
      appBar: AppBar(
        backgroundColor: const Color(0xff62cdf6),
        title: const Text('Browse Trades'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Consumer<TradeItemCardDetails>(
                builder: (context, tradeItemData, child) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = tradeItemData.itemDetails[index];
                      return TradeItemCard(
                        itemImage: item.itemImage,
                        itemTitle: item.itemTitle,
                        itemLocation: item.itemLocation,
                        itemEstValue: item.itemEstValue,
                        itemCategory: item.itemCategory,
                        itemPostedTime: item.itemPostedTime,
                      );
                    },
                    itemCount: tradeItemData.count,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
