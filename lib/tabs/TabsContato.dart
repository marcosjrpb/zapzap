import 'package:flutter/material.dart';

import '../model/Conversa.dart';

class TabsContato extends StatefulWidget {
  const TabsContato({Key? key}) : super(key: key);

  @override
  State<TabsContato> createState() => _TabsContatoState();
}

class _TabsContatoState extends State<TabsContato> {
  late String _hour;

  late List<Conversa> listConversa;

  @override
  void initState() {
    super.initState();
    _hour = DateTime.now().hour.toString();

    listConversa = [
      Conversa.parcial(
        nome: "Marcos Jr",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Ffile.jpg?alt=media&token=be9086d5-0630-45c7-a105-ef4480e994f3",
      ),
      Conversa.parcial(
        nome: "Lucas",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=4ff9d3e3-5719-462f-a915-8419e68f6d91",
      ),
      Conversa.parcial(
        nome: "Tania ",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=b2851b22-8d8a-473e-88ac-674a1e683a7e",
      ),
      Conversa.parcial(
        nome: "Jamiltom",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=761917a6-cb9c-4ff1-b412-f57d6f118079",
      ),
      Conversa.parcial(
        nome: "Pedro",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=7ebc5127-c1e1-428b-9a70-5e56ab66da31",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listConversa.length,
      itemBuilder: (context, index) {
        final conversa = listConversa[index];
        return ListTile(
          leading: CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.green,
            backgroundImage: NetworkImage(conversa.caminhoFoto),
          ),
          title: Text(
            conversa.nome,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            (conversa.mensagem) + ' ' + (conversa.horas),
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
            ),
          ),

          // Aquí puedes agregar más contenido de conversación si lo deseas
        );
      },
    );
  }
}
