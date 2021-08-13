import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:messita_app/src/api/mesas_negocio_api.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/utils/utils.dart';
import 'package:messita_app/src/widget/drawer_menu_widget.dart';

class MesasPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const MesasPage({Key key, @required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final mesasBloc = ProviderBloc.mesas(context);
    mesasBloc.obtenerMesas();
    return Scaffold(
      backgroundColor: ColorsApp.orange,
      appBar: AppBar(
        backgroundColor: ColorsApp.orange,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: responsive.wp(1), top: responsive.hp(1)),
            child: AgregarMesa(),
          ),
        ],
        elevation: 0,
        leading: DrawerMenuWidget(
          onClick: openDrawer,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: mesasBloc.mesasNegocioStream,
        builder: (context, AsyncSnapshot<List<MesasNegocioModel>> mesas) {
          if (mesas.hasData) {
            if (mesas.data.length > 0) {
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
                          'Mis mesas',
                          style: TextStyle(fontSize: responsive.ip(5), color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: mesas.data.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.9,
                          ),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return _mesaItem(context, responsive, mesas.data[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('Sin Mesas agregadas'),
              );
            }
          } else {
            return mostrarAlert();
          }
        },
      ),
    );
  }

  Widget _mesaItem(BuildContext context, Responsive responsive, MesasNegocioModel mesa) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Stack(
        children: [
          Positioned(
            top: 40,
            left: 3,
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
                color: ColorsApp.greenWhite,
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
                            style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.greenGrey, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${mesa.mesaCapacidad}',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.greenGrey, fontWeight: FontWeight.bold),
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
    );
  }
}

class AgregarMesa extends StatefulWidget {
  const AgregarMesa({Key key}) : super(key: key);

  @override
  _AgregarMesaState createState() => _AgregarMesaState();
}

class _AgregarMesaState extends State<AgregarMesa> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  TextEditingController _nombreMesaController = TextEditingController();
  TextEditingController _capacidadMesaController = TextEditingController();

  FocusNode _focusNombreMesa = FocusNode();
  FocusNode _focusCapacidadMesa = FocusNode();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return InkWell(
      onTap: () {
        modalAgregarMesa(context);
      },
      child: Container(
        width: responsive.ip(4),
        height: responsive.ip(4),
        child: CircleAvatar(
          backgroundColor: ColorsApp.greenGrey,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void modalAgregarMesa(BuildContext context) {
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
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: KeyboardActions(
                    config: KeyboardActionsConfig(keyboardSeparatorColor: Colors.white, keyboardBarColor: Colors.white, actions: [
                      KeyboardActionsItem(focusNode: _focusNombreMesa),
                      KeyboardActionsItem(focusNode: _focusCapacidadMesa),
                    ]),
                    child: Container(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      margin: EdgeInsets.only(top: responsive.hp(20)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20),
                          topStart: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(
                                  responsive.ip(1),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.only(
                                      topEnd: Radius.circular(20),
                                      topStart: Radius.circular(20),
                                    ),
                                    color: ColorsApp.greenGrey),
                                child: Center(
                                  child: Text(
                                    'Agregar Nueva Mesa',
                                    style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: responsive.hp(2),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(3),
                                ),
                                child: Text(
                                  'Nombre de la Mesa',
                                  style: TextStyle(color: ColorsApp.greenGrey, fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: responsive.hp(.5),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(3),
                                ),
                                child: _nombreMesa(responsive),
                              ),
                              SizedBox(
                                height: responsive.hp(2),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(3),
                                ),
                                child: Text(
                                  'Capacidad',
                                  style: TextStyle(color: ColorsApp.greenGrey, fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: responsive.hp(.5),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(3),
                                ),
                                child: _capacidadMesa(responsive),
                              ),
                              SizedBox(
                                height: responsive.hp(3.5),
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      _cargando.value = true;
                                      if (_nombreMesaController.text.length > 0) {
                                        if (_capacidadMesaController.text.length > 0) {
                                          final mesaApi = MesasNegocioApi();

                                          final res = await mesaApi.guardarMesa(_nombreMesaController.text, _capacidadMesaController.text);

                                          if (res) {
                                            _nombreMesaController.text = '';
                                            _capacidadMesaController.text = '';
                                            Navigator.pop(context);
                                            showToast2('Mesa agregada correctamente', ColorsApp.greenLight);
                                            final mesasBloc = ProviderBloc.mesas(context);
                                            mesasBloc.obtenerMesas();
                                          } else {
                                            _nombreMesaController.text = '';
                                            _capacidadMesaController.text = '';
                                            Navigator.pop(context);
                                            showToast2('¡Ocurrió un error!', Colors.red);
                                          }
                                        } else {
                                          showToast2('Por favor ingrese la capacidad de la mesa', Colors.black);
                                        }
                                      } else {
                                        showToast2('Por favor ingrese el nombre de la mesa', Colors.black);
                                      }

                                      _cargando.value = false;
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(1),
                                        vertical: responsive.hp(.5),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: ColorsApp.greenGrey,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: responsive.wp(3),
                                          ),
                                          Text(
                                            'Agregar',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: responsive.wp(3),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: responsive.hp(5),
                              ),
                            ],
                          ),
                        ),
                      ),
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
          },
        );
      },
    );
  }

  Widget _nombreMesa(Responsive responsive) {
    return TextField(
      focusNode: _focusNombreMesa,
      cursorColor: Colors.transparent,
      keyboardType: TextInputType.text,
      maxLines: 1,

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
          hintText: 'Nombre de la Chancha'),
      enableInteractiveSelection: false,
      controller: _nombreMesaController,
      //controller: montoPagarontroller,
    );
  }

  Widget _capacidadMesa(Responsive responsive) {
    return TextField(
      focusNode: _focusCapacidadMesa,
      cursorColor: Colors.transparent,
      keyboardType: TextInputType.number,
      maxLines: 1,

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
          hintText: 'Capacidad'),
      enableInteractiveSelection: false,
      controller: _capacidadMesaController,
      //controller: montoPagarontroller,
    );
  }
}
