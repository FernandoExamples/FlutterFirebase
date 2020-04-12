import 'dart:convert';

import 'package:http/http.dart' as http;
class UserProvider{

  final _apiKey = 'AIzaSyANkSeF2B_4sk3sWjof1YEMXhX6KnEK53c';

  ///Lanza una peticion POST a Firebase para crear un nuevo usuario 
  Future<Map<String, dynamic>> nuevoUsuario(String email, String password) async {
    final registEndPoint = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey';

      final authData = {
        'email' : email,
        'password' : password,
        'returnSecureToken' : true
      };

      final resp = await http.post(
        registEndPoint,
        body: json.encode(authData)
      );

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      //si contiene el campo idToken es porque es una respuesta valida y se registro el usuario
      if(decodedResp.containsKey('idToken')){
        //TODO  SALVAR EL TOKEN EN EL STORAGE 
        return {'ok': true, 'token': decodedResp['idToken']};
      }else{
        return {'ok': true, 'mensaje': decodedResp['error']['message']};
      }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {

      final loginEndpoint = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey';

      final authData = {
        'email' : email,
        'password' : password,
        'returnSecureToken' : true
      };

      final resp = await http.post(
        loginEndpoint,
        body: json.encode(authData)
      );

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      print(decodedResp);

      //si contiene el campo idToken es porque es una respuesta valida y existe el email
      if(decodedResp.containsKey('idToken')){
        //TODO  SALVAR EL TOKEN EN EL STORAGE 
        return {'ok': true, 'token': decodedResp['idToken']};
      }else{
        return {'ok': true, 'mensaje': decodedResp['error']['message']};
      }
  }
}