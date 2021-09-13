import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/model/productos_model.dart';
import 'package:messita_app/src/pages/AdminPages/Productos/agregar_productos_page.dart';
import 'package:messita_app/src/pages/AdminPages/Productos/editar_producto_page.dart';
import 'package:messita_app/src/pages/AdminPages/Productos/mostrar_foto_producto_page.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/utils/utils.dart';
import 'package:messita_app/src/widget/drawer_menu_widget.dart';

class ProductosPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const ProductosPage({Key key, @required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final productosBloc = ProviderBloc.productos(context);
    productosBloc.obtenerProductos();
    return Scaffold(
      backgroundColor: ColorsApp.greenGrey,
      appBar: AppBar(
        backgroundColor: ColorsApp.greenGrey,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: responsive.wp(1), top: responsive.hp(1)),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return AgregarProductosPage();
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
              child: Container(
                width: responsive.ip(4),
                height: responsive.ip(4),
                child: CircleAvatar(
                  backgroundColor: ColorsApp.orange,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
        leading: DrawerMenuWidget(
          onClick: openDrawer,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
          stream: productosBloc.productosStream,
          builder: (context, AsyncSnapshot<List<ProductosModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return Stack(
                  children: [
                    Positioned(
                      top: responsive.hp(25),
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(150),
                            //topStart: Radius.circular(10),
                          ),
                          color: ColorsApp.white,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: responsive.wp(3)),
                          child: Text(
                            'Mis Productos',
                            style: TextStyle(fontSize: responsive.ip(5), color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (_, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                                    height: responsive.hp(20),
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                opaque: false,
                                                transitionDuration: const Duration(milliseconds: 400),
                                                pageBuilder: (context, animation, secondaryAnimation) {
                                                  return EditarProductoPage(
                                                    producto: snapshot.data[index],
                                                  );
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
                                          child: Container(
                                            margin: EdgeInsets.only(left: responsive.wp(2), top: responsive.hp(4), right: responsive.wp(2)),
                                            height: responsive.hp(18),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorsApp.grey.withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  offset: Offset(1, 3), // changes position of shadow
                                                )
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Spacer(),
                                                Container(
                                                  width: responsive.wp(60),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: responsive.hp(1.5),
                                                      ),
                                                      Text(
                                                        '${snapshot.data[index].productoNombre}',
                                                        style: TextStyle(
                                                            fontSize: responsive.ip(2.3), color: ColorsApp.greenGrey, fontWeight: FontWeight.bold),
                                                      ),
                                                      Text('${snapshot.data[index].productoDescripcion}'),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          Spacer(),
                                                          Text(
                                                            'S/ ${snapshot.data[index].productoPrecioVenta}',
                                                            style: TextStyle(
                                                                fontSize: responsive.ip(2.2),
                                                                color: ColorsApp.depOrange,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          SizedBox(
                                                            width: responsive.wp(5),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: responsive.hp(1),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: responsive.wp(1),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: responsive.wp(5),
                                          bottom: responsive.hp(2),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  opaque: false,
                                                  transitionDuration: const Duration(milliseconds: 400),
                                                  pageBuilder: (context, animation, secondaryAnimation) {
                                                    return MostrarFotoProductoPage(
                                                      producto: snapshot.data[index],
                                                    );
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
                                            child: Container(
                                              width: responsive.ip(13),
                                              height: responsive.ip(13),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: ColorsApp.grey.withOpacity(0.9),
                                                    spreadRadius: 1,
                                                    blurRadius: 10,
                                                    offset: Offset(2, 4),
                                                  )
                                                ],
                                              ),
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
                                                    child: Image(image: AssetImage('assets/img/food.jpg'), fit: BoxFit.cover),
                                                  ),
                                                  imageUrl: '${snapshot.data[index].productoFoto}',
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    decoration: BoxDecoration(
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
                                        )
                                      ],
                                    ),
                                  );
                                }))
                      ],
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text('Sin productos agregados'),
                );
              }
            } else {
              return mostrarAlert();
            }
          }),
    );
  }
}
