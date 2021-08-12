import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;
import 'package:messita_app/src/database/productos_database.dart';
import 'package:messita_app/src/model/productos_model.dart';
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/utils/constants.dart';

class ProductosApi {
  final preferences = Preferences();
  final productosDatabase = ProductosDatabase();

  Future<bool> obtenerProductos() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Producto/listar_productos');

      final resp = await http.post(url, body: {
        'tn': '${preferences.token}',
        'app': 'true',
      });
      final decodedData = json.decode(resp.body);

      if (decodedData['result']['code'] == 1) {
        for (var i = 0; i < decodedData['result']['productos'].length; i++) {
          ProductosModel producto = ProductosModel();
          producto.idProducto = decodedData['result']['productos'][i]['id_producto'];
          producto.productoNombre = decodedData['result']['productos'][i]['producto_nombre'];
          producto.productoDescripcion = decodedData['result']['productos'][i]['producto_descripcion'];
          producto.productoFoto = '$apiBaseURL/${decodedData['result']['productos'][i]['producto_foto']}';
          producto.productoEstado = decodedData['result']['productos'][i]['producto_estado'];
          producto.productoPrecioVenta = decodedData['result']['productos'][i]['producto_precio_venta'];
          producto.productoPrecioEstado = decodedData['result']['productos'][i]['producto_precio_estado'];
          await productosDatabase.insertarProducto(producto);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> guardarProducto(File _image, String nombreproducto, String precioProducto, String descripcionProducto) async {
    try {
      final uri = Uri.parse('$apiBaseURL/api/Producto/guardar_producto');
      bool resp = false;

      var multipartFile;

      if (_image != null) {
        var stream = new http.ByteStream(Stream.castFrom(_image.openRead()));
        var length = await _image.length();
        multipartFile = new http.MultipartFile('equipo_imagen', stream, length, filename: basename(_image.path));
      }

      var request = new http.MultipartRequest("POST", uri);

      request.fields["tn"] = preferences.token;
      request.fields["app"] = 'true';
      request.fields["producto_nombre"] = '$nombreproducto';
      request.fields["producto_descripcion"] = '$descripcionProducto';
      request.fields["producto_precio_venta"] = '$precioProducto';

      if (_image != null) {
        request.files.add(multipartFile);
      }

      await request.send().then((response) async {
        // listen for response
        response.stream.transform(utf8.decoder).listen((value) {
          final decodedData = json.decode(value);
          print(decodedData);
          if (decodedData['result']['code'] == 1) {
            resp = true;
          } else {
            resp = false;
          }
        });
      }).catchError((e) {
        print(e);
        return false;
      });

      return resp;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }
}
