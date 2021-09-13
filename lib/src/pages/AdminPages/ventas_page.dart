import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/widget/drawer_menu_widget.dart';

class VentasPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const VentasPage({Key key, @required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: ColorsApp.pinkLight,
      appBar: AppBar(
        backgroundColor: ColorsApp.pinkLight,
        actions: [],
        elevation: 0,
        leading: DrawerMenuWidget(
          onClick: openDrawer,
          color: Colors.black,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: responsive.hp(40),
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
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
                    'Ventas',
                    style: TextStyle(fontSize: responsive.ip(5), color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: responsive.hp(2), left: responsive.wp(3), right: responsive.wp(3)),
                    child: Column(
                      children: [
                        //BarChart(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
