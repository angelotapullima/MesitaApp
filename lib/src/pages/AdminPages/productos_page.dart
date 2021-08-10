import 'package:flutter/material.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/widget/drawer_menu_widget.dart';

class ProductosPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const ProductosPage({Key key, @required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: responsive.hp(5),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DrawerMenuWidget(
                  onClick: openDrawer,
                  color: ColorsApp.grey,
                ),
                Column(
                  children: [
                    Text('Productos'),
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          color: ColorsApp.depOrange,
                        ),
                        Text('${preferences.negocioNombre}'),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
