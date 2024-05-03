class Usuario {
  String? _nome;
  String? _email;
  String? _senha;
  String? _imagem;


  Usuario.vazio();


  // Construtor padrão
  Usuario({
    required String nome,
    required String email,
    required String senha,
    required String imagem,
  })  : _nome = nome,
        _email = email,
        _senha = senha,
        _imagem = imagem;

  // Construtor para criar usuário sem a imagem
  Usuario.cad({
    required String nome,
    required String email,
    required String senha,
  })  : _nome = nome,
        _email = email,
        _senha = senha;

  Usuario.contato({
    required String imagem,
    required String email,
    required String nome,
  })  : _imagem = imagem,
        _email = email,
        _nome = nome;

  // Construtor nomeado para login
  Usuario.login(String email, String senha) {
    _email = email;
    _senha = senha;
  }

  // Métodos getters e setters
  String get nome => _nome ?? "";
  set nome(String value) {
    _nome = value;
  }

  String get email => _email ?? "";
  set email(String value) {
    _email = value;
  }

  String get senha => _senha ?? "";
  set senha(String value) {
    _senha = value;
  }

  String get imagem => _imagem ?? "";
  set imagem(String value) {
    _imagem = value;
  }

  // Método para converter usuário em um mapa
  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "email": email,
      "senha": senha,
      "imagem": imagem,
    };
  }
}
