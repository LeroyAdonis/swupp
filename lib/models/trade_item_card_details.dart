// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:swupp/models/trade_item_card.dart';

class TradeItemCardDetails extends ChangeNotifier {
  final List<TradeItemCard> _tradeDetails = [
    TradeItemCard(
        itemImage: 'https://picsum.photos/400',
        itemLocation: 'Johannesburg',
        itemTitle: 'HP DeskJet Printer',
        itemEstValue: 'R200 (Est. Value)',
        itemCategory: 'Electronics',
        itemPostedTime: '3 Days ago'),
    TradeItemCard(
        itemImage: 'https://picsum.photos/400?grayscale',
        itemLocation: 'Durban',
        itemTitle: 'Water bottle',
        itemEstValue: 'R30 (Est. Value)',
        itemCategory: 'Container',
        itemPostedTime: '6 months ago'),
    TradeItemCard(
        itemImage: 'https://picsum.photos/seed/picsum/400',
        itemLocation: 'Vryburg',
        itemTitle: 'Laptop',
        itemEstValue: 'Free',
        itemCategory: 'Electronics',
        itemPostedTime: '2 hours ago')
  ];
  List<TradeItemCard> get itemDetails => _tradeDetails;
  int get count {
    return _tradeDetails.length;
  }
}
