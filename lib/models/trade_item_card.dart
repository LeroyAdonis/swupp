import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:swupp/pages/items_details_page.dart';

// ignore: must_be_immutable
class TradeItemCard extends StatelessWidget {
  final String itemImage;
  final String itemTitle;
  final String itemLocation;
  final String itemEstValue;
  final String itemCategory;
  final String itemPostedTime;
  final int i = 0;

  const TradeItemCard({
    Key? key,
    required this.itemImage,
    required this.itemTitle,
    required this.itemLocation,
    required this.itemEstValue,
    required this.itemCategory,
    required this.itemPostedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, ItemsDetailsPage.routName,
                          arguments: TradeItemCard(
                            itemImage: itemImage,
                            itemTitle: itemTitle,
                            itemLocation: itemLocation,
                            itemEstValue: itemEstValue,
                            itemCategory: itemCategory,
                            itemPostedTime: itemPostedTime,
                          )),
                  child: Image.network(
                    itemImage,
                    width: 500,
                  ),
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Text(
                  itemTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  textScaleFactor: 1.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Colors.grey,
                            ),
                            Text(
                              itemLocation,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Icon(
                            EvaIcons.flip2Outline,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            EvaIcons.heartOutline,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),

      // child: Card(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(15),
      //   ),
      //   elevation: 3,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: ClipRect(
      //           child: Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Image.network(
      //               itemImage!,
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //         ),
      //       ),
      //       Material(
      //         child: ListTile(
      //           // leading: Icon(Icons.location_pin),
      //           title: Text(
      //             itemTitle!,
      //             style: const TextStyle(fontSize: 20),
      //           ),
      //           subtitle: Row(
      //             children: [
      //               const Icon(Icons.location_pin),
      //               Text(
      //                 itemLocation!,
      //                 style: const TextStyle(fontSize: 16),
      //               ),
      //             ],
      //           ),
      //           trailing: const Icon(EvaIcons.heartOutline),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
