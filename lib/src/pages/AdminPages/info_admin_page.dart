import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/pages/InfoUser/cerrar_sesion.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/widget/drawer_menu_widget.dart';
import 'package:messita_app/src/widget/widgets.dart';

class InfoAdminPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const InfoAdminPage({Key key, @required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    final responsive = Responsive.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _crearAppbar(preferences, responsive),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: responsive.hp(1)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: responsive.ip(10),
                      height: responsive.ip(10),
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
                  ),
                  SizedBox(
                    width: responsive.wp(4.5),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${preferences.personName} ${preferences.personSurname}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        ),
                        Text(
                          '${preferences.rolName}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: responsive.ip(1.8),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            aplicacion(responsive, preferences),
            Padding(
              padding: EdgeInsets.all(
                responsive.ip(1.5),
              ),
              child: InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return CerrarSession();
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: new Container(
                  //width: 100.0,
                  height: responsive.hp(6),
                  decoration: new BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                    color: Colors.white,
                    border: new Border.all(color: Colors.grey[300], width: 1.0),
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: new Center(
                    child: Text(
                      'Cerrar sesión',
                      style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.w800, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: responsive.hp(20),
            )
          ]))
        ],
      ),
    );
  }

  Widget _crearAppbar(Preferences preference, Responsive responsive) {
    return SliverAppBar(
      leading: DrawerMenuWidget(
        onClick: openDrawer,
        color: Colors.white,
      ),
      elevation: 2.0,
      backgroundColor: ColorsApp.greenGrey,
      expandedHeight: responsive.hp(30),
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          preference.negocioNombre,
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.ip(2.3),
          ),
        ),
        background: Hero(
          tag: '${preference.idNegocio}',
          child: GestureDetector(
            onTap: () {},
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
                  child: Icon(Icons.error),
                ),
              ),
              imageUrl: '${preference.negocioImage}g',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
