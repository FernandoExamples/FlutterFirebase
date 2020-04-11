import 'package:crud_rest/src/pages/login_page.dart';
import 'package:crud_rest/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:crud_rest/src/bloc/provider.dart';
import 'package:crud_rest/src/pages/home_page.dart';

class RegistroPage extends StatelessWidget {

  static final routeName = 'registro';
  final usuarioProvider = new UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(children: <Widget>[
          _crearFondo(context),
          _logingForm(context),
        ],
       ),     
    );
  }

  Widget _crearFondo(BuildContext context){
    final size = MediaQuery.of(context).size;
    final heigth = size.height * 0.40;

    var fondoMorado =  Container(
      height: heigth,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ]
        )
      ),
    );

    var circulo = Container(
      width: heigth * 0.30,
      height: heigth * 0.30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(heigth * 0.30),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(child: circulo, top: heigth * 0.25, left: 30.0),
        Positioned(child: circulo, top: -heigth * 0.1, right: -30.0),
        Positioned(child: circulo, bottom: -heigth*0.1, right: -10),
        Positioned(child: circulo, bottom: heigth * 0.40, right: 30),
        Positioned(child: circulo, bottom: -heigth*0.15, left: -20),

        Container(
          width: double.infinity,  
          padding: EdgeInsets.only(top: heigth*0.23),    
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              Text('Fernando Acosta', style: TextStyle(color: Colors.white, fontSize: 25.0)),
            ],
          ),
        ),

      ],
    );
  }

  Widget _logingForm(BuildContext context) {

    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0,
            )
          ),

          Container( 
            width: size.width*0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0), 
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                )
              ]
            ),

            child: Column(
              children: <Widget>[
                Text('Registro', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _crearEmail(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(context, bloc),
              ],
            ),
          ),

          FlatButton(
              child: Text('¿Ya tienes cuenta? Login'),
              onPressed: () => Navigator.pushReplacementNamed(context, LoginPage.routeName),
          ),
          SizedBox(height: 100)
          
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),      
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Correo electrónico',
                  errorText: snapshot.error
                ),  

                onChanged: (value) => bloc.changeEmail(value),
                
              ),
            );

      },
    );

  }

  Widget _crearPassword(LoginBloc bloc){


    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
                
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                  labelText: 'Contraseña',
                  errorText: snapshot.error,
                ),   
                onChanged: (value){
                  bloc.changePassword(value);
                },          
              ),
            );
      },
    );  
  }

  Widget _crearBoton(BuildContext context, LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (context, snapshot){

        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Registrarse'),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,

          onPressed: snapshot.hasData ? ()  => _register(context, bloc): null,
        );

      }      
    );
     
  }

  void _register(BuildContext context, LoginBloc bloc){

    usuarioProvider.nuevoUsuario(bloc.email, bloc.password);

    // Navigator.pushReplacementNamed(context, HomePage.routeName);
  }
}