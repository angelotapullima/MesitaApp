import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:messita_app/src/model/pedidos_mesa_model.dart';
import 'package:messita_app/src/model/productos_model.dart';
import 'package:messita_app/src/pages/AdminPages/Productos/mostrar_foto_producto_page.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';

class PedidosDetallePage extends StatelessWidget {
  final MesasNegocioModel mesa;
  PedidosDetallePage({Key key, @required this.mesa}) : super(key: key);

  static int cargaInicial = 0;

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: ColorsApp.greenLemon,
      appBar: AppBar(
        backgroundColor: ColorsApp.greenLemon,
        actions: [],
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3), vertical: responsive.hp(2)),
                  child: CupertinoSearchTextField(
                    backgroundColor: ColorsApp.white,
                    placeholder: 'Buscar producto',
                    onChanged: (value) {
                      if (value != '') {
                        busquedaBloc.obtenerProductosPorQuery(value);
                      } else {
                        busquedaBloc.obtenerProductosPorQuery('');
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
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
                                          modalAgregarPedido(context);
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
                                                              fontSize: responsive.ip(2.2), color: ColorsApp.depOrange, fontWeight: FontWeight.bold),
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
                                return Column(
                                  children: [
                                    Container(
                                      child: Text('${snapshot.data[0].numeroPedido}'),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                            itemCount: snapshot.data[0].detalle.length,
                                            itemBuilder: (_, index) {
                                              return Container();
                                            }))
                                  ],
                                );
                              } else {
                                return Container();
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
          ],
        ),
      ),
    );
  }

  void modalAgregarPedido(BuildContext context) {
    TextEditingController nombreReservaController = TextEditingController();
    TextEditingController montoPagarController = TextEditingController();
    TextEditingController telefonoController = TextEditingController();
    TextEditingController observacionController = TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        final responsive = Responsive.of(context);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              margin: EdgeInsets.only(top: responsive.hp(5)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(20),
                  topStart: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: responsive.hp(2),
                  left: responsive.wp(5),
                  right: responsive.wp(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Reservar Cancha',
                        style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.home, color: Colors.green),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Flexible(
                          child: Text('Pedir'),
                        ),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Flexible(
                          child: Text('-'),
                        ),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Icon(Icons.food_bank, color: Colors.green),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Flexible(
                          child: Text('Comida'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.calendar_today, color: Colors.green),
                        Flexible(
                          child: Text('hoy'),
                        ),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Icon(Icons.alarm, color: Colors.green),
                        Flexible(
                          child: Text('nosé'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Text(
                      'Nombre de la reserva',
                      style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      width: responsive.wp(90),
                      height: responsive.hp(5.5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: TextField(
                        cursorColor: Colors.transparent,
                        maxLines: 1,
                        decoration:
                            InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Ingresar nombre'),
                        enableInteractiveSelection: false,
                        controller: nombreReservaController,
                      ),
                    ),
                    Text(
                      'Teléfono de contacto',
                      style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      width: responsive.wp(90),
                      height: responsive.hp(5.5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: TextField(
                        cursorColor: Colors.transparent,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Ingresar número de teléfono'),
                        enableInteractiveSelection: false,
                        controller: telefonoController,
                      ),
                    ),
                    Text(
                      'Observaciones',
                      style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      width: responsive.wp(90),
                      height: responsive.hp(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: TextField(
                        cursorColor: Colors.transparent,
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: 'Observaciones'),
                        enableInteractiveSelection: false,
                        controller: observacionController,
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Row(children: <Widget>[
                      Container(
                        width: responsive.wp(45),
                        height: responsive.hp(15),
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                'Costo de la cancha',
                                style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                color: Colors.black,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'S/ 200000',
                                      style: TextStyle(fontSize: responsive.ip(3), color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: responsive.wp(5),
                      ),
                      Container(
                        width: responsive.wp(40),
                        height: responsive.hp(14),
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                'Monto a pagar',
                                style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: responsive.hp(2.5),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(2),
                              ),
                              width: responsive.wp(44),
                              height: responsive.hp(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                              ),
                              child: TextField(
                                cursorColor: Colors.transparent,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: '0.0'),
                                enableInteractiveSelection: false,
                                controller: montoPagarController,
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: responsive.wp(40),
                          child: MaterialButton(
                            onPressed: () async {},
                            color: Colors.green,
                            textColor: Colors.white,
                            child: Text('Reservar'),
                          ),
                        ),
                        SizedBox(
                          width: responsive.wp(10),
                        ),
                        SizedBox(
                          width: responsive.wp(40),
                          child: MaterialButton(
                            onPressed: () {
                              nombreReservaController.text = "";
                              montoPagarController.text = "";
                              Navigator.pop(context);
                            },
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text('Cancelar'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
