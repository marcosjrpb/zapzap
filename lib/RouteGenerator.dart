import 'package:flutter/material.dart';
import 'Cadastro.dart';
import 'MyApp.dart';
import 'Login.dart';

class RouteGenerator {

   static const String ROTA_HOME = "/myApp";
   static const String ROTA_LOGIN ="/login";
   static const String ROTA_CADASTRO="/cadastro";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Login());

      case ROTA_HOME:
        return MaterialPageRoute(builder: (context) => MyApp());

      case ROTA_LOGIN :
        return MaterialPageRoute(builder: (context) => Login());

      case ROTA_CADASTRO:
        return MaterialPageRoute(builder: (context) => Cadastro());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text("Tela não encontrada!",
              style:
              TextStyle(color: Colors.white),
            ),),
            body: Center(
              child: Text('Rota não encontrada!'),
            ),
          ),
        );
    }
  }
}
