import 'dart:io';

import 'package:crud_rest/src/exception/custom_exception.dart';
import 'package:crud_rest/src/models/product.dart';
import 'package:crud_rest/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc{

  final _productosController = BehaviorSubject<List<Product>>();
  final _loadingController = BehaviorSubject<bool>();

  final _productosProvider = ProductsProvider();

  //creamos los Streams que los Widgets estaran escuchando
  Stream<List<Product>> get productosStream => _productosController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  ProductosBloc(){
     cargarProductos();
  }

  Future<void> cargarProductos() async {
      
      try{
        var productos = await _productosProvider.fetchAll();
        _productosController.sink.add(productos);
      }on CustomException catch(ex){
        print(ex.message);
        print(ex);
        _productosController.addError(ex);
      }on Exception catch(ex){
        print(ex);
        _productosController.addError(ex);
      }
  }

  Future<String> agregarProducto(Product producto) async {

      //notificamos el stream que indica que se esta guardandi informacion para bloquear botones
      _loadingController.sink.add(true); 
      String id = await _productosProvider.saveProduct(producto);
      if(id != null)
        cargarProductos();      
      _loadingController.sink.add(false);

      return id;
  }

  Future<String> subirFoto(File foto) async {

      //notificamos el stream que indica que se esta guardandi informacion para bloquear botones
      _loadingController.sink.add(true); 
      String fotoUrl = await _productosProvider.subirImagen(foto);
      _loadingController.sink.add(false);      

      return fotoUrl;
  }

  Future<bool> editarProducto(Product producto) async {

      bool updated = await _productosProvider.editProduct(producto);
      if(updated)
        cargarProductos();
      return updated;
  }

   Future<bool> borrarProducto(String id) async {

      //notificamos el stream que indica que se esta guardandi informacion para bloquear botones
      _loadingController.sink.add(true); 
      bool deleted = await _productosProvider.deleteProduct(id);
      if(deleted)
        cargarProductos();     
      _loadingController.sink.add(false); 

      return deleted;
  }


  dispose(){
    _productosController?.close();
    _loadingController?.close();
  }

}