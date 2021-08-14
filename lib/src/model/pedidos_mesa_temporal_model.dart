class PedidoMesaTemporalModel {
  String id;
  String idMesa;
  String idProducto;
  String nombre;
  String precio;
  String cantidad;
  String observacion;
  String total;

  PedidoMesaTemporalModel({
    this.id,
    this.idMesa,
    this.idProducto,
    this.nombre,
    this.precio,
    this.cantidad,
    this.observacion,
    this.total,
  });
  factory PedidoMesaTemporalModel.fromJson(Map<String, dynamic> json) => PedidoMesaTemporalModel(
        id: json["id"],
        idMesa: json["idMesa"],
        idProducto: json["idProducto"],
        precio: json["precio"],
        cantidad: json["cantidad"],
        observacion: json["observacion"],
        total: json["total"],
      );
}
