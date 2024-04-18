import 'package:flutter/material.dart';

import '../model/Conversa.dart';

class TabsConversas extends StatefulWidget {
  const TabsConversas({super.key});

  @override
  State<TabsConversas> createState() => _TabsConversasState();
}

class _TabsConversasState extends State<TabsConversas> {
  late String _hour;

  late List<Conversa> listConversa;

  @override
  void initState() {
    super.initState();
    _hour = DateTime.now().hour.toString();

    listConversa = [
      Conversa.completo(
        nome: "Marcos Jr",
        mensagem: "Ola tudo bem?",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Ffile.jpg?alt=media&token=be9086d5-0630-45c7-a105-ef4480e994f3",
        horas: _hour,
      ),
      Conversa.completo(
        nome: "Lucas",
        mensagem: "Estou Bem!",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=4ff9d3e3-5719-462f-a915-8419e68f6d91",
        horas: _hour,
      ),
      Conversa.completo(
        nome: "Tania ",
        mensagem: "Oi",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=b2851b22-8d8a-473e-88ac-674a1e683a7e",
        horas: _hour,
      ),
      Conversa.completo(
        nome: "Jamiltom",
        mensagem: "Ola tudo Vamos lá",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=761917a6-cb9c-4ff1-b412-f57d6f118079",
        horas: _hour,
      ),
      Conversa.completo(
        nome: "Pedro",
        mensagem: "Ola tudo bem?",
        caminhoFoto:
            "https://firebasestorage.googleapis.com/v0/b/zapzap-710df.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=7ebc5127-c1e1-428b-9a70-5e56ab66da31",
        horas: _hour,
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${conversa.mensagem} ${conversa.horas}',
            style: const TextStyle(
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
