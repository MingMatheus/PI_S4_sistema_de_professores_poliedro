// lib/scr/models/aluno.dart
import 'turma.dart';

class Aluno {
  final String id;
  final String nome;
  final String ra;
  final Turma? turma;

  Aluno({
    required this.id,
    required this.nome,
    required this.ra,
    this.turma,
  });

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['_id'],
      nome: json['nome'],
      ra: json['ra'],
      turma: json['turma'] != null ? Turma.fromJson(json['turma']) : null,
    );
  }
}
