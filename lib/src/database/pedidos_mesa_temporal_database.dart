import 'package:messita_app/src/database/database_provider.dart';
import 'package:messita_app/src/model/pedidos_mesa_temporal_model.dart';

class PedidosTemporalDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarPedidoTemporalMesa(PedidoMesaTemporalModel pedidoTemporal) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO PedidosMesaTemporal (idMesa,idProducto,nombre,foto,precio,"
          "cantidad,observacion,total) "
          "VALUES ('${pedidoTemporal.idMesa}','${pedidoTemporal.idProducto}','${pedidoTemporal.nombre}','${pedidoTemporal.foto}','${pedidoTemporal.precio}','${pedidoTemporal.cantidad}','${pedidoTemporal.observacion}','${pedidoTemporal.total}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<PedidoMesaTemporalModel>> obtenerpedidoTemporalMesaPorIdMesa(String idMesa) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM PedidosMesaTemporal WHERE idMesa='$idMesa'");

    List<PedidoMesaTemporalModel> list = res.isNotEmpty ? res.map((c) => PedidoMesaTemporalModel.fromJson(c)).toList() : [];
    return list;
  }

  deletepedidoTemporalMesa(String idMesa) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM PedidosMesaTemporal WHERE idMesa='$idMesa'");

    return res;
  }
}
