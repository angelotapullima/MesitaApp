import 'package:flutter/material.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/utils/responsive.dart';

class CerrarSession extends StatelessWidget {
  const CerrarSession({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black.withOpacity(.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: responsive.wp(5),
          ),
          width: double.infinity,
          height: responsive.hp(30),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              SizedBox(
                height: responsive.hp(3),
              ),
              Container(
                height: responsive.hp(7.5),
                child: Image.asset(
                  'assets/img/log.png',
                ),
              ),
              Container(
                height: responsive.hp(11),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(2),
                    ),
                    child: Text(
                      'Estás seguro que desea Cerrar Sesión?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.green,
              ),
              Container(
                height: responsive.hp(5),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Preferences prefs = Preferences();

                        prefs.clearPreferences();

                        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                      },
                      child: Container(
                        width: responsive.wp(43),
                        child: Text(
                          'Aceptar',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
