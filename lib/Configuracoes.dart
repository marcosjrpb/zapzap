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
  late File? _imagem;
  late String usuarioLogado;

  Future<File?> _recuperarImagem(String tipo) async {
    late File? imagemSelecionada;

    switch (tipo) {
      case "camera":
        imagemSelecionada =
        await ImagePicker().pickImage(source: ImageSource.camera) as File?;
        break;
      case "galeria":
        imagemSelecionada =
        await ImagePicker().pickImage(source: ImageSource.gallery) as File?;
        break;
      default:
        throw ArgumentError('erro na imagem!: $tipo');
    }

    setState(() {
      _imagem = imagemSelecionada;
      if (_imagem != null) {
        _uploadImagem();
      }
    });
  }

  Future<void> _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference =
    FirebaseStorage.instance.ref().child("perfil").child("$usuarioLogado.jpg");

    // Enviar a imagem para o Firebase Storage
    await storageReference.putFile(_imagem!);
  }

  Future<void> _recuperarDadosUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    setState(() {
      usuarioLogado = user!.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
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
                  onPressed: () async {
                    // Implemente a lógica para salvar as configurações
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
