import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/Usuario.dart';

class TabsContatos extends StatefulWidget {
  const TabsContatos({Key? key}) : super(key: key);

  @override
  State<TabsContatos> createState() => _TabsContatosState();
}

class _TabsContatosState extends State<TabsContatos> {
  late List<Usuario> listaUsuarios;

  @override
  void initState() {
    super.initState();
    listaUsuarios = [];
  }

  Future<List<Usuario>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Usuario> listaUsuarios = [];

    try {
      QuerySnapshot querySnapshot = await db.collection("usuarios").get();

      for (DocumentSnapshot documento in querySnapshot.docs) {
        var dados = documento.data() as Map<String, dynamic>;

        String email = dados["email"] ?? "";
        String nome = dados["nome"] ?? "";

        if (nome.isNotEmpty) {
          String imagem = dados["urlImagem"] ?? "";

          Usuario usuario = Usuario.contato(
            nome: nome,
            email: email,// Corrigindo para nome
            imagem: imagem,
          );

          listaUsuarios.add(usuario);
        }
      }
    } catch (e) {
      print("Erro ao recuperar contatos: $e");
      // Se ocorrer um erro, retorna uma lista vazia
      return [];
    }

    // Verifica se a lista de usuários não é nula antes de retorná-la
    return listaUsuarios.isNotEmpty ? listaUsuarios : [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Text("Erro ao carregar contatos"),
              );
            }

            listaUsuarios = snapshot.data ?? [];

            return ListView.builder(
              itemCount: listaUsuarios.length,
              itemBuilder: (context, index) {
                Usuario usuario = listaUsuarios[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: usuario.imagem != null ? DecorationImage(
                          image: NetworkImage(usuario.imagem!),
                          fit: BoxFit.cover,
                        ) : null,
                      ),
                    ),
                    title: Text(
                      usuario.nome,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      usuario.email,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                );



              },
            );

        }
      },
    );
  }
}
