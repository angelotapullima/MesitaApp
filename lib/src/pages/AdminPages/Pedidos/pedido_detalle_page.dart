import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:messita_app/src/api/pedidos_mesa_api.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:messita_app/src/model/pedidos_mesa_model.dart';
import 'package:messita_app/src/model/pedidos_mesa_temporal_model.dart';
import 'package:messita_app/src/model/productos_model.dart';
import 'package:messita_app/src/pages/AdminPages/Pedidos/eliminar_detalle_pedido.dart';
import 'package:messita_app/src/pages/AdminPages/Productos/mostrar_foto_producto_page.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/utils/utils.dart';
import 'package:messita_app/src/widget/widgets.dart';

class PedidosDetallePage extends StatelessWidget {
  final MesasNegocioModel mesa;
  PedidosDetallePage({Key key, @required this.mesa}) : super(key: key);

  static int cargaInicial = 0;
  static int hayPedido = 0;
  static String idComanda = '';
  static String nOrden = '';
  static ValueNotifier<bool> _cargando = ValueNotifier(false);
  static TextEditingController _query = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prefences = Preferences();
    final responsive = Responsive.of(context);
    final busquedaBloc = ProviderBloc.productos(context);
    final pedidosBloc = ProviderBloc.pedidos(context);
    pedidosBloc.obtenerPedidosPorMesa(this.mesa.idMesa);
    pedidosBloc.obtenerPedidosTemporalesPorMesa(this.mesa.idMesa);
    if (cargaInicial == 0) {
      busquedaBloc.obtenerProductosPorQuery('');
      cargaInicial++;
    }
    return Scaffold(
      backgroundColor: (mesa.mesaEstadoAtencion == '1') ? ColorsApp.redOrange : ColorsApp.greenLemon,
      appBar: AppBar(
        backgroundColor: (mesa.mesaEstadoAtencion == '1') ? ColorsApp.redOrange : ColorsApp.greenLemon,
        actions: [],
        elevation: 0,
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: _cargando,
            builder: (BuildContext context, bool data, Widget child) {
              return Stack(
                children: [
                  Positioned(
                      top: responsive.hp(35),
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: responsive.wp(3), right: responsive.wp(1)),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pedidos',
                                  style: TextStyle(letterSpacing: 1.5, fontSize: responsive.ip(3), color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${this.mesa.mesaNombre}',
                                  style: TextStyle(fontSize: responsive.ip(5), color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Capacidad: ${mesa.mesaCapacidad}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.greenGrey, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              height: responsive.hp(15),
                              width: responsive.wp(25),
                              child: (mesa.idMesa == '0') ? Image.asset('assets/img/delivery.png') : Image.asset('assets/img/mesa_madera.png'),
                            )
                          ],
                        ),
                      ),
                      (prefences.idRol != '5')
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: responsive.wp(3), vertical: responsive.hp(2)),
                              child: CupertinoSearchTextField(
                                controller: _query,
                                backgroundColor: ColorsApp.white,
                                placeholder: 'Buscar producto',
                                onChanged: (value) {
                                  if (value != '') {
                                    busquedaBloc.obtenerProductosPorQuery(value);
                                  } else {
                                    _query.text = '';
                                    busquedaBloc.obtenerProductosPorQuery(_query.text);
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )
                          : Container(),
                      StreamBuilder(
                        stream: busquedaBloc.productosBusquedaStream,
                        builder: (BuildContext context, AsyncSnapshot<List<ProductosModel>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return Expanded(
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
                                                _query.text = '';
                                                busquedaBloc.obtenerProductosPorQuery(_query.text);
                                                FocusManager.instance.primaryFocus?.unfocus();

                                                modalAgregarPedido(context, snapshot.data[index], hayPedido, idComanda, this.mesa.idMesa);
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
                                                                fontSize: responsive.ip(2.3),
                                                                color: ColorsApp.greenGrey,
                                                                fontWeight: FontWeight.bold),
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
                                                  width: responsive.ip(15),
                                                  height: responsive.ip(15),
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
                                    }),
                              );
                            } else {
                              return StreamBuilder(
                                stream: pedidosBloc.pedidosMesaStream,
                                builder: (context, AsyncSnapshot<List<PedidoMesaModel>> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.length > 0) {
                                      hayPedido++;
                                      idComanda = '${snapshot.data[0].idPedido}';
                                      nOrden = '${snapshot.data[0].numeroPedido}';
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount: snapshot.data[0].detalle.length + 1,
                                                  itemBuilder: (_, index) {
                                                    if (index == 0) {
                                                      return Center(
                                                        child: Container(
                                                          child: Column(
                                                            children: [
                                                              Text('Número de orden'),
                                                              Text(
                                                                '${snapshot.data[0].numeroPedido}',
                                                                style: TextStyle(
                                                                    fontSize: responsive.ip(3), color: Colors.white, fontWeight: FontWeight.bold),
                                                              ),
                                                              SizedBox(
                                                                height: responsive.hp(1),
                                                              ),
                                                              Text(
                                                                'Lista de pedidos',
                                                                style: TextStyle(
                                                                  fontSize: responsive.ip(2.5),
                                                                  color: ColorsApp.grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    index = index - 1;
                                                    return FocusedMenuHolder(
                                                      openWithTap: true,
                                                      onPressed: () {},
                                                      menuItems: [
                                                        FocusedMenuItem(
                                                            backgroundColor: Colors.redAccent,
                                                            title: Expanded(
                                                              child: Text(
                                                                "Eliminar",
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                            ),
                                                            trailingIcon: Icon(
                                                              Icons.delete,
                                                              color: Colors.white,
                                                            ),
                                                            onPressed: () async {
                                                              _cargando.value = true;
                                                              Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                    opaque: false,
                                                                    transitionDuration: const Duration(milliseconds: 400),
                                                                    pageBuilder: (context, animation, secondaryAnimation) {
                                                                      return ConfirmarEliminarDetallePedido(
                                                                        idMesa: this.mesa.idMesa,
                                                                        idPedido: snapshot.data[0].idPedido,
                                                                        idDetallePedido: snapshot.data[0].detalle[index].idDetallePedido,
                                                                      );
                                                                    },
                                                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                      return FadeTransition(
                                                                        opacity: animation,
                                                                        child: child,
                                                                      );
                                                                    },
                                                                  ));

                                                              _cargando.value = false;
                                                            })
                                                      ],
                                                      child: Container(
                                                        height: responsive.hp(15),
                                                        child: Stack(
                                                          children: [
                                                            Positioned(
                                                              top: responsive.hp(2),
                                                              bottom: 0,
                                                              left: 0,
                                                              right: 0,
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(1)),
                                                                height: responsive.hp(10),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(30),
                                                                  color: Colors.white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: ColorsApp.grey.withOpacity(0.5),
                                                                      spreadRadius: 1,
                                                                      blurRadius: 10,
                                                                      offset: Offset(2, 2),
                                                                    )
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width: responsive.ip(5),
                                                                        height: responsive.ip(5),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(100),
                                                                          child: CachedNetworkImage(
                                                                            placeholder: (context, url) => Container(
                                                                              width: double.infinity,
                                                                              height: double.infinity,
                                                                              child: Image(
                                                                                  image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
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
                                                                            imageUrl: '${snapshot.data[0].detalle[index].foto}',
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
                                                                      SizedBox(width: responsive.wp(2)),
                                                                      Center(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              '${snapshot.data[0].detalle[index].nombre}',
                                                                              style: TextStyle(
                                                                                  fontSize: responsive.ip(2.2),
                                                                                  color: ColorsApp.greenGrey,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                            (snapshot.data[0].detalle[index].observacion != '')
                                                                                ? Text(
                                                                                    '${snapshot.data[0].detalle[index].observacion}',
                                                                                    textAlign: TextAlign.left,
                                                                                  )
                                                                                : Container(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Spacer(),
                                                                      Center(
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              '${snapshot.data[0].detalle[index].cantidad} ',
                                                                              style: TextStyle(
                                                                                  fontSize: responsive.ip(2.2),
                                                                                  color: ColorsApp.black,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'x',
                                                                              style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.black),
                                                                            ),
                                                                            Text(
                                                                              ' S/${snapshot.data[0].detalle[index].total}',
                                                                              style: TextStyle(
                                                                                  fontSize: responsive.ip(2.2),
                                                                                  color: ColorsApp.black,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                                top: responsive.hp(0.5),
                                                                right: 0,
                                                                child: Container(
                                                                  margin: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(20), color: ColorsApp.orangeLight),
                                                                  child: Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: responsive.wp(3), vertical: responsive.hp(1)),
                                                                    child: Text(
                                                                      'En preparación',
                                                                      style: TextStyle(
                                                                          fontSize: responsive.ip(2),
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: responsive.wp(2), vertical: responsive.hp(1)),
                                              height: responsive.hp(7),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorsApp.redOrange),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Pagar total, ',
                                                    style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.white),
                                                  ),
                                                  Text(
                                                    'S/${snapshot.data[0].total}',
                                                    style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    } else {
                                      hayPedido = 0;
                                      return StreamBuilder(
                                          stream: pedidosBloc.pedidosTemporalesStream,
                                          builder: (context, AsyncSnapshot<List<PedidoMesaTemporalModel>> temporales) {
                                            if (temporales.hasData) {
                                              if (temporales.data.length > 0) {
                                                return Expanded(
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: ListView.builder(
                                                            itemCount: temporales.data.length + 1,
                                                            itemBuilder: (_, xxx) {
                                                              if (xxx == 0) {
                                                                return Center(
                                                                  child: Container(
                                                                    child: Column(
                                                                      children: [
                                                                        Text(
                                                                          'Comanda para ${this.mesa.mesaNombre}',
                                                                          style: TextStyle(
                                                                            fontSize: responsive.ip(2.5),
                                                                            color: ColorsApp.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              xxx = xxx - 1;
                                                              return Container(
                                                                margin:
                                                                    EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(1)),
                                                                height: responsive.hp(10),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(30),
                                                                  color: Colors.white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: ColorsApp.grey.withOpacity(0.5),
                                                                      spreadRadius: 1,
                                                                      blurRadius: 10,
                                                                      offset: Offset(2, 2),
                                                                    )
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width: responsive.ip(5),
                                                                        height: responsive.ip(5),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(100),
                                                                          child: CachedNetworkImage(
                                                                            placeholder: (context, url) => Container(
                                                                              width: double.infinity,
                                                                              height: double.infinity,
                                                                              child: Image(
                                                                                  image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
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
                                                                            imageUrl: '${temporales.data[xxx].foto}',
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
                                                                      SizedBox(width: responsive.wp(2)),
                                                                      Center(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              '${temporales.data[xxx].nombre}',
                                                                              style: TextStyle(
                                                                                  fontSize: responsive.ip(2.2),
                                                                                  color: ColorsApp.greenGrey,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                            (temporales.data[xxx].observacion != '')
                                                                                ? Text(
                                                                                    '${temporales.data[xxx].observacion}',
                                                                                    textAlign: TextAlign.left,
                                                                                  )
                                                                                : Container(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Spacer(),
                                                                      Center(
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              '${temporales.data[xxx].cantidad} ',
                                                                              style: TextStyle(
                                                                                  fontSize: responsive.ip(2.2),
                                                                                  color: ColorsApp.black,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'x',
                                                                              style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.black),
                                                                            ),
                                                                            Text(
                                                                              ' S/${temporales.data[xxx].total}',
                                                                              style: TextStyle(
                                                                                  fontSize: responsive.ip(2.2),
                                                                                  color: ColorsApp.black,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          _cargando.value = true;
                                                          final pedidoApi = PedidosMesaApi();
                                                          final res = await pedidoApi.generarNuevoPedido(this.mesa.idMesa, this.mesa.mesaCapacidad);
                                                          if (res) {
                                                            final mesasBloc = ProviderBloc.mesas(context);
                                                            mesasBloc.obtenerMesasPedidos();
                                                            pedidosBloc.obtenerPedidosPorMesa(this.mesa.idMesa);
                                                            showToast2('Pedido Generado', ColorsApp.greenGrey);
                                                          } else {
                                                            showToast2('Ocurrió un error, inténtelo nuevamente', ColorsApp.redOrange);
                                                          }
                                                          _cargando.value = false;
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.symmetric(horizontal: responsive.wp(2), vertical: responsive.hp(1)),
                                                          height: responsive.hp(7),
                                                          decoration:
                                                              BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorsApp.greenLemon),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                'Generar Pedido',
                                                                style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.black),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Center(child: Text('Comience a buscar el producto para crear la comanda'));
                                              }
                                            } else {
                                              return Center(
                                                child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                                              );
                                            }
                                          });
                                    }
                                  } else {
                                    return Container();
                                  }
                                },
                              );
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                  (data)
                      ? Center(
                          child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                        )
                      : Container()
                ],
              );
            }),
      ),
    );
  }
}
