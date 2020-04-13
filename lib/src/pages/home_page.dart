import 'package:crud_rest/src/models/product.dart';
import 'package:crud_rest/src/pages/product_page.dart';
import 'package:crud_rest/src/providers/products_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  static final routeName = 'home';
  final productProvider = ProductsProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
       key: _scaffoldKey,
       appBar: AppBar(
          title: Text('HomePage'),
       ),
       body: _createList(),

       floatingActionButton: _floatingButton(context),
       
    );

  }

  FloatingActionButton _floatingButton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        Navigator.pushNamed(context, ProductPage.routeName);
      },
    );
  }

  Widget _createList(){
    
    return FutureBuilder(
      future: productProvider.fetchAll(),
      builder: (context, AsyncSnapshot<List<Product>> snapshot){
          if(snapshot.hasData){
            
            final productos = snapshot.data;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) => _createItem(context, productos[index]),
            );
            
          }

          if(snapshot.hasError){
            return Center(child: Text('Revisa tu conexión a Internet'));
          }
            
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createItem(BuildContext context,  Product producto){
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),     
      onDismissed: (direction) async {

        var count = await productProvider.deleteProduct(producto.id);
        if(count == -1){
          _mostrarSnackbar("Hubo un error al eliminar el producto. Checha tu conexion a Internet");
        }


      }, 

      child: Card(
        child: Column(
          children:[

            ( producto.fotoUrl == null ) ? Image(image: AssetImage('assets/no_image.png')) 
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

  void _mostrarSnackbar(String mensaje){

    final snackbar = SnackBar(
        content: Text(mensaje),
        duration: Duration(milliseconds: 1500),
    );
    
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}