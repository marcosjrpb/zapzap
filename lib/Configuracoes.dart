import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final TextEditingController _controllerNome = TextEditingController();
  File? _imagem;
  late String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _urlImagemRecuperada = "";

  @override
  void initState() {
    super.initState();
    _recuperardadosUsuario();
  }

  Future<void> _recuperardadosUsuario() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _idUsuarioLogado = user.uid;
        });

        FirebaseFirestore db = FirebaseFirestore.instance;
        DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(_idUsuarioLogado).get();
        Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
        _controllerNome.text = dados?["nome"] ?? "";
        _urlImagemRecuperada = dados?["urlImagem"] ?? "";
      }
    } catch (e) {
      _mostrarErro("Erro ao obter usuário logado: $e");
    }
  }

  Future<void> _recuperarImagem(ImageSource tipo) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: tipo);

      if (pickedFile != null) {
        setState(() {
          _subindoImagem = true;
          _imagem = File(pickedFile.path);
        });
      }
    } catch (e) {
      _mostrarErro("Erro ao recuperar imagem: $e");
    }
    setState(() {
      if( _imagem != null ){
        _subindoImagem = true;
        _uploadImagem();
      }
    });

  }

  Future<void> _uploadImagem() async {
    try {
      if (_imagem != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference =
        storage.ref().child("perfil").child("$_idUsuarioLogado.jpg");

        UploadTask task = storageReference.putFile(_imagem!);

        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          print('Progresso do upload: $progress');

          switch (snapshot.state) {
            case TaskState.running:
              setState(() {
                _subindoImagem = true;
              });
              print('Upload em progresso...');
              break;
            case TaskState.success:
              setState(() {
                _subindoImagem = false;
              });
              print('Upload concluído com sucesso!');
              _mostrarMensagem('Upload concluído com sucesso!');
              _recuperarUrlImagem(snapshot);
              break;
            case TaskState.error:
              setState(() {
                _subindoImagem = false;
              });
              print('Erro durante o upload: ${TaskState.error}');
              _mostrarErro('Erro durante o upload: ${TaskState.error}');
              break;
            default:
              break;
          }
        });
      }
    } catch (e) {
      _mostrarErro('Erro durante o upload: $e');
      setState(() {
        _subindoImagem = false;
      });
    }
  }

  Future<void> _recuperarUrlImagem(TaskSnapshot snapshot) async {
    try {
      String url = await snapshot.ref.getDownloadURL();
      _atualizarUrlImagemFireStore(url);

      setState(() {
        _urlImagemRecuperada = url;
      });
    } catch (e) {
      _mostrarErro('Erro ao recuperar URL da imagem: $e');
    }
  }

  _atualizarUrlImagemFireStore(String url) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic> dadosAtualizar = {"urlImagem": url};
    firestore
        .collection("usuarios")
        .doc(_idUsuarioLogado)
        .update(dadosAtualizar);
  }

  Future<void> _atualizarNomeFirestore() async {
    String nome = _controllerNome.text;
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> dadosAtualizar = {"nome": nome};
      await firestore
          .collection("usuarios")
          .doc(_idUsuarioLogado)
          .update(dadosAtualizar);
      _mostrarMensagem("Nome atualizado com sucesso!");
    } catch (e) {
      _mostrarErro("Erro ao atualizar nome de usuário: $e "+_idUsuarioLogado);
    }
  }


  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  void _mostrarErro(String erro) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(erro),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        color: Color(0xFF004D40),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child:
                  _subindoImagem
                      ? CircularProgressIndicator()
                      : SizedBox(),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 130,
                      backgroundColor: Colors.green[400],
                      backgroundImage:
                      _urlImagemRecuperada != null
                          ? NetworkImage(_urlImagemRecuperada)
                          : null,
                      child: _imagem != null
                          ? null
                          : SizedBox(
                        width: 160,
                        height: 160,
                        // child: Image(
                        //   image: AssetImage('imagens/usuario.png'),
                        //   fit: BoxFit.contain,
                        // ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await _recuperarImagem(ImageSource.camera);
                      },
                      icon: Icon(Icons.camera_alt, size: 50),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () async {
                        await _recuperarImagem(ImageSource.gallery);
                      },
                      icon: Icon(Icons.photo, size: 50),
                      color: Colors.green,
                    ),
                  ],
                ),
                TextField(
                  controller: _controllerNome,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  // onChanged: (texto){
                  //   _atualizarNomeFirestore(texto);
                  // },
                  decoration: InputDecoration(
                    labelText: "Nome",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ElevatedButton(
                  onPressed: () {

                    String novoNome = _controllerNome.text.trim();
                    if (novoNome.isNotEmpty) {
                      _atualizarNomeFirestore();
                    } else {
                      _mostrarErro("O nome não pode estar vazio.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    backgroundColor: Colors.green,
                    elevation: 8,
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
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
