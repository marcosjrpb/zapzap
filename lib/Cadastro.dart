import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zapzap/model/Usuario.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  String? _mensagem;

  Future<bool> _validarCampos() async {
    String nome = _controllerNome.text.trim();
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text.trim();

    RegExp regexEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    RegExp regexSenha = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

    if (nome.isNotEmpty &&
        nome.length > 4 &&
        email.isNotEmpty &&
        senha.isNotEmpty &&
        senha.length > 7 && // Ajuste para senha de 8 caracteres ou mais
        regexEmail.hasMatch(email) &&
        regexSenha.hasMatch(senha)) {
      Usuario user = Usuario(email: email, senha: senha);
      return await _cadastrarUsuario(user);
    } else {
      _mensagemErro("Por favor, preencha todos os campos corretamente.");
      return false;
    }
  }

  Future<bool> _cadastrarUsuario(Usuario user) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.senha,
      );
      _mensagemSucesso("Cadastro realizado com sucesso!");
      await _retornoBdFirebase(
          user); // Chamada para a função de retorno do banco de dados
      return true;
    } on FirebaseAuthException catch (error) {
      String errorMessage = "Erro no cadastro: ${error.message}";
      _mensagemErro(errorMessage);
      print(errorMessage);
      return false;
    }
  }

  Future<bool> _retornoBdFirebase(Usuario user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('usuarios').add({
      'nome': user.nome,
      'email': user.email,
    });
    // Após inserir os dados no banco, você pode exibir uma mensagem abaixo do botão de cadastro.
    _mensagemSucessoBd("Dados cadastrados, "
        "\n E-mail:  ${user.email}"
        "\n Senha: ${user.senha} ");
    return true;
  }

  void _mensagemErro(String errorMessage) {
    _mostrarDialogo("Erro", errorMessage);
  }

  void _mensagemSucesso(String successMessage) {
    _mostrarDialogo("Sucesso", successMessage);
  }

  void _mensagemSucessoBd(String successMessage) {
    setState(() {
      _mensagem = successMessage;
    });
  }

  void _mostrarDialogo(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004D40),
        title: Text(
          "Cadastro",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF075E54)),
        padding: EdgeInsets.all(16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              50,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/usuario.png",
                    width: 180,
                    height: 130,
                  ),
                ),
                TextField(
                  controller: _controllerNome,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "Nome",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "Senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (await _validarCampos()) {
                      // Se a validação dos campos for bem-sucedida,
                      // não é necessário mostrar outro diálogo de sucesso aqui,
                      // pois o método _validarCampos() já cuida disso.
                    }
                  },
                  child: Text(
                    "Cadastrar",
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
                if (_mensagem != null)
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      _mensagem!,
                      style: TextStyle(color: Colors.white),
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
