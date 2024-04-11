class Usuario {
  String _nome = "";
  String _email = "";
  String _senha = "";



  Usuario({required String email, required String senha}) {
    _email = email;
    _senha = senha;
  }

  Usuario.comNome({required String nome, required String email, required String senha}) {
    _nome = nome;
    _email = email;
    _senha = senha;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}
