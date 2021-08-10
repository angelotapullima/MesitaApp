import 'package:flutter/material.dart';
import 'package:messita_app/src/pages/AdminPages/mesas_page.dart';
import 'package:messita_app/src/pages/AdminPages/productos_page.dart';
import 'package:messita_app/src/widget/draw_items_widget.dart';
import 'package:messita_app/src/widget/drawer_admin.dart';

import 'pedidos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double xoffset;
  double yoffset;
  double scalable;
  bool isOpenDrawing;
  DrawerItem item = DrawerItems.pedidos;

  bool isDrawing = false;
  @override
  void initState() {
    super.initState();
    openDrawer();
  }

  void openDrawer() => setState(() {
        xoffset = 230;
        yoffset = 150;
        scalable = 0.6;
        isOpenDrawing = true;
      });
  void closeDrawer() => setState(() {
        xoffset = 0;
        yoffset = 0;
        scalable = 1;
        isOpenDrawing = false;
      });

  @override
  Widget build(BuildContext context) {
    print('value open : $isOpenDrawing');
    return Scaffold(
        body: Stack(
      children: [
        _fondo(),
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        crearDrawer(),
        mostrarPagina()
      ],
    ));
  }

  Widget crearDrawer() => DrawerAdmin(
        onselectItem: (item) {
          setState(() {
            this.item = item;
            closeDrawer();
          });
        },
        itemSelect: this.item.titulo,
      );

  Widget mostrarPagina() {
    return WillPopScope(
      onWillPop: () async {
        if (isOpenDrawing) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
          onTap: closeDrawer,
          onHorizontalDragStart: (detail) => isDrawing = true,
          onHorizontalDragUpdate: (detail) {
            if (!isDrawing) return;
            const delta = 1;
            if (detail.delta.dx > delta) {
              openDrawer();
            } else if (detail.delta.dx < -delta) {
              closeDrawer();
            }
            isDrawing = false;
          },
          child: AnimatedContainer(
              transform: Matrix4.translationValues(xoffset, yoffset, 0)
                ..scale(scalable)
                ..rotateY(isOpenDrawing ? 0.5 : 0.0),
              duration: Duration(milliseconds: 250),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isOpenDrawing ? 20 : 0.0),
                child: AbsorbPointer(
                  absorbing: isOpenDrawing,
                  child: obtenerPagina(),
                ),
              ))),
    );
  }

  Widget obtenerPagina() {
    switch (item) {
      case DrawerItems.productos:
        return ProductosPage(
          openDrawer: openDrawer,
        );
      case DrawerItems.pedidos:
        return PedidosPage(
          openDrawer: openDrawer,
        );
      case DrawerItems.mesas:
        return MesasPage(
          openDrawer: openDrawer,
        );
      default:
        return PedidosPage(
          openDrawer: openDrawer,
        );
    }
  }

  Widget _fondo() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset('assets/img/back.jpg', fit: BoxFit.cover),
    );
  }
}
