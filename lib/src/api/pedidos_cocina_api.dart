import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:messita_app/src/database/pedidos_cocina_database.dart';
import 'package:messita_app/src/model/pedidos_cocina_model.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/utils/constants.dart';

class PedidosCocinaApi {
  final preferences = Preferences();
  final pedidosCocinaDatabase = PedidosCocinaDatabase();

  Future<bool> obtenerPedidosCocina() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Pedido/listar_pedidos_grupo_app');

      final resp = await http.post(url, body: {
        'tn': '${preferences.token}',
        'id': '1',
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);
      if (decodedData["result"]["code"] == 1) {
        for (var i = 0; i < decodedData["result"]["pedidos"].lenght; i++) {
          PedidoCocinaModel pedido = PedidoCocinaModel();

          pedido.idDetallePedido = decodedData["result"]["pedidos"][i]["id_comanda_detalle"];
          pedido.idPedido = decodedData["result"]["pedidos"][i]["id_comanda"];
          pedido.idMesa = decodedData["result"]["pedidos"][i]["id_mesa"];
          pedido.mesaNombre = decodedData["result"]["pedidos"][i]["mesa_nombre"];
          pedido.idGrupo = decodedData["result"]["pedidos"][i]["id_grupo"];
          pedido.grupoNombre = decodedData["result"]["pedidos"][i]["grupo_nombre"];
          pedido.numeroPedido = decodedData["result"]["pedidos"][i]["comanda_correlativo"];
          pedido.delivery = decodedData["result"]["pedidos"][i]["comanda_direccion_delivery"];
          pedido.telefono = decodedData["result"]["pedidos"][i]["comanda_telefono_delivery"];
          pedido.totalPedido = decodedData["result"]["pedidos"][i]["comanda_detalle_total"];
          pedido.numeroPersonas = decodedData["result"]["pedidos"][i]["comanda_cantidad_personas"];
          pedido.estadoPedido = decodedData["result"]["pedidos"][i]["comanda_estado"];
          pedido.idProducto = decodedData["result"]["pedidos"][i]["id_producto"];
          pedido.nombre = decodedData["result"]["pedidos"][i]["producto_nombre"];
          pedido.foto = decodedData["result"]["pedidos"][i]["producto_foto"];
          pedido.despacho = decodedData["result"]["pedidos"][i]["comanda_detalle_despacho"];
          pedido.observacion = decodedData["result"]["pedidos"][i]["comanda_detalle_observacion"];
          pedido.precioProducto = decodedData["result"]["pedidos"][i]["comanda_detalle_precio"];
          pedido.cantidad = decodedData["result"]["pedidos"][i]["comanda_detalle_cantidad"];
          pedido.fecha = decodedData["result"]["pedidos"][i]["comanda_detalle_fecha_registro"];
          pedido.fechaEntrega = decodedData["result"]["pedidos"][i]["comanda_detalle_hora_entrega"];
          pedido.estadoVenta = decodedData["result"]["pedidos"][i]["comanda_detalle_estado_venta"];
          pedido.estado = decodedData["result"]["pedidos"][i]["comanda_detalle_estado"];

          await pedidosCocinaDatabase.insertarPedidoCocina(pedido);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
