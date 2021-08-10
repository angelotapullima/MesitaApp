import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/widget/drawer_menu_widget.dart';

class PedidosPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const PedidosPage({Key key, @required this.openDrawer}) : super(key: key);

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
                    Text('Negocio'),
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
                Container(
                  width: responsive.ip(5),
                  height: responsive.ip(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Icon(
                            Icons.error,
                          ),
                        ),
                      ),
                      imageUrl: '${preferences.negocioImage}g',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
