import 'package:messita_app/src/api/pedidos_mesa_api.dart';
import 'package:messita_app/src/database/pedidos_mesa_temporal_database.dart';
import 'package:messita_app/src/model/pedidos_mesa_model.dart';
import 'package:messita_app/src/model/pedidos_mesa_temporal_model.dart';
import 'package:rxdart/rxdart.dart';

class PedidosMesaBloc {
  final pedidosTemporalDatabase = PedidosTemporalDatabase();
  final pedidosApi = PedidosMesaApi();

  final _pedidosController = BehaviorSubject<List<PedidoMesaModel>>();
  final _pedidosTemporalesController = BehaviorSubject<List<PedidoMesaTemporalModel>>();
  final _productosBusquedaController = BehaviorSubject<List<PedidoMesaModel>>();

  Stream<List<PedidoMesaModel>> get pedidosMesaStream => _pedidosController.stream;
  Stream<List<PedidoMesaTemporalModel>> get pedidosTemporalesStream => _pedidosTemporalesController.stream;

  dispose() {
    _pedidosController?.close();
    _productosBusquedaController?.close();
    _pedidosTemporalesController?.close();
  }

  void obtenerPedidosPorMesa(String idMesa) async {
    _pedidosController.sink.add(await pedidosApi.listarPedidosPorMesa(idMesa));
    await pedidosApi.obtenerPedidoXMesa(idMesa);
    _pedidosController.sink.add(await pedidosApi.listarPedidosPorMesa(idMesa));
  }

  void obtenerPedidosTemporalesPorMesa(String idMesa) async {
    _pedidosTemporalesController.sink.add(await pedidosTemporalDatabase.obtenerpedidoTemporalMesaPorIdMesa(idMesa));
  }
}
