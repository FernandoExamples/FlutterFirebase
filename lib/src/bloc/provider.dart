import 'package:flutter/material.dart';
import 'package:crud_rest/src/bloc/login_bloc.dart';
export 'package:crud_rest/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {

  //creamos un SingleTown 
  static Provider _instancia;

  factory Provider( {Key key, Widget child} ){
    if(_instancia == null)
       _instancia = new Provider._internal(key: key, child: child);

    return _instancia;
  }

  //Patron bloc
  final _loginBloc = LoginBloc();

  Provider._internal( {Key key, Widget child} ) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }
}
