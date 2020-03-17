import 'package:crud_rest/src/models/product.dart';
import 'package:crud_rest/src/pages/product_page.dart';
import 'package:crud_rest/src/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:crud_rest/src/bloc/provider.dart';

class HomePage extends StatelessWidget {

  static final routeName = 'home';
  final productProvider = ProductsProvider();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
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
      onDismissed: (direction){

        productProvider.deleteProduct(producto.id);

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
}