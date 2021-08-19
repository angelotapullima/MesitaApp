import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/api/pedidos_mesa_api.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/utils/utils.dart';

class ConfirmarEliminarDetallePedido extends StatefulWidget {
  final String idMesa;
  final String idPedido;
  final String idDetallePedido;
  const ConfirmarEliminarDetallePedido({Key key, @required this.idMesa, @required this.idPedido, @required this.idDetallePedido}) : super(key: key);

  @override
  _ConfirmarEliminarDetallePedidoState createState() => _ConfirmarEliminarDetallePedidoState();
}

class _ConfirmarEliminarDetallePedidoState extends State<ConfirmarEliminarDetallePedido> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black.withOpacity(.5),
      child: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool data, Widget child) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    width: double.infinity,
                    height: responsive.hp(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: ColorsApp.white.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(1, 3), // changes position of shadow
                        ),
                        BoxShadow(
                          color: ColorsApp.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(1, 3), // changes position of shadow
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: responsive.hp(3),
                        ),
                        Container(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: responsive.wp(2), vertical: responsive.hp(2)),
                              child: Text(
                                'Eliminar detalle del pedido',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: responsive.wp(3), vertical: responsive.hp(2)),
                          child: _pass(responsive),
                        ),
                        Spacer(),
                        Divider(
                          color: Colors.green,
                        ),
                        Container(
                          height: responsive.hp(5),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  _cargando.value = true;

                                  if (_passController.text != '') {
                                    final pedidoApi = PedidosMesaApi();
                                    final res = await pedidoApi.eliminarProductoAPedido(
                                        _passController.text, widget.idDetallePedido, widget.idPedido, widget.idMesa);

                                    if (res) {
                                      final pedidosBloc = ProviderBloc.pedidos(context);
                                      pedidosBloc.obtenerPedidosPorMesa(widget.idMesa);
                                      showToast2('Hecho!!', ColorsApp.greenGrey);
                                      Navigator.pop(context);
                                    } else {
                                      showToast2('Ocurrió un error', Colors.redAccent);
                                    }
                                  } else {
                                    showToast2('Debe ingresar contraseña para eliminar', Colors.redAccent);
                                  }

                                  _cargando.value = false;
                                },
                                child: Container(
                                  width: responsive.wp(43),
                                  child: Text(
                                    'Eliminar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.8),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: responsive.wp(.2),
                                color: Colors.green,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: responsive.wp(43),
                                  child: Text(
                                    'Cancelar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        )
                      ],
                    ),
                  ),
                ),
                (data)
                    ? Center(
                        child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  Widget _pass(Responsive responsive) {
    return TextField(
      cursorColor: Colors.transparent,
      keyboardType: TextInputType.text,
      maxLines: 1,
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: responsive.hp(1),
            horizontal: responsive.wp(4),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Ingrese su contraseña'),
      enableInteractiveSelection: false,
      controller: _passController,
      //controller: montoPagarontroller,
    );
  }
}
