import 'package:crud_rest/src/bloc/login_bloc.dart';
import 'package:crud_rest/src/bloc/login_state.dart';
import 'package:crud_rest/src/models/user.dart';
import 'package:crud_rest/src/pages/registro_page.dart';
import 'package:crud_rest/src/providers/user_provider.dart';
import 'package:crud_rest/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  static final routeName = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final userProvider = UserProvider();
  LoginState _state;
  bool _entrando = false; 


  @override
  Widget build(BuildContext context) {

    _state = Provider.of<LoginState>(context);
    
    return Scaffold(
       key: _scaffoldKey,
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

    final loginBloc = Provider.of<LoginBloc>(context);
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
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _crearEmail(loginBloc),
                SizedBox(height: 30.0),
                _crearPassword(loginBloc),
                SizedBox(height: 30.0),
                _crearBoton(context, loginBloc),
              ],
            ),
          ),

          FlatButton(
              child: Text('Crear una nueva cuenta'),
              onPressed: () => Navigator.pushReplacementNamed(context, RegistroPage.routeName),
          ),
          SizedBox(height: 100)
          
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc loginBloc){

    return StreamBuilder(
      stream: loginBloc.emailStream ,
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

                onChanged: (value) => loginBloc.changeEmail(value),
                
              ),
            );

      },
    );

  }

  Widget _crearPassword(LoginBloc loginBloc){


    return StreamBuilder(
      stream: loginBloc.passwordStream ,
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
                  loginBloc.changePassword(value);
                },          
              ),
            );
      },
    );  
  }

  Widget _crearBoton(BuildContext context, LoginBloc loginBloc){

    return StreamBuilder(
      stream: loginBloc.formValidStream,
      builder: (context, snapshot){

        if(_entrando){
            return CircularProgressIndicator();
        }else{
            return RaisedButton(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Text('Ingresar'),
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
              ),
              elevation: 0.0,
              color: Colors.deepPurple,
              textColor: Colors.white,

              onPressed:snapshot.hasData ? ()  => _login(loginBloc): null,
           );
        }

      }      
    );
     
  }

  void _login(LoginBloc loginBloc) async {
    
    setState(() {
      _entrando = true;
    });

    User user = await _state.login(loginBloc.email, loginBloc.password);
    
    if(user != null){
      if(!user.isCorrect)
        mostrarSnackbar(_scaffoldKey, 'Usuario o Contraseña incorrectos');
    }
    else
      mostrarSnackbar(_scaffoldKey, "Ha ocurrido un error. Revisa tu conexión a Internet");
    
    setState(() {
      _entrando = false;
    });

  }
}