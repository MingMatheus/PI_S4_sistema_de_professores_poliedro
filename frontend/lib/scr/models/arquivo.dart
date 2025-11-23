// lib/scr/models/arquivo.dart
import '../utils/url.dart';

class Arquivo {
  final String id;
  final String nomeOriginal;
  final String url;
  final String tipo; // mimetype
  final int tamanho;
  final DateTime createdAt;
  final String nomeProfessor;

  Arquivo({
    required this.id,
    required this.nomeOriginal,
    required this.url,
    required this.tipo,
    required this.tamanho,
    required this.createdAt,
    required this.nomeProfessor,
  });

  factory Arquivo.fromJson(Map<String, dynamic> json) {
    // Constrói a URL completa no cliente
    final relativeUrl = json['url'] as String? ?? '';
    final fullUrl = getApiBaseUrl() + relativeUrl;

    return Arquivo(
      id: json['_id'],
      nomeOriginal: json['nomeOriginal'],
      url: fullUrl,
      tipo: json['tipo'],
      tamanho: json['tamanho'],
      createdAt: DateTime.parse(json['createdAt']),
      nomeProfessor: (json['professorQueFezOUpload'] as Map<String, dynamic>)['nome'] ?? 'Desconhecido',
    );
  }
}
