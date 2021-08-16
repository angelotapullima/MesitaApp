import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:messita_app/src/model/pedidos_mesa_model.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';

class PedidosCajaDetallePage extends StatelessWidget {
  final MesasNegocioModel mesa;
  PedidosCajaDetallePage({Key key, @required this.mesa}) : super(key: key);

  static String idComanda = '';
  static String nOrden = '';
  static ValueNotifier<bool> _cargando = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final pedidosBloc = ProviderBloc.pedidos(context);
    pedidosBloc.obtenerPedidosPorMesa(this.mesa.idMesa);
    return Scaffold(
      backgroundColor: ColorsApp.redOrange,
      appBar: AppBar(
        backgroundColor: ColorsApp.redOrange,
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
                      StreamBuilder(
                        stream: pedidosBloc.pedidosMesaStream,
                        builder: (context, AsyncSnapshot<List<PedidoMesaModel>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
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
                                                      Text(
                                                        'Número de orden',
                                                        style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.white),
                                                      ),
                                                      Text(
                                                        '${snapshot.data[0].numeroPedido}',
                                                        style:
                                                            TextStyle(fontSize: responsive.ip(4), color: Colors.white, fontWeight: FontWeight.bold),
                                                      ),
                                                      SizedBox(
                                                        height: responsive.hp(1),
                                                      ),
                                                      Text(
                                                        'Lista de pedidos',
                                                        style: TextStyle(
                                                          fontSize: responsive.ip(3),
                                                          color: ColorsApp.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                            index = index - 1;
                                            return Container(
                                              margin: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(1)),
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
                                                                fontSize: responsive.ip(2.2), color: ColorsApp.black, fontWeight: FontWeight.bold),
                                                          ),
                                                          Text(
                                                            'x',
                                                            style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.black),
                                                          ),
                                                          Text(
                                                            ' S/${snapshot.data[0].detalle[index].total}',
                                                            style: TextStyle(
                                                                fontSize: responsive.ip(2.2), color: ColorsApp.black, fontWeight: FontWeight.bold),
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
                              return Center(child: Text('Volver a Cargar'));
                            }
                          } else {
                            return Center(
                              child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                            );
                          }
                        },
                      )
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
