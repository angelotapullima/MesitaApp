import 'package:messita_app/src/api/mesas_negocio_api.dart';
import 'package:messita_app/src/database/mesas_negocio_database.dart';
import 'package:messita_app/src/model/mesas_negocio_model.dart';
import 'package:rxdart/rxdart.dart';

class MesasNegocioBloc {
  final mesasDatabase = MesasNegocioDatabase();
  final mesasApi = MesasNegocioApi();
  final _cuentaController = BehaviorSubject<List<MesasNegocioModel>>();

  Stream<List<MesasNegocioModel>> get mesasNegocioStream => _cuentaController.stream;

  dispose() {
    _cuentaController?.close();
  }

  void obtenerMesas() async {
    _cuentaController.sink.add(await mesasDatabase.obtenerMesas());
    await mesasApi.obtenerMesasPorSucursal();
    _cuentaController.sink.add(await mesasDatabase.obtenerMesas());
  }
}
