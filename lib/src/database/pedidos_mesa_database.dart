import 'package:messita_app/src/database/database_provider.dart';
import 'package:messita_app/src/model/detalle_pedido_mesa_model.dart';
import 'package:messita_app/src/model/pedidos_mesa_model.dart';

class PedidosDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarPedidoMesa(PedidoMesaModel pedido) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO PedidosMesa (idPedido,idMesa,numeroPedido,total,"
          "numeroPersonas,fecha,estado) "
          "VALUES ('${pedido.idPedido}','${pedido.idMesa}','${pedido.numeroPedido}','${pedido.total}','${pedido.numeroPersonas}','${pedido.fecha}','${pedido.estado}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  insertarDetallePedidoMesa(DetallePedidoMesaModel detallePedido) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO DetallePedidosMesa (idDetallePedido,idPedido,idProducto,despacho,observacion,precio,"
          "cantidad,total,fecha,fechaEntrega,estadoVenta,estado) "
          "VALUES ('${detallePedido.idDetallePedido}','${detallePedido.idPedido}','${detallePedido.idProducto}','${detallePedido.despacho}','${detallePedido.observacion}','${detallePedido.precio}','${detallePedido.cantidad}','${detallePedido.total}','${detallePedido.fecha}','${detallePedido.fechaEntrega}','${detallePedido.estadoVenta}','${detallePedido.estado}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<PedidoMesaModel>> obtenerPedidosMesa() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM PedidosMesa");

    List<PedidoMesaModel> list = res.isNotEmpty ? res.map((c) => PedidoMesaModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<PedidoMesaModel>> obtenerPedidosMesaPorIdMesa(String idMesa) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM PedidosMesa WHERE idMesa='$idMesa'");

    List<PedidoMesaModel> list = res.isNotEmpty ? res.map((c) => PedidoMesaModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<DetallePedidoMesaModel>> obtenerDetallePedidoMesaPorIdPedido(String idPedido) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM DetallePedidosMesa WHERE idPedido='$idPedido'");

    List<DetallePedidoMesaModel> list = res.isNotEmpty ? res.map((c) => DetallePedidoMesaModel.fromJson(c)).toList() : [];
    return list;
  }

  deletePedidosMesa() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM PedidosMesa');

    return res;
  }

  deleteDetallePedidoMesa() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM DetallePedidosMesa');

    return res;
  }
}
