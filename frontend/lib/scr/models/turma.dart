// lib/scr/models/turma.dart
import 'serie.dart';

class Turma {
  final String id;
  final String nome;
  final Serie? serie;

  Turma({
    required this.id,
    required this.nome,
    this.serie,
  });

  factory Turma.fromJson(Map<String, dynamic> json) {
    return Turma(
      id: json['_id'],
      nome: json['nome'],
      serie: json['serie'] != null ? Serie.fromJson(json['serie']) : null,
    );
  }
}
