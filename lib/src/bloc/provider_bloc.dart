import 'package:flutter/material.dart';
import 'package:messita_app/src/bloc/login_bloc.dart';
import 'package:messita_app/src/bloc/mesas_negocio_bloc.dart';
import 'package:messita_app/src/bloc/productos_bloc.dart';

class ProviderBloc extends InheritedWidget {
  static ProviderBloc _instancia;

  factory ProviderBloc({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new ProviderBloc._internal(key: key, child: child);
    }

    return _instancia;
  }

  final loginBloc = LoginBloc();
  final mesasBloc = MesasNegocioBloc();
  final productosBloc = ProductosBloc();

  ProviderBloc._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).loginBloc;
  }

  static MesasNegocioBloc mesas(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).mesasBloc;
  }

  static ProductosBloc productos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>()).productosBloc;
  }
}
