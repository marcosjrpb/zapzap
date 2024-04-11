import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zapzap/Cadastro.dart';
import 'package:zapzap/MyApp.dart';

import 'model/Usuario.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  Future<void> _validarCampos() async {
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text.trim();

    RegExp regexEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    RegExp regexSenha = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

    if (email.isEmpty || !regexEmail.hasMatch(email)) {
      setState(() {
        _mensagemErro = "E-mail inválido.";
      });
      return;
    } else if (senha.isEmpty || senha.length <= 7 || !regexSenha.hasMatch(senha)) {
      setState(() {
        _mensagemErro = "Senha deve conter pelo menos 8 caracteres, incluindo letras e números.";
      });
      return;
    }

    Usuario user = Usuario(email: email, senha: senha);
    _logarUsuario(user);
  }

  void _logarUsuario(Usuario user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
      email: user.email!,
      password: user.senha!,
    ).then((firebaseUser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }).catchError((error) {
      setState(() {
        _mensagemErro = "Erro de autenticação!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075e54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail: ",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerSenha,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha: ",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _validarCampos();
                    },
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Não tem conta? Cadastre-se!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cadastro()),
                    );
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 16)),
                Text(
                  _mensagemErro,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
