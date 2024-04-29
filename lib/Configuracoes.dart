import 'dart:io';

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
  late String usuarioLogado = "";
  bool _subindoImagem = false;

  @override
  void initState() {
    super.initState();
    _obterUsuarioLogado();
  }

  Future<void> _obterUsuarioLogado() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        usuarioLogado = user.uid;
      });
    }
  }

  Future<void> _recuperarImagem(String tipo) async {
    final picker = ImagePicker();
    final source = tipo == "camera" ? ImageSource.camera : ImageSource.gallery;
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _subindoImagem = true;
        _imagem = File(pickedFile.path);
      });
      await _uploadImagem();
    }
  }

  Future<void> _uploadImagem() async {
    try {
      if (_imagem != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference =
        storage.ref().child("perfil").child("$usuarioLogado.jpg");

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
              break;
            case TaskState.error:
              setState(() {
                _subindoImagem = false;
              });
              print('Erro durante o upload: ${TaskState.error}');
              _mostrarMensagem('Erro durante o upload: ${TaskState.error}');
              break;
            default:
              break;
          }
        });
      }
    } catch (e) {
      print('Erro durante o upload: $e');
      _mostrarMensagem('Erro durante o upload: $e');
      setState(() {
        _subindoImagem = false;
      });
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
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
                _subindoImagem ? CircularProgressIndicator() : SizedBox(),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.green[100],
                      backgroundImage: _imagem != null
                          ? FileImage(_imagem!)
                          : null,
                      child: _imagem != null
                          ? null
                          : SizedBox(
                        width: 120,
                        height: 120,
                        child: Image(
                          image: AssetImage('imagens/usuario.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),




                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await _recuperarImagem("camera");
                      },
                      icon: Icon(Icons.camera_alt, size: 50),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () async {
                        await _recuperarImagem("galeria");
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
                    _uploadImagem();
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
