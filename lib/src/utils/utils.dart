import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void showToast2(String texto, Color color) {
  Fluttertoast.showToast(msg: "$texto", toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3, backgroundColor: color, textColor: Colors.white);
}

obtenerFecha(String date) {
  var fecha = DateTime.parse(date);

  final DateFormat fech = new DateFormat('dd MMM yyyy', 'es');

  return fech.format(fecha);
}

obtenerHora(String date) {
  var fecha = DateTime.parse(date);

  //final DateFormat fech = new DateFormat('Hms', 'es');

  String valor = DateFormat.jms().format(fecha);

  return valor;
}

Widget mostrarAlert() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    color: Color.fromRGBO(0, 0, 0, 0.2),
    child: Center(
      child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
    ),
  );
}
