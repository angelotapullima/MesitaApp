import 'dart:async';

class Validators {
  final validarUsuario = StreamTransformer<String, String>.fromHandlers(handleData: (user, sink) {
    if (user.length > 0) {
      sink.add(user);
    } else {
      sink.addError('El campo usuario no debe estar vacio');
    }
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(handleData: (password, sink) {
    if (password.length >= 0) {
      sink.add(password);
    } else {
      sink.addError('El campo passWord no debe estar vacio');
    }
  });
}
