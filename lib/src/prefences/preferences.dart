import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instancia = new Preferences._internal();

  factory Preferences() {
    return _instancia;
  }

  SharedPreferences _prefs;

  Preferences._internal();

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  clearPreferences() async {
    await _prefs.clear();
  }

  get idUser {
    return _prefs.getString('idUser');
  }

  set idUser(String value) {
    _prefs.setString('idUser', value);
  }

  get userNickname {
    return _prefs.getString('user_nickname');
  }

  set userNickname(String value) {
    _prefs.setString('user_nickname', value);
  }

  get userImage {
    return _prefs.getString('userImage');
  }

  set userImage(String value) {
    _prefs.setString('userImage', value);
  }

  get personName {
    return _prefs.getString('person_name');
  }

  set personName(String value) {
    _prefs.setString('person_name', value);
  }

  get personSurname {
    return _prefs.getString('person_surname');
  }

  set personSurname(String value) {
    _prefs.setString('person_surname', value);
  }

  get token {
    return _prefs.getString('token');
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get idNegocio {
    return _prefs.getString('idNegocio');
  }

  set idNegocio(String value) {
    _prefs.setString('idNegocio', value);
  }

  get negocioNombre {
    return _prefs.getString('negocioNombre');
  }

  set negocioNombre(String value) {
    _prefs.setString('negocioNombre', value);
  }

  get negocioImage {
    return _prefs.getString('negocioImage');
  }

  set negocioImage(String value) {
    _prefs.setString('negocioImage', value);
  }

  get negocioRuc {
    return _prefs.getString('negocioRuc');
  }

  set negocioRuc(String value) {
    _prefs.setString('negocioRuc', value);
  }

  get idRol {
    return _prefs.getString('idRol');
  }

  set idRol(String value) {
    _prefs.setString('idRol', value);
  }

  get rolName {
    return _prefs.getString('rolName');
  }

  set rolName(String value) {
    _prefs.setString('rolName', value);
  }

  get pageInit {
    return _prefs.getString('pageInit');
  }

  set pageInit(String value) {
    _prefs.setString('pageInit', value);
  }
}
