class PedidoCocinaModel {
  String idDetallePedido;
  String idPedido;
  String idMesa;
  String mesaNombre;
  String idGrupo;
  String grupoNombre;
  String numeroPedido;
  String delivery;
  String telefono;
  String totalPedido;
  String numeroPersonas;
  String estadoPedido;
  String idProducto;
  String nombre;
  String foto;
  String despacho;
  String observacion;
  String precioProducto;
  String cantidad;
  String fecha;
  String fechaEntrega;
  String estadoVenta;
  String estado;

  PedidoCocinaModel({
    this.idDetallePedido,
    this.idPedido,
    this.idMesa,
    this.mesaNombre,
    this.idGrupo,
    this.grupoNombre,
    this.numeroPedido,
    this.delivery,
    this.telefono,
    this.totalPedido,
    this.numeroPersonas,
    this.estadoPedido,
    this.idProducto,
    this.nombre,
    this.foto,
    this.despacho,
    this.observacion,
    this.precioProducto,
    this.cantidad,
    this.fecha,
    this.fechaEntrega,
    this.estadoVenta,
    this.estado,
  });

  factory PedidoCocinaModel.fromJson(Map<String, dynamic> json) => PedidoCocinaModel(
        idDetallePedido: json["idDetallePedido"],
        idPedido: json["idPedido"],
        idMesa: json["idMesa"],
        mesaNombre: json["mesaNombre"],
        idGrupo: json["idGrupo"],
        grupoNombre: json["grupoNombre"],
        numeroPedido: json["numeroPedido"],
        delivery: json["delivery"],
        telefono: json["telefono"],
        totalPedido: json["totalPedido"],
        numeroPersonas: json["numeroPersonas"],
        estadoPedido: json["estadoPedido"],
        idProducto: json["idProducto"],
        nombre: json["nombre"],
        foto: json["foto"],
        despacho: json["despacho"],
        observacion: json["observacion"],
        precioProducto: json["precioProducto"],
        cantidad: json["cantidad"],
        fecha: json["fecha"],
        fechaEntrega: json["fechaEntrega"],
        estadoVenta: json["estadoVenta"],
        estado: json["estado"],
      );
}
