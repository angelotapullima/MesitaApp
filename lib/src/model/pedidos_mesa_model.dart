import 'package:messita_app/src/model/detalle_pedido_mesa_model.dart';

class PedidoMesaModel {
  String idPedido;
  String idMesa;
  String numeroPedido;
  String total;
  String numeroPersonas;
  String fecha;
  String estado;
  List<DetallePedidoMesaModel> detalle;

  PedidoMesaModel({
    this.idPedido,
    this.idMesa,
    this.numeroPedido,
    this.total,
    this.numeroPersonas,
    this.fecha,
    this.estado,
    this.detalle,
  });
  factory PedidoMesaModel.fromJson(Map<String, dynamic> json) => PedidoMesaModel(
        idPedido: json["idPedido"],
        idMesa: json["idMesa"],
        numeroPedido: json["numeroPedido"],
        total: json["total"],
        numeroPersonas: json["numeroPersonas"],
        fecha: json["fecha"],
        estado: json["estado"],
      );
}
