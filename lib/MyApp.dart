import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _emailUsuario = "";

  Future<void> _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    setState(() {
      _emailUsuario = usuarioLogado?.email ?? "";
    });
  }

  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
      ),
      body: Container(
        child: Text(_emailUsuario),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
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
        title: Text("Login"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Simulando login de usuário
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              _logarUsuario(user);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            }
          },
          child: Text("Logar"),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
