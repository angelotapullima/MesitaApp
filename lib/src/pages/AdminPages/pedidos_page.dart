import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:messita_app/src/pages/AdminPages/Pedidos/pedido_detalle_page.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/utils/utils.dart';
import 'package:messita_app/src/widget/drawer_menu_widget.dart';

class PedidosPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const PedidosPage({Key key, @required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final mesasBloc = ProviderBloc.mesas(context);
    mesasBloc.obtenerMesasPedidos();
    return Scaffold(
      backgroundColor: ColorsApp.redOrange,
      appBar: AppBar(
        backgroundColor: ColorsApp.redOrange,
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right: responsive.wp(1), top: responsive.hp(1)),
          //   child: AgregarMesa(),
          // ),
        ],
        elevation: 0,
        leading: DrawerMenuWidget(
          onClick: openDrawer,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: mesasBloc.mesasPedidosStream,
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
                          'Pedidos',
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) {
              return PedidosDetallePage(
                mesa: mesa,
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
      child: Padding(
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
                  color: ColorsApp.greenLemon,
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
      ),
    );
  }
}
