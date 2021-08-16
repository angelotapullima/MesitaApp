import 'package:flutter/material.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/pages/CajeroPages/pedidos_cajero_page.dart';
import 'package:messita_app/src/pages/InfoUser/info_user.page.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';

class HomePageCaja extends StatefulWidget {
  @override
  _HomePageCajaState createState() => _HomePageCajaState();
}

class _HomePageCajaState extends State<HomePageCaja> {
  List<Widget> pageList = [];

  @override
  void initState() {
    pageList.add(PedidosCajaPage());
    pageList.add(InfoUserPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomBloc = ProviderBloc.bottomNavic(context);

    final responsive = Responsive.of(context);

    return Scaffold(
      body: StreamBuilder(
        stream: bottomBloc.selectPageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: responsive.hp(3)),
                child: IndexedStack(
                  index: bottomBloc.page,
                  children: pageList,
                ),
              ),
              Positioned(
                bottom: 2,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                  decoration: BoxDecoration(
                    color: ColorsApp.white,
                    borderRadius: BorderRadius.circular(20),
                    // borderRadius: BorderRadiusDirectional.only(
                    //   topStart: Radius.circular(20),
                    //   topEnd: Radius.circular(20),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedItemColor: ColorsApp.greenGrey,
                    unselectedItemColor: ColorsApp.orange,
                    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        label: 'Inicio',
                        icon: Icon(Icons.home),
                      ),
                      BottomNavigationBarItem(
                        label: 'Info',
                        icon: Icon(Icons.person),
                      ),
                    ],
                    currentIndex: bottomBloc.page,
                    onTap: (index) => {
                      bottomBloc.changePage(index),
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
