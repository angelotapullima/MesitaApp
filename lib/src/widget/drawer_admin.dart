import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/widget/draw_items_widget.dart';

class DrawerAdmin extends StatelessWidget {
  final ValueChanged<DrawerItem> onselectItem;
  final String itemSelect;
  const DrawerAdmin({Key key, @required this.onselectItem, @required this.itemSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();
    return Container(
      padding: EdgeInsets.only(top: responsive.hp(1), left: responsive.wp(3), bottom: responsive.hp(3)),
      //color: ColorsApp.greenGrey,

      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      width: responsive.ip(7),
                      height: responsive.ip(7),
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
                    SizedBox(
                      width: responsive.wp(1),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${preferences.personName} ${preferences.personSurname}',
                          style: TextStyle(color: Colors.white, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                        ),
                        Text('${preferences.rolName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(1.7),
                            ))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: responsive.hp(10),
              ),
              Column(
                children: DrawerItems.menu
                    .map((e) => ListTile(
                          onTap: () => onselectItem(e),
                          leading: Icon(
                            e.icon,
                            color: (itemSelect == e.titulo) ? ColorsApp.orange : Colors.white,
                            size: responsive.ip(3),
                          ),
                          title: Text(e.titulo,
                              style: TextStyle(
                                color: (itemSelect == e.titulo) ? ColorsApp.orange : Colors.white,
                                fontSize: responsive.ip(2.2),
                              )),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
