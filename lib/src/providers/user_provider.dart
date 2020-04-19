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

      var resp = await _launchPost(registEndPoint, authData);
      
      Map<String, dynamic> decodedResp = resp != null ? json.decode(resp?.body) : null;

      return decodedResp;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {

      final loginEndpoint = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey';

      final authData = {
        'email' : email,
        'password' : password,
        'returnSecureToken' : true
      };

      var resp = await _launchPost(loginEndpoint, authData);

      Map<String, dynamic> decodedResp = resp != null ? json.decode(resp?.body) : null;     

      return decodedResp;
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {

      final loginEndpoint = 'https://securetoken.googleapis.com/v1/token?key=$_apiKey';

      final authData = {
        'grant_type' : 'refresh_token',
        'refresh_token' : refreshToken,
      };

      var resp = await _launchPost(loginEndpoint, authData);

      Map<String, dynamic> decodedResp = resp != null ? json.decode(resp?.body) : null;      

      return decodedResp;
  }

  ///Este metodo lanza una peticion POST al endpoint que se le manda como parametro
  Future<http.Response> _launchPost (String endpoit, Map bodyData) async {
      var resp;
      try{
          resp = await http.post(
          endpoit,
          body: json.encode(bodyData)
        );
      } on Exception catch(ex){
          print(ex);
          return null;
      }

      return resp;
  }
}