import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:messita_app/src/database/mesas_negocio_database.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/utils/constants.dart';

class MesasNegocioApi {
  final preferences = Preferences();
  final mesasDatabase = MesasNegocioDatabase();

  Future<bool> obtenerMesasPorSucursal() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Mesa/listar_mesas');

      final resp = await http.post(url, body: {
        'tn': '${preferences.token}',
        'id_sucursal': '${preferences.idSucursal}',
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);

      if (decodedData['result']['code'] == 1) {
        for (var i = 0; i < decodedData['result']['datos'].length; i++) {
          MesasNegocioModel mesa = MesasNegocioModel();
          mesa.idMesa = decodedData['result']['datos'][i]['id_mesa'];
          mesa.idSucursal = decodedData['result']['datos'][i]['id_sucursal'];
          mesa.mesaNombre = decodedData['result']['datos'][i]['mesa_nombre'];
          mesa.mesaCapacidad = decodedData['result']['datos'][i]['mesa_capacidad'];
          mesa.mesaEstado = decodedData['result']['datos'][i]['mesa_estado'];
          mesa.mesaEstadoAtencion = decodedData['result']['datos'][i]['mesa_estado_atencion'];
          await mesasDatabase.insertarMesa(mesa);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> guardarMesa(String nombreMesa, String capacidadMesa) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Mesa/guardar_nuevo_mesa');

      final resp = await http.post(url, body: {
        'tn': '${preferences.token}',
        'id_sucursal': '${preferences.idSucursal}',
        'mesa_nombre': '$nombreMesa',
        'mesa_capacidad': '$capacidadMesa',
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);
      print(decodedData);

      if (decodedData['result']['code'] == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
