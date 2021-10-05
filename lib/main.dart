import 'package:flutter/material.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/pages/AdminPages/home_page.dart';
import 'package:messita_app/src/pages/CajeroPages/tab_bottoms_caja.dart';
import 'package:messita_app/src/pages/CocinaPages/tab_bottoms_cocina.dart';
import 'package:messita_app/src/pages/login_page.dart';
import 'package:messita_app/src/pages/splash.dart';
import 'package:messita_app/src/pages/MeseroPages/tab_bottoms_mozo.dart';
import 'package:messita_app/src/prefences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new Preferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/img/back.jpg'), context);
    return ProviderBloc(
      child: MaterialApp(
        title: 'Mesita App',
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: data.textScaleFactor > 2.0 ? 1.2 : data.textScaleFactor),
            child: child,
          );
        },
        initialRoute: 'splash',
        routes: {
          'splash': (BuildContext context) => Splash(),
          'homePage': (BuildContext context) => HomePage(),
          'login': (BuildContext context) => LoginPage(),
          'meseroPage': (BuildContext context) => HomePageMozo(),
          'cajeroPage': (BuildContext context) => HomePageCaja(),
          'cocinaPage': (BuildContext context) => HomePageCocina(),
        },
      ),
    );
  }
}
