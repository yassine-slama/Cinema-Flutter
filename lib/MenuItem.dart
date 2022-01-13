// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  String menuTitle;
  final Icon menuIcon;
  Function handler;

  MenuItem(this.menuTitle, this.menuIcon, this.handler);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(menuTitle),
      leading: menuIcon,
      trailing: Icon(Icons.arrow_right),
      onTap: () {
        handler(context);
      },
    );
  }
}
