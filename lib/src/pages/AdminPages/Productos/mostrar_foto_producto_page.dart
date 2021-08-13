import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messita_app/src/model/productos_model.dart';
import 'package:messita_app/src/utils/responsive.dart';

class MostrarFotoProductoPage extends StatefulWidget {
  final ProductosModel producto;
  const MostrarFotoProductoPage({Key key, @required this.producto}) : super(key: key);

  @override
  _MostrarFotoProductoPageState createState() => _MostrarFotoProductoPageState();
}

class _MostrarFotoProductoPageState extends State<MostrarFotoProductoPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black.withOpacity(.4),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Column(
            children: [
              Spacer(),
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
              Stack(
                children: [
                  Container(
                    height: responsive.hp(50),
                    margin: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(3)),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(45), color: Colors.white),
                    child: _mostrarFoto(responsive),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: responsive.hp(7.5),
                      margin: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(3)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: Colors.black.withOpacity(0.6)),
                      child: Center(
                          child: Text(
                        '${widget.producto.productoNombre}',
                        style: TextStyle(letterSpacing: 1.5, fontSize: responsive.ip(2.5), color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
              Spacer()
            ],
          ),
        ],
      ),
    );
  }

  Widget _mostrarFoto(Responsive responsive) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
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
    );
  }
}
