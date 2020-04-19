
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  void clear(){
    _prefs.clear();
  }

  // GET y SET del token
  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }

  // GET y SET del localId
  String get localId {
    return _prefs.getString('localId') ?? '';
  }

  set localId( String value ) {
    _prefs.setString('localId', value);
  }

  // GET y SET del localId
  String get email {
    return _prefs.getString('email') ?? '';
  }

  set email( String value ) {
    _prefs.setString('email', value);
  }

  // GET y SET del refreshToken
  String get refreshToken {
    return _prefs.getString('refreshToken') ?? '';
  }

  set refreshToken( String value ) {
    _prefs.setString('refreshToken', value);
  }
  
  bool get isRemembered{
    return _prefs.getString('token') != null;
  } 

}