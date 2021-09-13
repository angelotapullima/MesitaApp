import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database _database;
  static final DatabaseProvider db = DatabaseProvider._();

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'messitasv1.db');
    Future _onConfigure(Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }

    return await openDatabase(path, version: 1, onOpen: (db) {}, onConfigure: _onConfigure, onCreate: (Database db, int version) async {
      await db.execute(' CREATE TABLE Mesas('
          ' idMesa TEXT PRIMARY KEY,'
          ' idSucursal TEXT,'
          ' mesaNombre TEXT,'
          ' mesaCapacidad TEXT,'
          ' mesaEstado TEXT,'
          ' mesaEstadoAtencion TEXT'
          ')');

      await db.execute(' CREATE TABLE Productos('
          ' idProducto TEXT PRIMARY KEY,'
          ' productoNombre TEXT,'
          ' productoDescripcion TEXT,'
          ' productoFoto TEXT,'
          ' productoEstado TEXT,'
          ' productoPrecioVenta TEXT,'
          ' productoPrecioEstado TEXT'
          ')');

      await db.execute(' CREATE TABLE PedidosMesa('
          ' idPedido TEXT PRIMARY KEY,'
          ' idMesa TEXT,'
          ' numeroPedido TEXT,'
          ' total TEXT,'
          ' numeroPersonas TEXT,'
          ' fecha TEXT,'
          ' estado TEXT'
          ')');

      await db.execute(' CREATE TABLE DetallePedidosMesa('
          ' idDetallePedido TEXT PRIMARY KEY,'
          ' idPedido TEXT,'
          ' idProducto TEXT,'
          ' nombre TEXT,'
          ' foto TEXT,'
          ' despacho TEXT,'
          ' observacion TEXT,'
          ' precio TEXT,'
          ' cantidad TEXT,'
          ' total TEXT,'
          ' fecha TEXT,'
          ' fechaEntrega TEXT,'
          ' estadoVenta TEXT,'
          ' estado TEXT'
          ')');

      await db.execute(' CREATE TABLE PedidosMesaTemporal('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' idMesa TEXT,'
          ' idProducto TEXT,'
          ' nombre TEXT,'
          ' foto TEXT,'
          ' precio TEXT,'
          ' cantidad TEXT,'
          ' observacion TEXT,'
          ' total TEXT'
          ')');

      await db.execute(' CREATE TABLE PedidosCocina('
          ' idDetallePedido TEXT PRIMARY KEY,'
          ' idPedido TEXT,'
          ' idMesa TEXT,'
          ' mesaNombre TEXT,'
          ' idGrupo TEXT,'
          ' grupoNombre TEXT,'
          ' numeroPedido TEXT,'
          ' delivery TEXT,'
          ' telefono TEXT,'
          ' totalPedido TEXT,'
          ' numeroPersonas TEXT,'
          ' estadoPedido TEXT,'
          ' idProducto TEXT,'
          ' nombre TEXT,'
          ' foto TEXT,'
          ' despacho TEXT,'
          ' observacion TEXT,'
          ' precioProducto TEXT,'
          ' cantidad TEXT,'
          ' fecha TEXT,'
          ' fechaEntrega TEXT,'
          ' estadoVenta TEXT,'
          ' estado TEXT'
          ')');
    });
  }
}
