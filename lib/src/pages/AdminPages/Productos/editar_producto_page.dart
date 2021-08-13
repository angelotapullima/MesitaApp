import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:messita_app/src/api/productos_api.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/model/productos_model.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/utils/utils.dart';

class EditarProductoPage extends StatefulWidget {
  final ProductosModel producto;
  const EditarProductoPage({Key key, @required this.producto}) : super(key: key);

  @override
  _EditarProductoPageState createState() => _EditarProductoPageState();
}

class _EditarProductoPageState extends State<EditarProductoPage> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  TextEditingController _nombreProductoController = TextEditingController();
  TextEditingController _precioProductoController = TextEditingController();
  TextEditingController _descripcionProductoController = TextEditingController();

  FocusNode _focusNombre = FocusNode();
  FocusNode _focusPrecio = FocusNode();
  FocusNode _focusDescripcion = FocusNode();

  File _image;
  final picker = ImagePicker();

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      setState(
        () {
          _cropImage(pickedFile.path);
        },
      );
    }
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    }
    /**/
  }

  Future<Null> _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        //aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cortar Imagen',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            showCropGrid: true,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0, title: 'Cortar Imagen'));
    if (croppedImage != null) {
      setState(() {
        _image = croppedImage;
      });
    }
  }

  @override
  void initState() {
    _nombreProductoController.text = widget.producto.productoNombre;
    _precioProductoController.text = widget.producto.productoPrecioVenta;
    _descripcionProductoController.text = widget.producto.productoDescripcion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black.withOpacity(.4),
      child: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool data, Widget child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: KeyboardActions(
                config: KeyboardActionsConfig(keyboardSeparatorColor: Colors.white, keyboardBarColor: Colors.white, actions: [
                  KeyboardActionsItem(focusNode: _focusNombre),
                  KeyboardActionsItem(focusNode: _focusPrecio),
                  KeyboardActionsItem(focusNode: _focusDescripcion),
                ]),
                child: Container(
                  padding: MediaQuery.of(context).viewInsets,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: responsive.hp(.5), horizontal: responsive.wp(3)),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: responsive.ip(2.5),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: responsive.hp(74),
                              margin: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(3)),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(45), color: Colors.white),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: -40,
                                    top: 40,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: ColorsApp.pinkLight,
                                    ),
                                  ),
                                  Positioned(
                                    right: -51,
                                    top: 300,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: ColorsApp.greenLight,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: responsive.hp(2.5)),
                                        child: Center(
                                          child: Text('Editar Producto', style: TextStyle(fontSize: responsive.ip(2.5), color: ColorsApp.greenGrey)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(3),
                                        ),
                                        child: _mostrarFoto(responsive),
                                      ),
                                      SizedBox(
                                        height: responsive.hp(1),
                                      ),
                                      Container(
                                        height: responsive.hp(10),
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text('Cambiar Foto'),
                                            InkWell(
                                              onTap: () {
                                                getImageCamera();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical: responsive.hp(1),
                                                ),
                                                width: responsive.ip(4.5),
                                                height: responsive.ip(4.5),
                                                child: Image(
                                                  image: AssetImage('assets/img/camera.png'),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  getImageGallery();
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                                                  width: responsive.ip(4.5),
                                                  height: responsive.ip(4.5),
                                                  child: Image(
                                                    image: AssetImage('assets/img/gallery.png'),
                                                  ), //Image.asset('assets/logo_largo.svg'),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                            ),
                                            child: Text(
                                              'Nombre del Producto',
                                              style: TextStyle(color: ColorsApp.greenGrey, fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: responsive.hp(.5),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                            ),
                                            child: _nombre(responsive),
                                          ),
                                          SizedBox(
                                            height: responsive.hp(1),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                            ),
                                            child: Text(
                                              'Precio del Producto',
                                              style: TextStyle(color: ColorsApp.greenGrey, fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: responsive.hp(.5),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                            ),
                                            child: _precio(responsive),
                                          ),
                                          SizedBox(
                                            height: responsive.hp(1),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                            ),
                                            child: Text(
                                              'Descripción',
                                              style: TextStyle(color: ColorsApp.greenGrey, fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: responsive.hp(.5),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                            ),
                                            child: _descripcion(responsive),
                                          ),
                                          SizedBox(
                                            height: responsive.hp(2),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _cargando.value = true;
                                if (_nombreProductoController.text.isNotEmpty) {
                                  if (_precioProductoController.text.isNotEmpty) {
                                    final productoApi = ProductosApi();

                                    if (_precioProductoController.text == widget.producto.productoPrecioVenta &&
                                        (_nombreProductoController.text == widget.producto.productoNombre &&
                                            _descripcionProductoController.text == widget.producto.productoDescripcion &&
                                            _image == null)) {
                                      Navigator.pop(context);
                                    } else if (_precioProductoController.text != widget.producto.productoPrecioVenta &&
                                        (_nombreProductoController.text == widget.producto.productoNombre &&
                                            _descripcionProductoController.text == widget.producto.productoDescripcion &&
                                            _image == null)) {
                                      print('Entré en sólo precio');
                                      final res = await productoApi.editarPrecioProducto(widget.producto.idProducto, _precioProductoController.text);
                                      if (res) {
                                        showToast2('Operación exitosa!!!', ColorsApp.greenGrey);
                                        final productosBloc = ProviderBloc.productos(context);
                                        productosBloc.obtenerProductos();
                                        Navigator.pop(context);
                                      } else {
                                        showToast2('Ocurrió un error', Colors.red);
                                      }
                                    } else if (_nombreProductoController.text != widget.producto.productoNombre ||
                                        _descripcionProductoController.text != widget.producto.productoDescripcion ||
                                        _image != null && _precioProductoController.text == widget.producto.productoPrecioVenta) {
                                      print('Entré en sólo datos');
                                      final res = await productoApi.editarProducto(
                                          _image, widget.producto.idProducto, _nombreProductoController.text, _descripcionProductoController.text);
                                      if (res) {
                                        showToast2('Operación exitosa!!!', ColorsApp.greenGrey);
                                        final productosBloc = ProviderBloc.productos(context);
                                        productosBloc.obtenerProductos();
                                        Navigator.pop(context);
                                      } else {
                                        showToast2('Ocurrió un error', Colors.red);
                                      }
                                    } else {
                                      print('Entré en ambos');
                                      var result = false;
                                      final resPrecio =
                                          await productoApi.editarPrecioProducto(widget.producto.idProducto, _precioProductoController.text);
                                      if (!resPrecio) {
                                        result = true;
                                        showToast2('Ocurrió un error al editar Precio', Colors.red);
                                      }
                                      final res = await productoApi.editarProducto(
                                          _image, widget.producto.idProducto, _nombreProductoController.text, _descripcionProductoController.text);
                                      if (!res) {
                                        result = true;
                                        showToast2('Ocurrió un error', Colors.red);
                                      }

                                      if (!result) {
                                        showToast2('Operación exitosa!!!', ColorsApp.greenGrey);
                                        final productosBloc = ProviderBloc.productos(context);
                                        productosBloc.obtenerProductos();
                                        Navigator.pop(context);
                                      }
                                    }
                                  } else {
                                    showToast2('Por favor ingrese el  precio del producto', Colors.black);
                                  }
                                } else {
                                  showToast2('Por favor ingrese el nombre del producto', Colors.black);
                                }
                                _cargando.value = false;
                              },
                              child: Container(
                                height: responsive.hp(7),
                                margin: EdgeInsets.symmetric(
                                  vertical: responsive.hp(1),
                                  horizontal: responsive.wp(3),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorsApp.blueApp,
                                ),
                                child: Center(
                                  child: Text(
                                    'Guardar',
                                    style: TextStyle(color: Colors.white, fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        (data)
                            ? SizedBox(
                                height: responsive.hp(90),
                                child: Center(
                                  child: (Platform.isAndroid) ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _nombre(Responsive responsive) {
    return TextField(
      focusNode: _focusNombre,
      cursorColor: Colors.transparent,
      keyboardType: TextInputType.text,
      maxLines: 1,

      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: responsive.hp(1),
            horizontal: responsive.wp(4),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Nombre del producto'),
      enableInteractiveSelection: false,
      controller: _nombreProductoController,
      //controller: montoPagarontroller,
    );
  }

  Widget _descripcion(Responsive responsive) {
    return TextField(
      focusNode: _focusDescripcion,
      cursorColor: Colors.transparent,
      keyboardType: TextInputType.text,
      maxLines: 2,

      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: responsive.hp(1),
            horizontal: responsive.wp(4),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Descripcion'),
      enableInteractiveSelection: false,
      controller: _descripcionProductoController,
      //controller: montoPagarontroller,
    );
  }

  Widget _precio(Responsive responsive) {
    return TextField(
      focusNode: _focusPrecio,
      cursorColor: Colors.transparent,
      keyboardType: TextInputType.number,
      maxLines: 1,

      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: responsive.hp(1),
            horizontal: responsive.wp(4),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          hintStyle: TextStyle(color: Colors.black45),
          hintText: 'Precio del producto'),
      enableInteractiveSelection: false,
      controller: _precioProductoController,
      //controller: montoPagarontroller,
    );
  }

  Widget _mostrarFoto(Responsive responsive) {
    if (_image != null) {
      return Center(
        child: Container(
          height: responsive.ip(15),
          // width: responsive.wp(30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.file(_image),
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          width: responsive.ip(15),
          height: responsive.ip(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                width: double.infinity,
                height: double.infinity,
                child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
              ),
              errorWidget: (context, url, error) => Container(
                width: double.infinity,
                height: double.infinity,
                child: Image(image: AssetImage('assets/img/food.jpg'), fit: BoxFit.cover),
              ),
              imageUrl: '${widget.producto.productoFoto}',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
