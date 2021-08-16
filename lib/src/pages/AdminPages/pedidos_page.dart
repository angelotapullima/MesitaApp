import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/utils/utils.dart';
import 'package:messita_app/src/widget/drawer_menu_widget.dart';
import 'package:messita_app/src/widget/widgets.dart';

class PedidosPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const PedidosPage({Key key, @required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final mesasBloc = ProviderBloc.mesas(context);
    mesasBloc.obtenerMesasPedidos();
    return Scaffold(
      backgroundColor: ColorsApp.greenGrey,
      appBar: AppBar(
        backgroundColor: ColorsApp.greenGrey,
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
                            return mesaItem(context, responsive, mesas.data[index]);
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
}
