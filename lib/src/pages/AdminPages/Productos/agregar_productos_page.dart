import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messita_app/src/api/productos_api.dart';
import 'package:messita_app/src/bloc/provider_bloc.dart';
import 'package:messita_app/src/theme/theme.dart';
import 'package:messita_app/src/utils/responsive.dart';
import 'package:messita_app/src/utils/utils.dart';

class AgregarProductosPage extends StatefulWidget {
  const AgregarProductosPage({Key key}) : super(key: key);

  @override
  _AgregarProductosPageState createState() => _AgregarProductosPageState();
}

class _AgregarProductosPageState extends State<AgregarProductosPage> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  TextEditingController _nombreProductoController = TextEditingController();
  TextEditingController _precioProductoController = TextEditingController();
  TextEditingController _descripcionProductoController = TextEditingController();

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
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black.withOpacity(.4),
      child: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool data, Widget child) {
            return SingleChildScrollView(
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
                        child: SingleChildScrollView(
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
                                      child: Text('Agregar un nuevo producto',
                                          style: TextStyle(fontSize: responsive.ip(2.5), color: ColorsApp.greenGrey)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nombre del Producto',
                                          style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.greenGrey, fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: responsive.wp(2),
                                          ),
                                          width: responsive.wp(90),
                                          height: responsive.hp(5),
                                          child: TextField(
                                            cursorColor: Colors.black26,
                                            style: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                            keyboardType: TextInputType.text,
                                            //autofocus: true,
                                            decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFF2141F3)),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                                ),
                                                hintStyle: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                                hintText: 'Ingrese nombre'),
                                            enableInteractiveSelection: false,
                                            controller: _nombreProductoController,
                                          ),
                                        ),
                                        SizedBox(
                                          height: responsive.hp(3),
                                        ),
                                        Text(
                                          'Precio del Producto',
                                          style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.greenGrey, fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: responsive.wp(2),
                                          ),
                                          width: responsive.wp(90),
                                          height: responsive.hp(5),
                                          child: TextField(
                                            cursorColor: Colors.black26,
                                            style: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                            keyboardType: TextInputType.number,
                                            //autofocus: true,
                                            decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFF2141F3)),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                                ),
                                                hintStyle: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                                hintText: 'Ingrese precio'),
                                            enableInteractiveSelection: false,
                                            controller: _precioProductoController,
                                          ),
                                        ),
                                        SizedBox(
                                          height: responsive.hp(3),
                                        ),
                                        Text(
                                          'Descripcion',
                                          style: TextStyle(fontSize: responsive.ip(2), color: ColorsApp.greenGrey, fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: responsive.wp(2),
                                          ),
                                          width: responsive.wp(90),
                                          height: responsive.hp(10),
                                          child: TextField(
                                            maxLines: 2,
                                            cursorColor: Colors.black26,
                                            style: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                            keyboardType: TextInputType.number,
                                            //autofocus: true,
                                            decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFF2141F3)),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFCBB6AA)),
                                                ),
                                                hintStyle: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
                                                hintText: 'Descripcion'),
                                            enableInteractiveSelection: false,
                                            controller: _descripcionProductoController,
                                          ),
                                        ),
                                        SizedBox(
                                          height: responsive.hp(2),
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
                                              Text('Seleccionar Foto'),
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
                                        SizedBox(
                                          height: responsive.hp(2),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          _cargando.value = true;
                          if (_nombreProductoController.text.isNotEmpty) {
                            if (_precioProductoController.text.isNotEmpty) {
                              final productoApi = ProductosApi();

                              final res = await productoApi.guardarProducto(
                                  _image, _nombreProductoController.text, _precioProductoController.text, _descripcionProductoController.text);
                              if (res) {
                                showToast2('Producto agregado', ColorsApp.greenGrey);
                                final productosBloc = ProviderBloc.productos(context);
                                productosBloc.obtenerProductos();
                                Navigator.pop(context);
                              } else {
                                showToast2('Ocurrió un error', Colors.red);
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
                              'Agregar',
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
            );
          },
        ),
      ),
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
      return Container();
    }
  }
}
