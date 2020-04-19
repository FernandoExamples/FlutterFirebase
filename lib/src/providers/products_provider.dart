import 'dart:convert';
import 'dart:io';

import 'package:crud_rest/src/exception/custom_exception.dart';
import 'package:crud_rest/src/shared_prefs/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:crud_rest/src/models/product.dart';

class ProductsProvider{

  final String _url = 'https://flutter-varios-92b9d.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  /*
   * Metodo que hace un post a Firebase para guardar un objeto en Json. 
   * La respuesta que da el servidor es un json con el id que se le asigno al objeto, llamado name: 
   *  {name: -M2ZdjmZuoLvwB8glYF2}
   * Con ese json se puede transformar a un mapa para obtener el id.
   */
  Future<String> saveProduct(Product producto) async{
      String uid = _prefs.localId;
      String url = '$_url/usuarios/$uid/productos.json?auth=${_prefs.token}';

      http.Response response;

      try {
        response = await http.post(url, body: producto.toJson());
      } on Exception catch (ex) {
        print(ex);
        return null;
      }

      var decodedData = json.decode(response.body);  

      print(decodedData);
      String id = decodedData['name'];

      return id; 
  }

  /*
   * Regresa una lista de todos los productos de Firebase.
   * La respuesta que da el servidor son objetos-mapas cuyo nombre es su id y cada uno contiene un sus 
   * atributos
   * {
   *    "-M2ZSiuJxTyAUSEfHfvr":{
   *    "disponible":true,
   *    "titulo":"moto",
   *    "valor":1200.0}
   * }
   */
  Future<List<Product>> fetchAll() async {
      List<Product> productos = new List();
      String uid = _prefs.localId;

      String url = '$_url/usuarios/$uid/productos.json?auth=${_prefs.token}';


      http.Response resp;
      try{
        resp = await http.get(url);
      }
      on Exception catch(ex){
        print(ex);
        // return Future.error('Error al obtener todos los registros. fetchAll()');
        // throw Exception('Error al obtener todos los registros. fetchAll()');
        throw CustomException(CustomException.INTERNET_CODE, 'Error al obtener todos los registros');

      }
     
      Map<String, dynamic> decodedData = json.decode(resp.body);
      print(resp.body);
      print(decodedData);

      //si no hay productos en Firebase se regresa un String con "null" en el body de resp, 
      //lo que hace que decodedData quede null
      if(decodedData == null) return[];

      if(decodedData['error'] != null) 
        throw CustomException(CustomException.TIME_OUT_CODE, 'El token ha expirado');


      decodedData.forEach((id, product){
          var prodTemp = Product.fromMap(product);
          prodTemp.id = id;

          productos.add(prodTemp);
      });

      return productos;
  }

  /*
    Elimina un objeto de Firebase. El servidor no manda respuesta.
    resp se queda siempre null. 
   */
  Future<bool> deleteProduct(String id) async {
      String uid = _prefs.localId;
      var url = '$_url/usuarios/$uid/productos/$id.json?auth=${_prefs.token}';

      try {
        await http.delete(url);
      }on Exception catch(ex){
        print(ex);
        return false;
      }

      // print(resp.body);

      return true;
  }

  /*
   * Edita un producto de Firebase por medio de un put(). El cual es una operacion upsert.
   * La respuesta que manda el servidor es un json son las propiedades del objeto. 
   * {disponible: true, titulo: celular, valor: 300.0}
   */
  Future<bool> editProduct(Product producto) async{
      String uid = _prefs.localId;
      String url = '$_url/usuarios/$uid/productos/${producto.id}.json?auth=${_prefs.token}';

      http.Response response;

      try {
        response = await http.put(url, body: producto.toJson());
      } on Exception catch (ex) {
        print(ex);
        return false;
      }

      var decodedData = json.decode(response.body);

      print('print en ProductsProvider.editProduct()');
      print(decodedData);

      return true; 
  }

  /*
   * Sube una foto al servidor Cloudinary. 
   * Regresa el url de la imagen que se ha subido 
   */
  Future<String> subirImagen( File imagen ) async {

    //este es el URI para la peticion POST, esta probado con Postman 
    final uri = Uri.parse('http://api.cloudinary.com/v1_1/dz3l244en/image/upload?upload_preset=qhovhogw');


    //un mime es al tipo y extension del archivo: image/jpeg 
    final mimeType = mime(imagen.path).split('/'); 

    //se hace la peticion POST 
    final imageUploadRequest = http.MultipartRequest('POST', uri);

    ///el parametro 'file' es el nombre del parametro post que requiere el API cloudinary para
    ///mandarle la imagen 
    final file = await http.MultipartFile.fromPath('file', imagen.path, 
       contentType: MediaType(mimeType[0], mimeType[1])
    );

    //se adjunta el archivo a la peticion 
    imageUploadRequest.files.add(file);

    http.StreamedResponse streamResponse;
    try {
      streamResponse = await imageUploadRequest.send();
      
    } on Exception catch (ex) {
      print('Error Al subir la imagen');
      print(ex);
      return null;
    }

    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201 ){
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    //decodificamos la respuesta json del servidor
    final respData = json.decode(resp.body);
    print('------------print en ProductProvider.subirImagen()-------------');
    print(respData);
    print(respData['secure_url']);

    return respData['secure_url'];

  }

}