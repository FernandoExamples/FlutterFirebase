import 'dart:convert';

import 'package:http/http.dart' as http;
class UserProvider{

  final _newUserEndPoint = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
  final _apiKey = 'AIzaSyANkSeF2B_4sk3sWjof1YEMXhX6KnEK53c';

  Future nuevoUsuario(String email, String password) async {

    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      _newUserEndPoint+_apiKey,
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    //si contiene el campo idToken es porque es una respuesta valida y se registro el usuario
    if(decodedResp.containsKey('idToken')){
      //TODO  SALVAR EL TOKEN EN EL STORAGE 
      return {'ok': true, 'token': decodedResp['idToken']};
    }else{
      return {'ok': true, 'mensaje': decodedResp['error']['message']};
    }
  }

}