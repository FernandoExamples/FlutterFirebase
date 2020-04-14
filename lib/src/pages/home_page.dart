import 'package:crud_rest/src/bloc/productos_bloc.dart';
import 'package:crud_rest/src/exception/custom_exception.dart';
import 'package:crud_rest/src/models/product.dart';
import 'package:crud_rest/src/pages/login_page.dart';
import 'package:crud_rest/src/pages/product_page.dart';
import 'package:crud_rest/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  static final routeName = 'home';
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.of<ProductosBloc>(context);

    return Scaffold(
       key: _scaffoldKey,
       appBar: AppBar(
          title: Text('HomePage'),
       ),
       body: _createList(productosBloc),
       floatingActionButton: _floatingButton(context),
       
    );

  }

  FloatingActionButton _floatingButton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        Navigator.of(context).pushNamed(ProductPage.routeName);
      },
    );
  }

  Widget _createList(ProductosBloc productosBloc){
    
    var str = StreamBuilder(
      stream: productosBloc.productosStream ,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot){

          if(snapshot.hasData){
            
            final productos = snapshot.data;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) => _createItem(context, productos[index], productosBloc),
            );
            
          }

          if(snapshot.hasError){  
            final error = snapshot.error as CustomException;

            if(error.code == CustomException.TIME_OUT_CODE){
              //TODO hacer el logout
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            }else if(error.code == CustomException.INTERNET_CODE){
              return ListView(
                children: <Widget>[
                  Container(
                    child: Center(child: Text('Revisa tu conexión a Internet')),
                    height: 500.0,
                  )
                ],

              );
            }

          }
            
          return Center(child: CircularProgressIndicator());
      },
    );

    return RefreshIndicator(
      child: str, 
      onRefresh: productosBloc.cargarProductos,
    );

  }

  Widget _createItem(BuildContext context,  Product producto, ProductosBloc productosBloc){
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),     
      onDismissed: (direction) async {

        bool borrado = await productosBloc.borrarProducto(producto.id);

        if(!borrado){          
          utils.mostrarSnackbar(_scaffoldKey, "Hubo un error al eliminar el producto. Checha tu conexion a Internet");
        }

      }, 

      child: Card(
        child: Column(
          children:[

            ( producto.fotoUrl == null ) ? 
            Image(image: AssetImage('assets/no_image.png')) 
            : FadeInImage(
              image: NetworkImage(producto.fotoUrl), 
              placeholder: AssetImage('assets/loading.gif'),     
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

             ListTile(
              title: Text('${producto.titulo} - \$${producto.valor}'),
              subtitle: Text(producto.id),
              onTap: () => Navigator.pushNamed(context, ProductPage.routeName, arguments: producto),
            ),

          ]
        ),
      ),
      
    );

  }   
}