import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zapzap/tabs/TabsContato.dart';
import 'package:zapzap/tabs/TabsConversas.dart';

import 'Login.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> itemMenu = ["Configurações", "Deslogar"];

  Future<void> _recuperarDadosUsuario() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? usuarioLogado = auth.currentUser;
    } catch (e) {
      print("Erro ao recuperar dados do usuário: $e");
      // Tratar o erro de acordo com a necessidade do seu aplicativo
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    _tabController = TabController(length: 2, vsync: this);
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Configurações":
        print("item escolhido" + itemEscolhido);
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff075e54),
        title: const Text("WhatsApp",
            style: TextStyle(color: Colors.white, fontSize: 25)),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(
              child: Text(
                "Conversas",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Contato",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) {
              return itemMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(controller: _tabController, children: [
        TabsConversas(),
        TabsContato(),
      ]),
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
