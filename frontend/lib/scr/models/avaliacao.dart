// lib/scr/models/avaliacao.dart
import 'materia.dart';

enum TipoAvaliacao {
  prova,
  trabalho,
}

class Avaliacao {
  final String id;
  final String nome;
  final double peso;
  final TipoAvaliacao tipo;
  final Materia materia;
  final double notaMaxima;

  Avaliacao({
    required this.id,
    required this.nome,
    required this.peso,
    required this.tipo,
    required this.materia,
    required this.notaMaxima,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['_id'],
      nome: json['nome'],
      peso: (json['peso'] as num? ?? 1.0).toDouble(), // Add null check for safety
      tipo: json['tipo'] == 'prova' ? TipoAvaliacao.prova : TipoAvaliacao.trabalho,
      materia: Materia.fromJson(json['materia']),
      notaMaxima: (json['notaMaxima'] as num? ?? 10.0).toDouble(), // Add null check
    );
  }
}
