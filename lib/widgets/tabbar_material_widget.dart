import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  const TabBarMaterialWidget(
      {Key? key, required this.index, required this.onChangedTab})
      : super(key: key);

  @override
  State<TabBarMaterialWidget> createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    const placeholder = Opacity(
      opacity: 0,
      child: IconButton(
        onPressed: null,
        icon: Icon(Icons.abc),
      ),
    );
    return BottomAppBar(
      color: Color.fromRGBO(244, 247, 252, 1),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
            index: 0,
            icon: const Icon(Icons.home),
            label: const Text('Home'),
          ),
          buildTabItem(
            index: 1,
            icon: const Icon(EvaIcons.flip2Outline),
            label: const Text('Trades'),
          ),
          placeholder,
          buildTabItem(
            index: 2,
            icon: const Icon(Icons.message),
            label: const Text('Chats'),
          ),
          buildTabItem(
            index: 3,
            icon: const Icon(Icons.inbox),
            label: const Text('Inbox'),
          ),
        ],
      ),
    );
  }

  Widget buildTabItem(
      {required int index, required Icon icon, required Widget label}) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        color: isSelected
            ? const Color.fromRGBO(67, 72, 83, 1)
            : Color.fromARGB(255, 138, 142, 149),
        // : const Color.fromRGBO(67, 72, 83, 1),
      ),
      child: IconButton(
        icon: icon,
        onPressed: (() => widget.onChangedTab(index)),
      ),
    );
  }
}
