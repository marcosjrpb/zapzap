import 'package:flutter/material.dart';
class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  final TextEditingController _controllerNome = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configucrações"),

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
                  backgroundImage: NetworkImage
                    ( "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Ffile.jpg?alt=media&token=be9086d5-0630-45c7-a105-ef4480e994f3"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text("Câmera"),
                      onPressed: () {
                      },
                    ),
                    TextButton(
                      child: Text("Galeria"),
                      onPressed: () {
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
                    //String? mensagem = await _validarCampos();
                    // if (mensagem == "Sucesso") {
                    //
                    // } else {
                    // //  _mostrarDialogo("Erro", mensagem ?? "Erro desconhecido.");
                    // }
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
