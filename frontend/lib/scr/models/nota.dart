// lib/scr/models/nota.dart
import 'avaliacao.dart';

class Nota {
  final String id;
  final double notaObtida;
  final String alunoId;
  final Avaliacao avaliacao;

  Nota({
    required this.id,
    required this.notaObtida,
    required this.alunoId,
    required this.avaliacao,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      id: json['_id'],
      notaObtida: (json['notaObtida'] as num).toDouble(),
      alunoId: json['aluno'],
      avaliacao: Avaliacao.fromJson(json['avaliacao']),
    );
  }
}
