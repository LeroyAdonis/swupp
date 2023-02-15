import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trade_item_card.dart';
import '../models/trade_item_card_details.dart';

class ItemsDetailsPage extends StatelessWidget {
  const ItemsDetailsPage({super.key});

  static const routName = '/lib/pages/items_details_page.dart';

  @override
  Widget build(BuildContext context) {
    TradeItemCard tradeItemCard =
        ModalRoute.of(context)!.settings.arguments as TradeItemCard;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: Text(tradeItemCard.itemTitle),
        ),
        body: Consumer<TradeItemCardDetails>(
            builder: (context, tradeItemData, child) {
          return ListView(
            children: [
              Image(image: NetworkImage(tradeItemCard.itemImage)),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: Text(tradeItemCard.itemTitle,
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.w500,
                        ),
                        textScaleFactor: 2),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_pin),
                              Text(
                                tradeItemCard.itemLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.schedule_rounded),
                              Text(tradeItemCard.itemPostedTime),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Second Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.monetization_on),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                tradeItemCard.itemEstValue,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.sort),
                              Text(tradeItemCard.itemCategory),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
