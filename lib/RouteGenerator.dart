import 'package:flutter/material.dart';
import 'Cadastro.dart';
import 'Configuracoes.dart';
import 'Login.dart';
import 'Mensagens.dart';
import 'MyApp.dart';
import 'model/Usuario.dart';

class RouteGenerator {


  static const String ROTA_HOME = "/myApp";
  static const String ROTA_LOGIN = "/login";
  static const String ROTA_CADASTRO = "/cadastro";
  static const String ROTA_CONFIG = "/configuracao";
  static const String ROTA_MENSAGENS = "/mensagens";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

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

      case ROTA_MENSAGENS:
        if (arguments is Usuario) {
          return MaterialPageRoute(builder: (context) => Mensagens(arguments));
        }
        return _rotaNaoEncontrada();

      default:
        return _rotaNaoEncontrada();
    }
  }

  static Route<dynamic> _rotaNaoEncontrada() {
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
