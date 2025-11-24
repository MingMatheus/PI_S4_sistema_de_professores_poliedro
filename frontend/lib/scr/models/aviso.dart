// lib/scr/models/aviso.dart

class Aviso {
  final String id;
  final String titulo;
  final String conteudo;
  final String nomeAutor;
  final DateTime createdAt;
  final List<Map<String, dynamic>> seriesAlvo;
  final List<Map<String, dynamic>> turmasAlvo;
  final List<Map<String, dynamic>> alunosAlvo;

  Aviso({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.nomeAutor,
    required this.createdAt,
    required this.seriesAlvo,
    required this.turmasAlvo,
    required this.alunosAlvo,
  });

  static List<Map<String, dynamic>> _convertAlvos(List<dynamic> alvos) {
    if (alvos.isEmpty) {
      return [];
    }
    if (alvos.first is String) {
      return alvos.map((id) => {'_id': id as String}).toList();
    }
    return List<Map<String, dynamic>>.from(alvos);
  }

  factory Aviso.fromJson(Map<String, dynamic> json) {
    return Aviso(
      id: json['_id'],
      titulo: json['titulo'],
      conteudo: json['conteudo'],
      nomeAutor:
          (json['autor'] as Map<String, dynamic>?)?['nome'] ?? 'Desconhecido',
      createdAt: DateTime.parse(json['createdAt']),
      seriesAlvo: _convertAlvos(json['seriesAlvo'] ?? []),
      turmasAlvo: _convertAlvos(json['turmasAlvo'] ?? []),
      alunosAlvo: _convertAlvos(json['alunosAlvo'] ?? []),
    );
  }
}
