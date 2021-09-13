import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messita_app/src/api/pedidos_mesa_api.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/database/pedidos_mesa_temporal_database.dart';
import 'package:messita_app/src/model/detalle_pedido_mesa_model.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:messita_app/src/model/pedidos_mesa_temporal_model.dart';
import 'package:messita_app/src/model/productos_model.dart';
import 'package:messita_app/src/pages/AdminPages/Pedidos/pedido_detalle_page.dart';
import 'package:messita_app/src/pages/CajeroPages/detalle_pedido_caja_page.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

Widget mesaItem(BuildContext context, Responsive responsive, MesasNegocioModel mesa) {
  final preference = Preferences();
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) {
            if (preference.idRol == '5') {
              return PedidosCajaDetallePage(
                mesa: mesa,
              );
            } else {
              return PedidosDetallePage(
                mesa: mesa,
              );
            }
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
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Stack(
        children: [
          Positioned(
            top: responsive.hp(2),
            left: 3,
            bottom: responsive.hp(1),
            child: Container(
              height: responsive.hp(23),
              width: responsive.wp(40),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorsApp.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(1, 2.5),
                  )
                ],
                color: (mesa.mesaEstadoAtencion == '1') ? ColorsApp.redOrange : ColorsApp.greenLemon,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: responsive.wp(4),
                      ),
                      Column(
                        children: [
                          Text(
                            'Cap',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: responsive.ip(2),
                                color: (mesa.mesaEstadoAtencion == '1') ? ColorsApp.white : ColorsApp.greenGrey,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${mesa.mesaCapacidad}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: responsive.ip(2),
                                color: (mesa.mesaEstadoAtencion == '1') ? ColorsApp.white : ColorsApp.greenGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: responsive.hp(3)),
                    child: Text(
                      '${mesa.mesaNombre}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 1,
              right: -1,
              child: Container(
                //height: responsive.hp(30),
                width: responsive.wp(30),
                child: (mesa.idMesa == '0') ? Image.asset('assets/img/delivery.png') : Image.asset('assets/img/mesa_madera.png'),
              )),
        ],
      ),
    ),
  );
}

class ChangeData extends ChangeNotifier {
  int cantidad = 0;
  double precio = 0;
  void actualizarDatos(int val, double price) {
    cantidad = cantidad + val;
    precio = cantidad * price;

    if (cantidad <= 0) {
      cantidad = 0;
      precio = 0;
    }

    notifyListeners();
  }
}

void modalAgregarPedido(BuildContext context, ProductosModel producto, int hayPedido, String idMesa, String idComanda) {
  final _changeData = ChangeData();
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  TextEditingController observacionController = TextEditingController();
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    builder: (BuildContext context) {
      final responsive = Responsive.of(context);

      return ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool data, Widget child) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      margin: EdgeInsets.only(top: responsive.hp(5)),
                      decoration: BoxDecoration(
                        color: ColorsApp.black,
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20),
                          topStart: Radius.circular(20),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: responsive.hp(85),
                            width: double.infinity,
                            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorsApp.mostaza),
                            child: Column(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () async {
                                    _cargando.value = true;
                                    if (_changeData.cantidad > 0) {
                                      if (hayPedido == 0) {
                                        PedidoMesaTemporalModel pedidoTemporal = PedidoMesaTemporalModel();
                                        pedidoTemporal.idMesa = idMesa;
                                        pedidoTemporal.idProducto = producto.idProducto;
                                        pedidoTemporal.nombre = producto.productoNombre;
                                        pedidoTemporal.foto = producto.productoFoto;
                                        pedidoTemporal.precio = producto.productoPrecioVenta;
                                        pedidoTemporal.cantidad = _changeData.cantidad.toString();
                                        pedidoTemporal.observacion = observacionController.text;
                                        pedidoTemporal.total = _changeData.precio.toStringAsFixed(2);

                                        final pedidoTemporalDatabase = PedidosTemporalDatabase();
                                        print('Guardando en DATABASE');
                                        await pedidoTemporalDatabase.insertarPedidoTemporalMesa(pedidoTemporal);
                                        final pedidosBloc = ProviderBloc.pedidos(context);
                                        pedidosBloc.obtenerPedidosTemporalesPorMesa(idMesa);
                                        Navigator.pop(context);
                                      } else {
                                        DetallePedidoMesaModel pedido = DetallePedidoMesaModel();

                                        pedido.idPedido = idComanda;
                                        pedido.idProducto = producto.idProducto;
                                        pedido.precio = producto.productoPrecioVenta;
                                        pedido.cantidad = _changeData.cantidad.toString();
                                        pedido.despacho = 'Salón';
                                        pedido.total = _changeData.precio.toString();
                                        pedido.observacion = observacionController.text;
                                        final pedidoApi = PedidosMesaApi();
                                        final res = await pedidoApi.agregarProductoAPedido(pedido);
                                        if (res) {
                                          final pedidosBloc = ProviderBloc.pedidos(context);
                                          pedidosBloc.obtenerPedidosPorMesa(idMesa);
                                          showToast2('Producto agregado a la orden', ColorsApp.greenGrey);
                                          Navigator.pop(context);
                                        } else {
                                          showToast2('Ocurrió un error, inténtelo nuevamente', ColorsApp.redOrange);
                                        }
                                      }
                                    } else {
                                      showToast2('Debe indicar la cantidad a ordenar', ColorsApp.orange);
                                    }
                                    _cargando.value = false;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: responsive.hp(3), horizontal: responsive.wp(3)),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Ordenar ahora',
                                          style: TextStyle(fontSize: responsive.ip(2.2), color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: responsive.ip(2)),
                                        Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.8), size: responsive.ip(2.3)),
                                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: responsive.ip(2.5))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: responsive.hp(75),
                            width: double.infinity,
                            //margin: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(3)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40)),
                                color: ColorsApp.mostaza),
                            child: Column(
                              children: [
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Observación',
                                        style: TextStyle(color: ColorsApp.black, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: responsive.hp(.5),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(8),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: TextField(
                                      cursorColor: Colors.transparent,
                                      keyboardType: TextInputType.text,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: responsive.hp(1),
                                            horizontal: responsive.wp(4),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          hintStyle: TextStyle(color: Colors.black45),
                                          hintText: 'Observación'),
                                      enableInteractiveSelection: false,
                                      controller: observacionController,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: responsive.hp(4),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: responsive.hp(55),
                            width: double.infinity,
                            //margin: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(3)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40)),
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(3)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.arrow_back_ios)),
                                  Center(
                                    child: Container(
                                      height: responsive.hp(25),
                                      width: responsive.wp(50),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
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
                                          imageUrl: '${producto.productoFoto}',
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
                                  SizedBox(
                                    height: responsive.hp(2),
                                  ),
                                  Text(
                                    '${producto.productoNombre}',
                                    style: TextStyle(fontSize: responsive.ip(2.6), color: ColorsApp.black, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Text(
                                    'S/ ${producto.productoPrecioVenta}',
                                    style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.grey),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(2),
                                  ),
                                  AnimatedBuilder(
                                      animation: _changeData,
                                      builder: (context, _) {
                                        return Row(
                                          children: [
                                            Text(
                                              'S/${_changeData.precio.toStringAsFixed(2)}',
                                              style: TextStyle(fontSize: responsive.ip(3), color: ColorsApp.black, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: responsive.wp(2),
                                            ),
                                            Text(
                                              'Total',
                                              style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.grey),
                                            ),
                                            Spacer(),
                                            Container(
                                              height: responsive.hp(5),
                                              width: responsive.wp(35),
                                              decoration: BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: ColorsApp.grey.withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(2, 2),
                                                )
                                              ], borderRadius: BorderRadius.circular(20), color: Colors.white),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        _changeData.actualizarDatos(-1, double.parse(producto.productoPrecioVenta));
                                                      },
                                                      icon: Icon(Icons.horizontal_rule)),
                                                  Spacer(),
                                                  Text(
                                                    '${_changeData.cantidad}',
                                                    style: TextStyle(fontSize: responsive.ip(3), color: ColorsApp.black, fontWeight: FontWeight.bold),
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                      onPressed: () {
                                                        _changeData.actualizarDatos(1, double.parse(producto.productoPrecioVenta));
                                                      },
                                                      icon: Icon(Icons.add))
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (data)
                        ? Center(
                            child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                          )
                        : Container()
                  ],
                ),
              ),
            );
          });
    },
  );
}

Widget crearAppbar(Preferences preference, Responsive responsive) {
  return SliverAppBar(
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

Widget aplicacion(Responsive responsive, Preferences prefs) {
  return Padding(
    padding: EdgeInsets.all(
      responsive.wp(3),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Aplicación',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsive.ip(3), color: ColorsApp.greenGrey),
        ),
        SizedBox(
          height: responsive.hp(1.5),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  _launchInBrowser('https://capitan.bufeotec.com/Inicio/politicas_privacidad');
                },
                child: Padding(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                          width: responsive.wp(8),
                          height: responsive.wp(8),
                          child: SvgPicture.asset('assets/svg/POLITICA_DE_PRIVACIDA.svg') //Image.asset('assets/logo_largo.svg'),
                          ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Expanded(
                        child: Text(
                          'Política De Privacidad',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  _launchInBrowser('https://capitan.bufeotec.com/Inicio/terminos');
                },
                child: Padding(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                        width: responsive.wp(8),
                        child: Image(
                          image: AssetImage('assets/img/TERMINOS_SERVICIO.png'),
                        ),
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Expanded(
                        child: Text(
                          'Términos de servicio',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   PageRouteBuilder(
                  //     opaque: false,
                  //     transitionDuration: const Duration(milliseconds: 400),
                  //     pageBuilder: (context, animation, secondaryAnimation) {
                  //       return VersionPage();
                  //     },
                  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  //       return FadeTransition(
                  //         opacity: animation,
                  //         child: child,
                  //       );
                  //     },
                  //   ),
                  // );
                },
                child: Padding(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                        width: responsive.wp(8),
                        height: responsive.wp(8),
                        child: Image(
                          image: AssetImage('assets/img/VERSION_APP.png'),
                        ),
                      ),
                      SizedBox(
                        width: responsive.ip(1.5),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'App Versión',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                          Text(
                            '1.00',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        ],
                      )
                    ],
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
