import 'package:flutter/material.dart';

import 'package:crud_rest/src/bloc/login_bloc.dart';
export 'package:crud_rest/src/bloc/login_bloc.dart';

import 'package:crud_rest/src/bloc/productos_bloc.dart';
export 'package:crud_rest/src/bloc/productos_bloc.dart';

 ///Esta clase no se usa ya. Se sustituyo por la libreria Provider
 ///Es meramente documental solo para aprender como se hace un Provider manualmente
 ///En la practica es mas sencillo usar la libreria
class MyProvider extends InheritedWidget {

  //Patrones bloc
  final _loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();

  //creamos un SingleTown 
  static MyProvider _instancia;

  factory MyProvider( {Key key, Widget child} ){
    if(_instancia == null)
       _instancia = new MyProvider._internal(key: key, child: child);

    return _instancia;
  }
  MyProvider._internal( {Key key, Widget child} ) : super(key: key, child: child);

  
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc ofLoginBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyProvider>()._loginBloc;
  }

  static ProductosBloc ofProductosBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyProvider>()._productosBloc;
  }

}
