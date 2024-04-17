import 'package:flutter/material.dart';

class Conversa {
  String _nome = "";
  String _mensagem = "";
  String _caminhoFoto = "";
  String _horas = "";

  String get nome => _nome;
  String get horas => _horas;
  String get caminhoFoto => _caminhoFoto;
  String get mensagem => _mensagem;

  Conversa.parcial({
    required String nome,
    required String caminhoFoto,
  })  : _nome = nome,
        _caminhoFoto = caminhoFoto;

  Conversa.completo({
    required String nome,
    required String mensagem,
    required String caminhoFoto,
    required String horas,
  })  : _nome = nome,
        _mensagem = mensagem,
        _caminhoFoto = caminhoFoto,
        _horas = horas;

  set nome(String value) {
    _nome = value;
  }

  set horas(String value) {
    _horas = value;
  }

  set caminhoFoto(String value) {
    _caminhoFoto = value;
  }

  set mensagem(String value) {
    _mensagem = value;
  }
}
