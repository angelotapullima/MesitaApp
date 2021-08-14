import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:messita_app/src/database/pedidos_mesa_database.dart';
import 'package:messita_app/src/model/detalle_pedido_mesa_model.dart';
import 'package:messita_app/src/model/pedidos_mesa_model.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/utils/constants.dart';

class PedidosMesaApi {
  final preferences = Preferences();
  final pedidosDatabase = PedidosDatabase();

  Future<bool> obtenerPedidoXMesa(String idMesa) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Pedido/listar_pedidos_x_mesa');

      final resp = await http.post(url, body: {
        'tn': '${preferences.token}',
        'id': '$idMesa',
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);
      print(decodedData);

      if (decodedData['result']['code'] == 1) {
        if (decodedData['result']['datos'].length > 0) {
          PedidoMesaModel pedido = PedidoMesaModel();
          pedido.idPedido = decodedData['result']['datos']['id_comanda'];
          pedido.idMesa = '$idMesa';
          pedido.numeroPedido = decodedData['result']['datos'][0]['comanda_correlativo'];
          pedido.total = decodedData['result']['datos']['comanda_total'];
          pedido.fecha = decodedData['result']['datos']['datos_detalle_comanda'][0]['comanda_detalle_fecha_registro'];
          pedido.numeroPersonas = decodedData['result']['datos']['comanda_cantidad_personas'];
          pedido.estado = '1';

          await pedidosDatabase.insertarPedidoMesa(pedido);

          for (var i = 0; i < decodedData['result']['datos'].length; i++) {
            DetallePedidoMesaModel detallePedido = DetallePedidoMesaModel();
            detallePedido.idDetallePedido = decodedData['result']['datos'][i]['id_cd'];
            detallePedido.idPedido = decodedData['result']['datos'][i]['id_comanda'];
            detallePedido.idProducto = decodedData['result']['datos'][i]['nombre'];
            detallePedido.despacho = decodedData['result']['datos'][i]['precio'];
            detallePedido.observacion = decodedData['result']['datos'][i]['precio'];
            detallePedido.precio = decodedData['result']['datos'][i]['precio'];
            detallePedido.cantidad = decodedData['result']['datos'][i]['cantidad'];
            detallePedido.total = decodedData['result']['datos'][i]['total'];
            detallePedido.fecha = decodedData['result']['datos'][i]['fecha_hora'];
            detallePedido.fechaEntrega = decodedData['result']['datos'][i]['fecha_hora'];
            detallePedido.estadoVenta = decodedData['result']['datos'][i]['fecha_hora'];
            detallePedido.estado = '1';
            await pedidosDatabase.insertarDetallePedidoMesa(detallePedido);
          }
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Future<bool> guardarMesa(String nombreMesa, String capacidadMesa) async {
  //   try {
  //     final url = Uri.parse('$apiBaseURL/api/Mesa/guardar_nuevo_mesa');

  //     final resp = await http.post(url, body: {
  //       'tn': '${preferences.token}',
  //       'id_sucursal': '${preferences.idSucursal}',
  //       'mesa_nombre': '$nombreMesa',
  //       'mesa_capacidad': '$capacidadMesa',
  //       'app': 'true',
  //     });

  //     final decodedData = json.decode(resp.body);
  //     print(decodedData);

  //     if (decodedData['result']['code'] == 1) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<List<PedidoMesaModel>> listarPedidosPorMesa(String idMesa) async {
    final List<PedidoMesaModel> listaGeneral = [];

    final lisPedidosDatabase = await pedidosDatabase.obtenerPedidosMesaPorIdMesa(idMesa);

    for (var i = 0; i < lisPedidosDatabase.length; i++) {
      PedidoMesaModel pedido = PedidoMesaModel();
      pedido.idPedido = lisPedidosDatabase[i].idPedido;
      pedido.idMesa = lisPedidosDatabase[i].idMesa;
      pedido.numeroPedido = lisPedidosDatabase[i].numeroPedido;
      pedido.numeroPersonas = lisPedidosDatabase[i].numeroPersonas;
      pedido.fecha = lisPedidosDatabase[i].fecha;
      pedido.estado = lisPedidosDatabase[i].estado;

      final List<DetallePedidoMesaModel> listDetalle = [];
      double precioTotal = 0;
      final listDetalleDatabase = await pedidosDatabase.obtenerDetallePedidoMesaPorIdPedido(lisPedidosDatabase[i].idPedido);
      for (var x = 0; x < listDetalleDatabase.length; x++) {
        DetallePedidoMesaModel detalle = DetallePedidoMesaModel();
        detalle.idDetallePedido = listDetalleDatabase[x].idDetallePedido;
        detalle.idPedido = listDetalleDatabase[x].idPedido;
        detalle.nombre = listDetalleDatabase[x].nombre;
        detalle.precio = listDetalleDatabase[x].precio;
        detalle.cantidad = listDetalleDatabase[x].cantidad;
        detalle.total = listDetalleDatabase[x].total;
        detalle.fecha = listDetalleDatabase[x].fecha;
        detalle.estado = listDetalleDatabase[x].estado;

        precioTotal = precioTotal + double.parse(listDetalleDatabase[x].total);

        listDetalle.add(detalle);
      }
      pedido.total = precioTotal.toStringAsFixed(2);
      pedido.detalle = listDetalle;

      listaGeneral.add(pedido);
    }

    return listaGeneral;
  }
}
