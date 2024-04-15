import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/Usuario.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _emailUsuario = "";

  Future<void> _recuperarDadosUsuario() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? usuarioLogado = auth.currentUser;
      Usuario user = Usuario.nulo();

      _emailUsuario = usuarioLogado?.email ?? "";

    } catch (e) {
      print("Erro ao recuperar dados do usuário: $e");
      // Tratar o erro de acordo com a necessidade do seu aplicativo
    }
  }

  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Color(0xff075e54),
        title: const Text("WhatsApp", style: TextStyle(color: Colors.white,fontSize: 25)),
      ),
      body: Container(

        child: Text(_emailUsuario,style: const TextStyle(color: Color(0xff075e54), fontSize: 20),),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void _logarUsuario(User user) {
    // Implemente a lógica de login aqui
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Simulando login de usuário
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                _logarUsuario(user);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              }
            } catch (e) {
              print("Erro ao efetuar login: $e");
              // Tratar o erro de acordo com a necessidade do seu aplicativo
            }
          },
          child: const Text("Logar"),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: LoginPage(),
  ));
}
