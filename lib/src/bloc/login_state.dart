
import 'package:flutter/material.dart';
import 'package:crud_rest/src/providers/user_provider.dart';

///Controla el estado de logueo del usuario, asi como el usuario logueado
class LoginState with ChangeNotifier{

  final userProvider = UserProvider();
  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  Future<Map<String, dynamic>> login(String email, String password) async {

    Map info = await userProvider.login(email, password);

    if(info['ok']){      
      _loggedIn = true;
      notifyListeners();     
    }

    return info;
  }

  void logout(){
    _loggedIn = false;
    notifyListeners();
  }  

  Future<Map<String, dynamic>> registerNewUser(String email, String password) async {

    Map info = await userProvider.nuevoUsuario(email, password);

    if(info['ok']){      
      // _loggedIn = true;
      // notifyListeners();     
    }

    return info;
  }

}