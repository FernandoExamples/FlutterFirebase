import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:crud_rest/src/models/product.dart';
import 'package:crud_rest/src/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:crud_rest/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {

  static final routeName = 'product';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<ScaffoldState>();

  final _productProvider = ProductsProvider();
  Product _producto = new Product();
  bool _guardando = false;
  File _foto;
  

  @override
  Widget build(BuildContext context) {

    final prodArgs = ModalRoute.of(context).settings.arguments;
    if( prodArgs != null){
      _producto = prodArgs;
    }

    return Scaffold(
      key: _scafoldKey,
       appBar: AppBar(
          title: Text('ProducPage'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto,
            ),

            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _tomarFoto,
            )
          ],
       ),

       body: SingleChildScrollView(
         child: _body(context),
       ),
       
    );
  }

  Widget _body(BuildContext context){
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _mostrarFoto(),
            _crearNombre(),
            _crearPrecio(),
            _crearDisponible(),
            _crearBoton(context),
          ],
        ),
      ),
    );
  }

  Widget _crearNombre(){
    return TextFormField(
      initialValue: _producto.titulo,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => _producto.titulo = value,
      validator: (value){
        if( value.length < 3 )
          return 'Ingrese en nombre del producto';
        
        return null;
      },
    );
  }

  Widget _crearPrecio(){
    return TextFormField(
      initialValue: _producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value) => _producto.valor = double.parse(value),
      validator: (value){
        
        if(!utils.isNumeric(value))
            return 'Ingresa un número válido';
          
        return null;
      },
    );
  }

  Widget _crearBoton(BuildContext context){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: _guardando ? null : _submit,
    );
  }

  Widget _crearDisponible(){
    return SwitchListTile(
        value: _producto.disponible,
        title: Text('Disponible'),
        activeColor: Theme.of(context).primaryColor,
        onChanged: (value) => setState((){
          _producto.disponible = value;
        }),
    );
  }

  ///Valida que todos los componentes del formulario cumplan las condiciones de validacion. 
  ///Posteriormente sube los datos al servidor. 
  void _submit() async {

    if(!_formKey.currentState.validate())
      return;

    //dispara el metodo onSave de todos los elementos del formulario que tenga esta llave
    //deberia llamarse despues de haber validado con validate()
    _formKey.currentState.save();

    setState(() { _guardando = true; } );

     if( _foto != null ){
       _producto.fotoUrl = await _productProvider.subirImagen(_foto);
    }

    if( _producto.id == null ){
      
      String id = await _productProvider.saveProduct(_producto);
      
      if(id == null)
        _mostrarSnackbar('Hubo un error al guardar el producto. Revia tu conexión  a Internet');
      else      
        Navigator.pop(context);

    }else{

      bool updated = await _productProvider.editProduct(_producto);
      if(updated)
        Navigator.pop(context);
      else
        _mostrarSnackbar('Hubo un error al actualizar el producto. Revia tu conexión  a Internet');

    }

    setState(() { _guardando = false; } );

  }

  void _mostrarSnackbar(String mensaje){

    final snackbar = SnackBar(
        content: Text(mensaje),
        duration: Duration(milliseconds: 1500),
    );
    
    _scafoldKey.currentState.showSnackBar(snackbar);
  }

   Widget _mostrarFoto(){

    if( _producto.fotoUrl != null ){
      return FadeInImage(
        image: NetworkImage(_producto.fotoUrl), 
        placeholder: AssetImage('assets/loading.gif'),     
        height: 300.0,
        fit: BoxFit.contain,
      );

    }else{

      return Image(
          image: AssetImage( _foto?.path ?? 'assets/no_image.png'),
          height: 300.0,
          fit: BoxFit.cover,
      );
    }

  }

  void _seleccionarFoto() async {
      _procesarImagen(ImageSource.gallery);
  } 

  void _tomarFoto() async {
      _procesarImagen(ImageSource.camera);
  }

  void _procesarImagen(ImageSource source) async {
    _foto = await ImagePicker.pickImage(
        source: source,
    );

     if( _foto != null){
        print('----------------print en ProductPage._procesarImagen()-------------------');
        print(_foto.path);

        _producto.fotoUrl = null;
      }

    setState(() {});
  }
}