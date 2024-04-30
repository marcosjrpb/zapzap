import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Prefixo para diferenciar os tipos ImageSource dos pacotes diferentes
import 'package:image_picker_platform_interface/src/types/image_source.dart'
as platform;

// Constantes para tipos de imagem
enum ImageSource { camera, gallery }

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
  late String _urlImagemRecuperada;

  @override
  void initState() {
    super.initState();
    _obterUsuarioLogado();
  }

  Future<void> _obterUsuarioLogado() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _idUsuarioLogado = user.uid;
        });
      }
    } catch (e) {
      _mostrarErro("Erro ao obter usuário logado: $e");
    }
  }

  Future<void> _recuperarImagem(ImageSource tipo) async {
    final picker = ImagePicker();
    final source = tipo == ImageSource.camera
        ? platform.ImageSource.camera // Usando o prefixo para diferenciar os tipos
        : platform.ImageSource.gallery;
    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _subindoImagem = true;
          _imagem = File(pickedFile.path);
        });
      }
    } catch (e) {
      _mostrarErro("Erro ao recuperar imagem: $e");
    }
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

          _recuperarUrlImagem(snapshot);
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
      setState(() {
        _urlImagemRecuperada = url;
      });
    } catch (e) {
      _mostrarErro('Erro ao recuperar URL da imagem: $e');
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
                _subindoImagem ? CircularProgressIndicator() : SizedBox(),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 130,
                      backgroundColor: Colors.green[100],
                      backgroundImage:
                      _imagem != null ? FileImage(_imagem!) : null,
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
                    // Adicione aqui a lógica para atualizar o nome do usuário
                    _atualizarNomeUsuario();
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

  void _atualizarNomeUsuario() async {
    String novoNome = _controllerNome.text.trim();
    if (novoNome.isNotEmpty) {
      try {
        await _uploadImagem();
        // Limpar o TextField e o CircleAvatar somente após o upload da imagem ser concluído
        _controllerNome.clear();
        setState(() {
          _imagem = null;
        });
      } catch (e) {
        _mostrarErro("Erro ao atualizar nome de usuário: $e");
      }
    } else {
      _mostrarErro("O nome não pode estar vazio.");
    }
  }
}
