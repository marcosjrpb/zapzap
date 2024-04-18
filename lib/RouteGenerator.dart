import 'package:flutter/material.dart';
import 'package:zapzap/Configuracoes.dart';
import 'Cadastro.dart';
import 'MyApp.dart';
import 'Login.dart';

class RouteGenerator {
  static const String ROTA_HOME = "/myApp";
  static const String ROTA_LOGIN = "/login";
  static const String ROTA_CADASTRO = "/cadastro";
  static const String ROTA_CONFIG = "/configuracao";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const Login());

      case ROTA_HOME:
        return MaterialPageRoute(builder: (context) => const MyApp());

      case ROTA_LOGIN:
        return MaterialPageRoute(builder: (context) => const Login());

      case ROTA_CADASTRO:
        return MaterialPageRoute(builder: (context) => const Cadastro());

      case ROTA_CONFIG:
        return MaterialPageRoute(builder: (context) => const Configuracoes());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text(
                "Tela não encontrada!",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: const Center(
              child: Text('Rota não encontrada!'),
            ),
          ),
        );
    }
  }
}
