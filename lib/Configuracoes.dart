
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
  late File? _imagem = null;
  late String usuarioLogado = "";
  bool _subindoImagem = false;

  Future<void> _recuperarImagem(String tipo) async {
     final picker = ImagePicker();

    final source = tipo == "camera" ?
    ImageSource.camera :
    ImageSource.gallery;

    final pickedFile = await picker.pickImage( source: source);

    if (pickedFile != null) {
      setState(() {
        _subindoImagem = true;
        _imagem = File(pickedFile.path);
        _uploadImagem();
      });
    }
  }


  Future<void> _uploadImagem() async {
    if (_imagem != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference =
      storage.ref().child("perfil").child("$usuarioLogado.jpg");

      // Enviar a imagem para o Firebase Storage
      UploadTask task = storageReference.putFile(_imagem!);
// todo preciso entender porque nao esta enviando para Fire
      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        // Aqui você pode lidar com os eventos do upload
        // Por exemplo, você pode atualizar a interface do usuário com o progresso do upload
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Progresso do upload: $progress');

        switch (snapshot.state) {
          case TaskState.running:
            _subindoImagem = true;
            print('Upload em progresso...');
            break;
          case TaskState.success:
            _subindoImagem = false;
            print('Upload concluído com sucesso!');
            // Aqui você pode adicionar lógica adicional para o que fazer após o upload bem-sucedido
            break;
          case TaskState.error:

          // marcosjrpbSe houver um erro, obtemos o erro a partir de task.snapshot.error
           // print('Erro durante o upload: ${task.snapshot.error}');
            // Aqui você pode lidar com o erro de upload, seja exibindo uma mensagem de erro ou tentando novamente
            break;
          default:
          // Outros estados, se necessário
            break;
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                  _subindoImagem? CircularProgressIndicator():Container(),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.green,
                  backgroundImage: _imagem != null ? FileImage(_imagem!) : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text("Câmera"),
                      onPressed: () async {
                        await _recuperarImagem("camera");
                      },
                    ),
                    TextButton(
                      child: Text("Galeria"),
                      onPressed: () async {
                        await _recuperarImagem("galeria");
                      },
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
                ElevatedButton(
                  onPressed: () {
                    _recuperarImagem("camera");
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
