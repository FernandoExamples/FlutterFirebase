import 'package:crud_rest/src/pages/product_page.dart';
import 'package:crud_rest/src/pages/registro_page.dart';
import 'package:flutter/material.dart';
import 'package:crud_rest/src/bloc/provider.dart';
import 'package:crud_rest/src/pages/home_page.dart';
import 'package:crud_rest/src/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: LoginPage.routeName,
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          HomePage.routeName: (context) => HomePage(),
          ProductPage.routeName: (context) => ProductPage(),
          RegistroPage.routeName: (context) => RegistroPage(),
        },
      ),
    );
  }
}