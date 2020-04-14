import 'dart:async';

import 'package:crud_rest/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

  /*
   * El BehaiviorSuybject es un StreamController especial que captura el último elemento que se ha 
   * agregado al controlador y lo emite como el primer elemento para 
   * cualquier nuevo oyente. Es por defecto tipo broadcast
   */
  final _emailController = BehaviorSubject<String>(); 
  final _passwordController = BehaviorSubject<String>(); 

  //Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Recuperar los datos del Stream
  Stream<String> get emailStream => _emailController.stream.transform( validateEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validatePassword );

  //Combinar ambos Streams
  Stream<bool> get formValidStream{
    return CombineLatestStream.combine2(emailStream, passwordStream, (email, pass) => true);
  }

  //Obtener el ultimo valor capturado por el Stream
  String get email{
    return _emailController.value;
  }

  String get password{
    return _passwordController.value;
  } 

  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }
  
}