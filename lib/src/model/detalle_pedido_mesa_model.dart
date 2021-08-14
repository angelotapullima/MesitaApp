class DetallePedidoMesaModel {
  String idDetallePedido;
  String idPedido;
  String nombre;
  String idProducto;
  String foto;
  String precio;
  String cantidad;
  String total;
  String fecha;
  String estado;
  String estadoVenta;
  String despacho;
  String observacion;
  String fechaEntrega;

  DetallePedidoMesaModel(
      {this.idDetallePedido,
      this.idPedido,
      this.nombre,
      this.precio,
      this.cantidad,
      this.total,
      this.fecha,
      this.estado,
      this.idProducto,
      this.foto,
      this.observacion,
      this.despacho,
      this.estadoVenta,
      this.fechaEntrega});
  factory DetallePedidoMesaModel.fromJson(Map<String, dynamic> json) => DetallePedidoMesaModel(
        idDetallePedido: json["idDetallePedido"],
        idPedido: json["idPedido"],
        idProducto: json["idProducto"],
        nombre: json["nombre"],
        foto: json["foto"],
        despacho: json["despacho"],
        observacion: json["observacion"],
        precio: json["precio"],
        cantidad: json["cantidad"],
        total: json["total"],
        fecha: json["fecha"],
        fechaEntrega: json["fechaEntrega"],
        estadoVenta: json["estadoVenta"],
        estado: json["estado"],
      );
}
