import 'dart:ffi';

import 'package:flutter/material.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({
    Key? key,
    required this.onselect,
    required this.item,
  }) : super(key: key);
  final void Function(int) onselect;
  final List<PopupMenuEntry<int>> item;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(
        side:  const BorderSide(
          color: Colors.red,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      icon: const Icon(
        Icons.more_vert_outlined,
        color: Colors.red,
      ),
      itemBuilder: (BuildContext context) => item,
      onSelected: onselect,
    );
  }
}
