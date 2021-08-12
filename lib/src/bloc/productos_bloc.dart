import 'package:messita_app/src/api/productos_api.dart';
import 'package:messita_app/src/database/productos_database.dart';
import 'package:messita_app/src/model/productos_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final productosDatabase = ProductosDatabase();
  final productosApi = ProductosApi();
  final _productosController = BehaviorSubject<List<ProductosModel>>();

  Stream<List<ProductosModel>> get productosStream => _productosController.stream;

  dispose() {
    _productosController?.close();
  }

  void obtenerProductos() async {
    _productosController.sink.add(await productosDatabase.obtenerProductos());
    await productosApi.obtenerProductos();
    _productosController.sink.add(await productosDatabase.obtenerProductos());
  }
}
