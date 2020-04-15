import 'package:flutter/material.dart';
import 'package:crud_rest/src/bloc/login_state.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {

  // final prefs = new PreferenciasUsuario();

  var _loginState;

  @override
  Widget build(BuildContext context) {
     _loginState = Provider.of<LoginState>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createMenu('Logout', Icons.exit_to_app, context),          
        ],
      ),
    );
  }

  Widget _createMenu(String title, IconData icon,  BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: Colors.blue),
      onTap: () {
         
          _loginState.logout();
      }
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Container(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/drawer_header.jpg'), fit: BoxFit.cover),
      ),
    );
  }

  Divider _divider() {
    return Divider(
      color: Colors.black45,
    );
  }
}