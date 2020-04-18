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

      var resp;
      try{
            resp = await http.post(
            registEndPoint,
            body: json.encode(authData)
          );
      } on Exception catch(ex){
          print(ex);
          return null;
      }

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      return decodedResp;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {

      final loginEndpoint = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey';

      final authData = {
        'email' : email,
        'password' : password,
        'returnSecureToken' : true
      };

      var resp;
      try{
          resp = await http.post(
          loginEndpoint,
          body: json.encode(authData)
        );
      } on Exception catch(ex){
          print(ex);
          return null;
      }

      Map<String, dynamic> decodedResp = json.decode(resp.body);       

      return decodedResp;
  }
}