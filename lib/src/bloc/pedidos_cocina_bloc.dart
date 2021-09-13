import 'package:messita_app/src/api/pedidos_cocina_api.dart';
import 'package:messita_app/src/database/pedidos_cocina_database.dart';
import 'package:messita_app/src/model/pedidos_cocina_model.dart';
import 'package:rxdart/rxdart.dart';

class PedidosCocinaBloc {
  final pedidosCocinaApi = PedidosCocinaApi();
  final pedidosCocinaDatabase = PedidosCocinaDatabase();

  final _pedidosCocinaController = BehaviorSubject<List<PedidoCocinaModel>>();

  Stream<List<PedidoCocinaModel>> get pediddosCocinaStream => _pedidosCocinaController.stream;

  dispose() {
    _pedidosCocinaController?.close();
  }

  void obtenerPedidosMesa() async {
    _pedidosCocinaController.sink.add(await pedidosCocinaDatabase.obtenerPedidosCocina());
    await pedidosCocinaApi.obtenerPedidosCocina();
    _pedidosCocinaController.sink.add(await pedidosCocinaDatabase.obtenerPedidosCocina());
  }
}
