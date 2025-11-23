// lib/scr/models/materia.dart

class Materia {
  final String id;
  final String nome;
  final double pesoProva;
  final double pesoTrabalho;
  final double mediaParaPassar;
  final double notaMaxima;

  Materia({
    required this.id,
    required this.nome,
    required this.pesoProva,
    required this.pesoTrabalho,
    required this.mediaParaPassar,
    required this.notaMaxima,
  });

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['_id'],
      nome: json['nome'],
      pesoProva: (json['pesoProva'] as num).toDouble(),
      pesoTrabalho: (json['pesoTrabalho'] as num).toDouble(),
      mediaParaPassar: (json['mediaParaPassar'] as num).toDouble(),
      notaMaxima: (json['notaMaxima'] as num).toDouble(),
    );
  }
}
