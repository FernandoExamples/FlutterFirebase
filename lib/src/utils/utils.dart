import 'package:flutter/material.dart';

bool isNumeric(String value) {
  if (value.isEmpty) return false;

  final n = num.tryParse(value);

  return n != null;
}

void showAlert(BuildContext context, String title, String message){
  showDialog(
    context: context,
    builder: (context){

      return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
      );

    }
  );   
}

void mostrarSnackbar(GlobalKey<ScaffoldState> scaffoldKey, String mensaje){

    final snackbar = SnackBar(
        content: Text(mensaje),
        duration: Duration(milliseconds: 1500),
    );
    
    scaffoldKey.currentState.showSnackBar(snackbar);
}

///Obtiene un porcentaje especifico de la altura de la pantalla
double getPercentScreenHeigth(BuildContext context, double percent){
  final screenSize = MediaQuery.of(context).size;
  return screenSize.height * percent;
}


