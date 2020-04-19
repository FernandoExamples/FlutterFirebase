import 'package:crud_rest/src/bloc/login_bloc.dart';
import 'package:crud_rest/src/bloc/login_state.dart';
import 'package:crud_rest/src/pages/product_page.dart';
import 'package:crud_rest/src/pages/registro_page.dart';
import 'package:crud_rest/src/shared_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:crud_rest/src/pages/home_page.dart';
import 'package:crud_rest/src/pages/login_page.dart';
import 'package:provider/provider.dart';

import 'src/bloc/productos_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
          ChangeNotifierProvider<LoginState>(create: (context) => LoginState()),
          Provider<LoginBloc>(create: (context) => LoginBloc()),
          Provider<ProductosBloc>(create: (context) => ProductosBloc()),
      ],
      child: Consumer<LoginState>(
        builder: (BuildContext context, LoginState state, Widget child) {

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Material App',
              initialRoute:  LoginPage.routeName,
              theme: ThemeData(primaryColor: Colors.deepPurple),
              routes: {
                LoginPage.routeName: (context) => state.isLoggedIn ? HomePage() : LoginPage(),                
                HomePage.routeName: (context) => HomePage(),
                ProductPage.routeName: (context) => ProductPage(),
                RegistroPage.routeName: (context) => state.isLoggedIn ? HomePage() : RegistroPage()                 
              },
            );
        },        
      ),
    );
  }
}
