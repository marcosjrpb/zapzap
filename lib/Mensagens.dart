import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/Usuario.dart';

class Mensagens extends StatefulWidget {
  final Usuario contato;

  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  List<String> listaMensagens = [
    "Olá meu amigo, tudo bem?",
    "Tudo ótimo!!! e contigo?",
    "Estou muito bem!! queria ver uma coisa contigo, você vai na corrida de sábado?",
    "Não sei ainda :(",
    "Pq se você fosse, queria ver se posso ir com você...",
    "Posso te confirma no sábado? vou ver isso",
    "Opa! tranquilo",
    "Excelente!!",
    "Estou animado para essa corrida, não vejo a hora de chegar! ;) ",
    "Vai estar bem legal!! muita gente",
    "vai sim!",
    "Lembra do carro que tinha te falado",
    "Que legal!!"
  ];
  TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem() {
    // Implemente a lógica para enviar a mensagem aqui
  }
  _enviarFoto(){

  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMensagem,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 16),

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  labelText: "Digite uma mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.camera_alt_outlined,color:  Color(0xff075e54)),
                    onPressed: _enviarFoto,
                  ),

                ),
              ),


            ),
          ),
          Container(
            width: 46, // Ajuste conforme desejado
            height: 50, // Ajuste conforme desejado
            child: FloatingActionButton(
              backgroundColor: const Color(0xff075e54),
              mini: true, // Define como um FAB miniatura
              child: Icon(Icons.send, color: Colors.white), // Ícone padrão
              onPressed: _enviarMensagem,
            ),
          ),

        ],
      ),
    );
  var listView = Expanded(
      child: ListView.builder(
        itemCount: listaMensagens.length,
          itemBuilder: (context, indice){

            return Align(
              alignment: Alignment.centerRight,
              child: Padding(padding: EdgeInsets.all(6),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xffd2ffa5),
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: Text(listaMensagens[indice],style: TextStyle(fontSize: 18),),
              ),
              ),
            );
          }

      ),
  );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff075e54),
        leading: Container(
          margin: EdgeInsets.only(left: 5),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(widget.contato.imagem),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.teal,
              width: 2,
            ),
          ),
        ),
        title: Text(
          widget.contato.nome,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Container(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("imagens/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                listView,
                caixaMensagem,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
