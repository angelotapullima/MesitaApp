import 'package:messita_app/src/api/productos_api.dart';
import 'package:messita_app/src/database/productos_database.dart';
import 'package:messita_app/src/model/productos_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final productosDatabase = ProductosDatabase();
  final productosApi = ProductosApi();
  final _productosController = BehaviorSubject<List<ProductosModel>>();
  final _productosBusquedaController = BehaviorSubject<List<ProductosModel>>();

  Stream<List<ProductosModel>> get productosStream => _productosController.stream;
  Stream<List<ProductosModel>> get productosBusquedaStream => _productosBusquedaController.stream;

  dispose() {
    _productosController?.close();
    _productosBusquedaController?.close();
  }

  void obtenerProductos() async {
    _productosController.sink.add(await productosDatabase.obtenerProductos());
    await productosApi.obtenerProductos();
    _productosController.sink.add(await productosDatabase.obtenerProductos());
  }

  void obtenerProductosPorQuery(String query) async {
    _productosBusquedaController.sink.add([]);
    if (query != '') {
      _productosBusquedaController.sink.add(await productosDatabase.obtenerProductosPorQuery(query));
      await productosApi.obtenerProductos();
      _productosBusquedaController.sink.add(await productosDatabase.obtenerProductosPorQuery(query));
    }
  }
}
