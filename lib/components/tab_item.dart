import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  TabItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Color.fromRGBO(96, 205, 246, 1)
                : Color.fromRGBO(67, 72, 83, 1),
          ),
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Color.fromRGBO(96, 205, 246, 1)
                  : Color.fromRGBO(67, 72, 83, 1),
            ),
          ),
        ],
      ),
    );
  }
}
