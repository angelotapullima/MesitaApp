class MesasNegocioModel {
  String idMesa;
  String idSucursal;
  String mesaNombre;
  String mesaCapacidad;
  String mesaEstado;
  String mesaEstadoAtencion;

  MesasNegocioModel({this.idMesa, this.idSucursal, this.mesaNombre, this.mesaCapacidad, this.mesaEstado, this.mesaEstadoAtencion});

  factory MesasNegocioModel.fromJson(Map<String, dynamic> json) => MesasNegocioModel(
        idMesa: json["idMesa"],
        idSucursal: json["idSucursal"],
        mesaNombre: json["mesaNombre"],
        mesaCapacidad: json["mesaCapacidad"],
        mesaEstado: json["mesaEstado"],
        mesaEstadoAtencion: json["mesaEstadoAtencion"],
      );
}
