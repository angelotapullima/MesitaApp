import 'package:messita_app/src/database/database_provider.dart';
import 'package:messita_app/src/model/productos_model.dart';

class ProductosDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarProducto(ProductosModel producto) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO Productos (idProducto,productoNombre,"
          "productoDescripcion,productoFoto,productoEstado,productoPrecioVenta,productoPrecioEstado) "
          "VALUES ('${producto.idProducto}','${producto.productoNombre}','${producto.productoDescripcion}','${producto.productoFoto}','${producto.productoEstado}','${producto.productoPrecioVenta}','${producto.productoPrecioEstado}')");

      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<ProductosModel>> obtenerProductos() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Productos");

    List<ProductosModel> list = res.isNotEmpty ? res.map((c) => ProductosModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ProductosModel>> obtenerProductosPorQuery(String query) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Productos WHERE productoNombre LIKE '%$query%' AND productoEstado='1' ");

    List<ProductosModel> list = res.isNotEmpty ? res.map((c) => ProductosModel.fromJson(c)).toList() : [];
    return list;
  }

  deleteProductos() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete('DELETE FROM Productos');

    return res;
  }
}
