import 'package:messita_app/src/database/database_provider.dart';
import 'package:messita_app/src/model/pedidos_cocina_model.dart';

class PedidosCocinaDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarPedidoCocina(PedidoCocinaModel pedido) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO PedidosCocina (idDetallePedido,idPedido,idMesa,mesaNombre,idGrupo,grupoNombre,"
          "numeroPedido,delivery,telefono,totalPedido,numeroPersonas,estadoPedido,idProducto,nombre,foto,despacho,observacion,precioProducto,cantidad,fecha,fechaEntrega,estadoVenta,estado) "
          "VALUES ('${pedido.idDetallePedido}','${pedido.idPedido}','${pedido.idMesa}','${pedido.mesaNombre}','${pedido.idGrupo}','${pedido.grupoNombre}','${pedido.numeroPedido}','${pedido.delivery}','${pedido.delivery}',"
          "'${pedido.totalPedido}','${pedido.numeroPersonas}','${pedido.estadoPedido}','${pedido.idProducto}','${pedido.nombre}','${pedido.foto}','${pedido.despacho}','${pedido.observacion}','${pedido.precioProducto}',"
          "'${pedido.cantidad}','${pedido.fecha}','${pedido.fechaEntrega}','${pedido.estadoVenta}','${pedido.estado}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<PedidoCocinaModel>> obtenerPedidosCocina() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM PedidosCocina WHERE idGrupo='1' AND estado='1'");

    List<PedidoCocinaModel> list = res.isNotEmpty ? res.map((c) => PedidoCocinaModel.fromJson(c)).toList() : [];
    return list;
  }

  deletePedidosCocina() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM PedidosCocina');

    return res;
  }
}
