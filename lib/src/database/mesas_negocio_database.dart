import 'package:messita_app/src/database/database_provider.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';

class MesasNegocioDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarMesa(MesasNegocioModel mesa) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO Mesas (idMesa,idSucursal,mesaNombre,"
          "mesaCapacidad,mesaEstado,mesaEstadoAtencion) "
          "VALUES ('${mesa.idMesa}','${mesa.idSucursal}','${mesa.mesaNombre}','${mesa.mesaCapacidad}','${mesa.mesaEstado}','${mesa.mesaEstadoAtencion}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<MesasNegocioModel>> obtenerMesas() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Mesas");

    List<MesasNegocioModel> list = res.isNotEmpty ? res.map((c) => MesasNegocioModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<MesasNegocioModel>> obtenerMesasPedidos() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Mesas WHERE mesaEstado=='1'");

    List<MesasNegocioModel> list = res.isNotEmpty ? res.map((c) => MesasNegocioModel.fromJson(c)).toList() : [];
    return list;
  }

  deleteMesas() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM Mesas');

    return res;
  }
}
