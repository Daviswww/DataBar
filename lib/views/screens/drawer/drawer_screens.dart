import 'package:flutter/material.dart';

class DrawerScreens extends StatefulWidget {
  @override
  _DrawerScreensState createState() => _DrawerScreensState();
}

class _DrawerScreensState extends State<DrawerScreens> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
          Text("qwe"),
        ],
      ),
    );
  }
}
