
import 'package:crud_rest/src/models/user.dart';
import 'package:crud_rest/src/shared_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:crud_rest/src/providers/user_provider.dart';

///Controla el estado de logueo del usuario, asi como el usuario logueado
class LoginState with ChangeNotifier{

  final _userProvider = UserProvider();
  final _prefs = new PreferenciasUsuario();
  User user; 

  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  LoginState(){
     if(_prefs.isRemembered){
       _loggedIn = true;
       user = new User(
         idToken: _prefs.token,
         email: _prefs.email,
         localId: _prefs.localId,
         refreshToken: _prefs.refreshToken
       );
     }
  }

  Future<User> login(String email, String password) async {

    Map info = await _userProvider.login(email, password);

    if(info != null){  

      //si contiene el campo idToken es porque es una respuesta valida y existe el email
      if(info.containsKey('idToken')){
        user = User.fromMap(info);
        _prefs.token = info['idToken']; //guardar el token en las preferencias de usuario
        _prefs.email = info['email'];
        _prefs.localId = info['localId'];
        _prefs.refreshToken = info['refreshToken'];
        _loggedIn = true;
        notifyListeners();  
      }else{
        user = new User();
      }
    }else
      user = null;    

    return user;
  }

  void logout(){
    _loggedIn = false;
    _prefs.clear();
    notifyListeners();
  }  

  Future<User> registerNewUser(String email, String password) async {

    Map info = await _userProvider.nuevoUsuario(email, password);

     if(info != null){  

      //si contiene el campo idToken es porque es una respuesta valida y existe el email
      if(info.containsKey('idToken')){
        user = User.fromMap(info);
        
        // _prefs.token = info['idToken']; //guardar el token en las preferencias de usuario
        // _loggedIn = true;
        // notifyListeners();  
      }else{
        user = new User();
      }
    }else
      user = null;    

    return user;

  }

  Future<bool> refreshToken() async {
     Map info = await _userProvider.refreshToken(user.refreshToken);

     if(info != null){
       user.idToken = info['id_token'];
       user.expiresIn = info['expires_in'];
       user.localId = info['user_id'];
       user.refreshToken = info['refresh_token'];
       notifyListeners();
       return true;
     }

    return  false;
  }
}