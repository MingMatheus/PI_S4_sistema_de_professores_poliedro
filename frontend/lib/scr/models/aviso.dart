// lib/scr/models/aviso.dart

class Aviso {
  final String id;
  final String titulo;
  final String conteudo;
  final String nomeAutor;
  final DateTime createdAt;

  Aviso({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.nomeAutor,
    required this.createdAt,
  });

  factory Aviso.fromJson(Map<String, dynamic> json) {
    return Aviso(
      id: json['_id'],
      titulo: json['titulo'],
      conteudo: json['conteudo'],
      // O autor é populado no backend e vem como um objeto
      nomeAutor: (json['autor'] as Map<String, dynamic>)['nome'] ?? 'Desconhecido',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
