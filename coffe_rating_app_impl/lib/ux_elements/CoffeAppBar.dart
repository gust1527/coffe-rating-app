import 'package:flutter/material.dart';

class CoffeAppBar extends StatelessWidget implements PreferredSizeWidget{
  String appBarTitle;

  // ignore: use_key_in_widget_constructors
  CoffeAppBar({
    required this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(appBarTitle, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.yellow[700], // Add a valid color value here
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}