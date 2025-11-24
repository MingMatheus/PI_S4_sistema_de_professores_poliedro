// lib/scr/models/serie.dart

class Serie {
  final String id;
  final String nome;

  Serie({
    required this.id,
    required this.nome,
  });

  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      id: json['_id'],
      nome: json['nome'],
    );
  }
}
