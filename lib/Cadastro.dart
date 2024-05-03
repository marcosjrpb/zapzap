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

  bool _visualizouRetorno = false;

  Future<String?> _validarCampos() async {
    String nome = _controllerNome.text.trim();
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text.trim();

    RegExp regexEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    RegExp regexSenha = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

    if (nome.isEmpty || nome.length <= 4) {
      return "Nome deve conter mais de 4 caracteres.";
    } else if (email.isEmpty || !regexEmail.hasMatch(email)) {
      return "E-mail inválido.";
    } else if (senha.isEmpty || senha.length <= 7 || !regexSenha.hasMatch(senha)) {
      return "Senha deve conter pelo menos 8 caracteres, incluindo letras e números.";
    }

    Usuario user = Usuario.cad(nome: nome, email: email, senha:senha);
    String? uid = await _cadastrarUsuario(user);
    if (uid != null) {
      await _retornoBdFirebase(user, uid);
      return "Sucesso";
    } else {
      return "Erro ao cadastrar usuário.";
    }
  }

  Future<String?> _cadastrarUsuario(Usuario user) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.senha,
      );

      return userCredential.user?.uid;
    } on FirebaseAuthException catch (error) {
      String errorMessage = "Erro no cadastro: ${error.message}";
      _mensagemErro(errorMessage);
      print(errorMessage);
      return null;
    }
  }

  Future<void> _retornoBdFirebase(Usuario user, String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('usuarios').doc(uid).set({
      'nome': user.nome,
      'email': user.email,
    });

    _mensagemSucessoBd("Dados cadastrados, "
        "\n Nome:  ${user.nome}"
        "\n E-mail:  ${user.email}"
        "\n Senha: ${user.senha} ");

    _limparCampos();
    setState(() {
      _visualizouRetorno = true;
    });
  }

  void _limparCampos() {
    _controllerNome.clear();
    _controllerSenha.clear();
    _controllerEmail.clear();
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
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
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
        backgroundColor: const Color(0xFF004D40),
        title: const Text(
          "Cadastro",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF075E54)),
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              50,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/usuario.png",
                    width: 180,
                    height: 130,
                  ),
                ),
                TextField(
                  controller: _controllerNome,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "Nome",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20),
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
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "Senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    String? mensagem = await _validarCampos();
                    if (mensagem == "Sucesso") {
                      // Cadastro realizado com sucesso
                    } else {
                      _mostrarDialogo("Erro", mensagem ?? "Erro desconhecido.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
                if (_mensagem != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _mensagem!,
                            style: const TextStyle(color: Colors.white,fontSize: 20),
                          ),
                        ),
                      ],
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
