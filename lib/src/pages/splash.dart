import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/prefences/preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  @override
  void afterFirstLayout(BuildContext context) async {}

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final preferences = Preferences();

      if (preferences.idUser.toString().isEmpty || preferences.idUser == null || preferences.idUser == '0') {
        Navigator.pushReplacementNamed(context, 'login');
      } else {
        final bottomBloc = ProviderBloc.bottomNavic(context);
        bottomBloc.changePage(0);
        Navigator.pushReplacementNamed(context, preferences.pageInit);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            //color: Colors.deepPurple,
            child: Image.asset('assets/img/back.jpg', fit: BoxFit.cover),
            //child: Image(image: AssetImage('assets/img/pasto2.webp'), fit: BoxFit.cover, gaplessPlayback: true),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(.6),
          ),
          Center(
            child: Container(
              child: Image.asset(
                'assets/img/log.png',
              ),
              // Image.asset(
              //   'assets/img/BUFI_AGENTE.png',
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
