import 'package:messita_app/src/api/mesas_negocio_api.dart';
import 'package:messita_app/src/database/mesas_negocio_database.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:rxdart/rxdart.dart';

class MesasNegocioBloc {
  final mesasDatabase = MesasNegocioDatabase();
  final mesasApi = MesasNegocioApi();
  final _mesasController = BehaviorSubject<List<MesasNegocioModel>>();
  final _mesasPedidosController = BehaviorSubject<List<MesasNegocioModel>>();

  Stream<List<MesasNegocioModel>> get mesasNegocioStream => _mesasController.stream;
  Stream<List<MesasNegocioModel>> get mesasPedidosStream => _mesasPedidosController.stream;

  dispose() {
    _mesasController?.close();
    _mesasPedidosController?.close();
  }

  void obtenerMesas() async {
    _mesasController.sink.add(await mesasDatabase.obtenerMesas());
    await mesasApi.obtenerMesasPorSucursal();
    _mesasController.sink.add(await mesasDatabase.obtenerMesas());
  }

  void obtenerMesasPedidos() async {
    _mesasPedidosController.sink.add(await mesasDatabase.obtenerMesasPedidos());
    await mesasApi.obtenerMesasPorSucursal();
    _mesasPedidosController.sink.add(await mesasDatabase.obtenerMesasPedidos());
  }
}
