import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:messita_app/src/prefences/preferences.dart';
import 'package:messita_app/src/utils/constants.dart';

class LoginApi {
  final prefs = new Preferences();

  Future<LoginModel> login(String user, String pass) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Login/validar_sesion');

      final resp = await http.post(url, body: {
        'usuario_nickname': '$user',
        'usuario_contrasenha': '$pass',
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];
      LoginModel loginModel = LoginModel();
      loginModel.code = code.toString();
      loginModel.message = decodedData['result']['message'];

      if (code == 1) {
        if (decodedData['data']['agente'] != 0) {
          //Guardar datos Usuario
          prefs.idUser = decodedData['data']['c_u'];
          prefs.userNickname = decodedData['data']['_n'];
          prefs.userImage = '$apiBaseURL/${decodedData['data']['u_i']}';
          prefs.personName = decodedData['data']['p_n'];
          prefs.personSurname = '${decodedData['data']['p_p']} ${decodedData['data']['p_m']}';
          //Guardar rol Usuario
          prefs.idRol = decodedData['data']['ru'];
          prefs.rolName = decodedData['data']['rn'];
          //Guardar Negocio
          prefs.idNegocio = decodedData['data']['n_i'];
          prefs.negocioNombre = decodedData['data']['n_n'];
          prefs.negocioImage = '$apiBaseURL/${decodedData['data']['n_f']}';
          prefs.negocioRuc = decodedData['data']['n_r'];
          prefs.idSucursal = decodedData['data']['i_d'];
          prefs.token = decodedData['data']['tn'];
          if (prefs.idRol == '2') {
            loginModel.page = 'homePage';
            prefs.pageInit = 'homePage';
          } else if (prefs.idRol == '3') {
            loginModel.page = 'homePage';
            prefs.pageInit = 'homePage';
          } else if (prefs.idRol == '4') {
            loginModel.page = 'meseroPage';
            prefs.pageInit = 'meseroPage';
          } else if (prefs.idRol == '5') {
            loginModel.page = 'cajeroPage';
            prefs.pageInit = 'cajeroPage';
          } else if (prefs.idRol == '6') {
            loginModel.page = 'cocinaPage';
            prefs.pageInit = 'cocinaPage';
          }
        } else {
          loginModel.code = '2';
          loginModel.message = decodedData['result']['message'];
        }

        return loginModel;
      } else {
        return loginModel;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      LoginModel loginModel = LoginModel();
      loginModel.code = '2';
      loginModel.message = 'Error en la petición';
      return loginModel;
    }
  }
}

class LoginModel {
  String code;
  String message;
  String page;

  LoginModel({this.code, this.message, this.page});
}
