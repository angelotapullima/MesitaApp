import 'package:flutter/material.dart';

class DrawerMenuWidget extends StatelessWidget {
  final VoidCallback onClick;
  const DrawerMenuWidget({Key key, @required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: onClick,
      icon: Icon(
        Icons.menu,
      ));
}
