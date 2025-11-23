// lib/scr/models/pasta.dart

class Pasta {
  final String id;
  final String nome;

  Pasta({
    required this.id,
    required this.nome,
  });

  factory Pasta.fromJson(Map<String, dynamic> json) {
    return Pasta(
      id: json['_id'],
      nome: json['nome'],
    );
  }
}
