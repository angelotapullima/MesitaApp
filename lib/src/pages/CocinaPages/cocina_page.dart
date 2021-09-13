import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';

class CocinaPage extends StatelessWidget {
  const CocinaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: ColorsApp.greenLemon,
      body: SafeArea(
          child: Stack(
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
                padding: EdgeInsets.only(left: responsive.wp(3), top: responsive.wp(1)),
                child: Text(
                  'Pedidos pendientes',
                  style: TextStyle(fontSize: responsive.ip(5), color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (_, index) {
                      return Container(
                        height: responsive.hp(18),
                        child: Stack(
                          children: [
                            Positioned(
                              top: responsive.hp(2),
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(1)),
                                height: responsive.hp(15),
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
                                        width: responsive.ip(7),
                                        height: responsive.ip(7),
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
                                            imageUrl: '',
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
                                      Container(
                                        width: responsive.wp(50),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Bisteck al carbón',
                                                style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.greenGrey, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                'Observaciones para poder especificar el tamaño que tendrá este campo en caso haya observaciones',
                                                textAlign: TextAlign.justify,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Center(
                                        child: Row(
                                          children: [
                                            Text(
                                              '3',
                                              style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.black, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'x',
                                              style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.black),
                                            ),
                                            Text(
                                              ' S/23.00',
                                              style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.black, fontWeight: FontWeight.bold),
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorsApp.redOrange),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(3), vertical: responsive.hp(1)),
                                    child: Text(
                                      'Mesa ${index + 1}',
                                      style: TextStyle(fontSize: responsive.ip(2.2), color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: responsive.hp(5),
              )
            ],
          ),
        ],
      )),
    );
  }
}
