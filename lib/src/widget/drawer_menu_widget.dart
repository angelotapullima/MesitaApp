import 'package:flutter/material.dart';

class DrawerMenuWidget extends StatelessWidget {
  final VoidCallback onClick;
  final Color color;
  const DrawerMenuWidget({Key key, @required this.onClick, @required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: onClick,
      icon: Icon(
        Icons.menu,
        color: color,
      ));
}
