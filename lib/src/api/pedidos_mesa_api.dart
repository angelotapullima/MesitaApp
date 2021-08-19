import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:messita_app/src/database/pedidos_mesa_database.dart';
import 'package:messita_app/src/database/pedidos_mesa_temporal_database.dart';
import 'package:messita_app/src/model/detalle_pedido_mesa_model.dart';
import 'package:messita_app/src/model/pedidos_mesa_model.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/utils/constants.dart';

class PedidosMesaApi {
  final preferences = Preferences();
  final pedidosDatabase = PedidosDatabase();
  final pedidosTemporalesDtabase = PedidosTemporalDatabase();

  Future<bool> obtenerPedidoXMesa(String idMesa) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Pedido/listar_pedidos_x_mesa_');

      final resp = await http.post(url, body: {
        'tn': '${preferences.token}',
        'id': '$idMesa',
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);

      if (decodedData['result']['code'] == 1) {
        PedidoMesaModel pedido = PedidoMesaModel();
        pedido.idPedido = decodedData['result']['datos']['id_comanda'];
        pedido.idMesa = '$idMesa';
        pedido.numeroPedido = decodedData['result']['datos']['comanda_correlativo'];
        pedido.total = decodedData['result']['datos']['comanda_total'];
        pedido.fecha = decodedData['result']['datos']['datos_detalle_comanda'][0]['comanda_detalle_fecha_registro'];
        pedido.numeroPersonas = decodedData['result']['datos']['comanda_cantidad_personas'];
        pedido.estado = '1';
        await pedidosDatabase.insertarPedidoMesa(pedido);

        for (var i = 0; i < decodedData['result']['datos']['datos_detalle_comanda'].length; i++) {
          DetallePedidoMesaModel detallePedido = DetallePedidoMesaModel();
          detallePedido.idDetallePedido = decodedData['result']['datos']['datos_detalle_comanda'][i]['id_comanda_detalle'];
          detallePedido.idPedido = decodedData['result']['datos']['id_comanda'];
          detallePedido.idProducto = decodedData['result']['datos']['datos_detalle_comanda'][i]['id_producto'];
          detallePedido.nombre = decodedData['result']['datos']['datos_detalle_comanda'][i]['producto_nombre'];
          detallePedido.foto = '$apiBaseURL/${decodedData['result']['datos']['datos_detalle_comanda'][i]['producto_foto']}';
          detallePedido.despacho = decodedData['result']['datos']['datos_detalle_comanda'][i]['comanda_detalle_despacho'];
          detallePedido.observacion = decodedData['result']['datos']['datos_detalle_comanda'][i]['comanda_detalle_observacion'];
          detallePedido.precio = decodedData['result']['datos']['datos_detalle_comanda'][i]['comanda_detalle_precio'];
          detallePedido.cantidad = decodedData['result']['datos']['datos_detalle_comanda'][i]['comanda_detalle_cantidad'];
          detallePedido.total = decodedData['result']['datos']['datos_detalle_comanda'][i]['comanda_detalle_total'];
          detallePedido.fecha = decodedData['result']['datos']['datos_detalle_comanda'][i]['comanda_detalle_fecha_registro'];
          detallePedido.fechaEntrega = '';
          detallePedido.estadoVenta = '1';
          detallePedido.estado = decodedData['result']['datos']['datos_detalle_comanda'][i]['comanda_detalle_estado'];
          await pedidosDatabase.insertarDetallePedidoMesa(detallePedido);
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> agregarProductoAPedido(DetallePedidoMesaModel producto) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Pedido/guardar_comanda_nuevo');

      final resp = await http.post(url, body: {
        'tn': '${preferences.token}',
        'id_comanda': '${producto.idPedido}',
        'id_producto': '${producto.idProducto}',
        'comanda_detalle_precio': '${producto.precio}',
        'comanda_detalle_cantidad': '${producto.cantidad}',
        'comanda_detalle_despacho': '${producto.despacho}',
        'comanda_detalle_total': '${producto.total}',
        'comanda_detalle_observacion': '${producto.observacion}',
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

  Future<bool> eliminarProductoAPedido(String password, String idPedidoDetalle, String idPedido, String idMesa) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Pedido/eliminar_comanda_detalle');

      print('$password, $idMesa, $idPedido, $idPedidoDetalle');

      final resp = await http.post(url, body: {
        'tn': '${preferences.token}',
        'password': '$password',
        'id_mesa': '$idMesa',
        'id_comanda': '$idPedido',
        'id_comanda_detalle': '$idPedidoDetalle',
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);
      print(decodedData);

      if (decodedData['result']['code'] == 1) {
        await pedidosDatabase.deleteDetallePedidoXIdDetalle(idPedidoDetalle);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> generarNuevoPedido(String idMesa, String personas) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Pedido/guardar_comanda');

      final listPedidos = await pedidosTemporalesDtabase.obtenerpedidoTemporalMesaPorIdMesa(idMesa);

      if (listPedidos.length > 0) {
        String contenido = '';
        double total = 0;

        for (var i = 0; i < listPedidos.length; i++) {
          contenido +=
              '${listPedidos[i].idProducto}-.-.${listPedidos[i].nombre}-.-.${listPedidos[i].precio}-.-.${listPedidos[i].cantidad}-.-.Salón-.-.${listPedidos[i].observacion}-.-.${listPedidos[i].total}/./.';
          total = total + double.parse(listPedidos[i].total);
        }

        print(contenido);
        print('Precio total $total');

        final resp = await http.post(url, body: {
          'tn': '${preferences.token}',
          'id_mesa': '$idMesa',
          'comanda_total': '${total.toString()}',
          'comanda_cantidad_personas': '$personas',
          'contenido': '$contenido',
          'app': 'true',
        });

        final decodedData = json.decode(resp.body);
        print(decodedData);

        if (decodedData['result']['code'] == 1) {
          await pedidosTemporalesDtabase.deletepedidoTemporalMesa(idMesa);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

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
        detalle.idProducto = listDetalleDatabase[x].idProducto;
        detalle.nombre = listDetalleDatabase[x].nombre;
        detalle.foto = listDetalleDatabase[x].foto;
        detalle.despacho = listDetalleDatabase[x].despacho;
        detalle.observacion = listDetalleDatabase[x].observacion;
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
