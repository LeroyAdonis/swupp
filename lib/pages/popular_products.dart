// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class PopularProducts extends StatelessWidget {
  final String image;
  final String name;
  final Widget icon;

  const PopularProducts({required this.image, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 80.0,
      width: 80.0,
      child: Stack(
        children: <Widget>[
          Container(
            height: 60.0,
            width: 60.0,
            margin: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              //  shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(color: Colors.white),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(image),
              ),
            ),
            child: icon,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              name,
              style: TextStyle(fontSize: 15.0),
            ),
          )
        ],
      ),
    );
  }
}
