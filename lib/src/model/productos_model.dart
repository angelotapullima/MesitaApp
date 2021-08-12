class ProductosModel {
  String idProducto;
  String productoNombre;
  String productoDescripcion;
  String productoFoto;
  String productoEstado;
  String productoPrecioVenta;
  String productoPrecioEstado;

  ProductosModel({
    this.idProducto,
    this.productoNombre,
    this.productoDescripcion,
    this.productoFoto,
    this.productoEstado,
    this.productoPrecioVenta,
    this.productoPrecioEstado,
  });

  factory ProductosModel.fromJson(Map<String, dynamic> json) => ProductosModel(
        idProducto: json["idProducto"],
        productoNombre: json["productoNombre"],
        productoDescripcion: json["productoDescripcion"],
        productoFoto: json["productoFoto"],
        productoEstado: json["productoEstado"],
        productoPrecioVenta: json["productoPrecioVenta"],
        productoPrecioEstado: json["productoPrecioEstado"],
      );
}
