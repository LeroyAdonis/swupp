import 'package:flutter/material.dart';

class MenuListTile extends StatelessWidget {
  const MenuListTile({
    Key? key,
    required this.text,
    // required this.isSelected,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String text;
  // final bool isSelected;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      // selected: isSelected,
      onTap: onTap,
    );
  }
}
