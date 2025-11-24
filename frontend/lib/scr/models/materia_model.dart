class Materia {
  final String? id;
  final String nome;
  final double pesoProva;
  final double pesoTrabalho;
  final double mediaParaPassar;
  final double notaMaxima;

  Materia({
    this.id,
    required this.nome,
    required this.pesoProva,
    required this.pesoTrabalho,
    required this.mediaParaPassar,
    required this.notaMaxima,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'pesoProva': pesoProva,
      'pesoTrabalho': pesoTrabalho,
      'mediaParaPassar': mediaParaPassar,
      'notaMaxima': notaMaxima,
    };
  }

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
