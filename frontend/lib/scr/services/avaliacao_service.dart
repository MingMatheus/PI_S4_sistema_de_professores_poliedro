// lib/src/services/avaliacao_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class AvaliacaoService {
  // Bate com o back-end: app.use("/api/avaliacoes", avaliacaoRoutes)
  static const String basePath = '/api/avaliacoes';

  /// Mapeia o texto exibido na UI -> valor que o back espera no enum
  /// (provavelmente: "atividade", "trabalho", "prova", "outro")
  static const Map<String, String> _labelToEnum = {
    'Atividade': 'atividade',
    'Trabalho': 'trabalho',
    'Prova': 'prova',
    'Outro': 'outro',
  };

  /// Mapeia o valor salvo no banco -> texto exibido na UI
  static const Map<String, String> _enumToLabel = {
    'atividade': 'Atividade',
    'trabalho': 'Trabalho',
    'prova': 'Prova',
    'outro': 'Outro',
  };

  /// Converte JSON do back pra map usado na tela
  static Map<String, dynamic> _fromJsonToAtividadeMap(
      Map<String, dynamic> json) {
    final tipoEnum = json['tipo'] as String? ?? '';
    final tipoLabel = _enumToLabel[tipoEnum] ?? tipoEnum;

    return {
      'id': json['_id'],
      'titulo': json['nome'] ?? '',
      'turma': json['turma'] ?? '',
      'tipo': tipoLabel,
      'dataEntrega': json['dataEntrega'] ?? '',
      'descricao': json['descricao'] ?? '',
      'status': json['status'] ?? 'Aberta',
    };
  }

  static Future<List<Map<String, dynamic>>> listar() async {
    final http.Response resp = await ApiClient.get(basePath);

    if (resp.statusCode != 200) {
      throw Exception(
          'Status ${resp.statusCode}: ${resp.body}');
    }

    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    final list = (body['avaliacoes'] as List<dynamic>? ?? []);

    return list
        .cast<Map<String, dynamic>>()
        .map(_fromJsonToAtividadeMap)
        .toList();
  }

  static Future<Map<String, dynamic>> criar({
    required String titulo, // vem da tela
    required String tipo,   // "Atividade", "Prova", etc.
    String? turma,
    String? dataEntrega,
    String? descricao,
  }) async {
    // converte label da UI -> valor minúsculo do enum
    final tipoEnum = _labelToEnum[tipo] ?? tipo;

    final payload = {
      'nome': titulo,
      'tipo': tipoEnum,
      'turma': turma,
      'dataEntrega': dataEntrega,
      'descricao': descricao,
      'status': 'Aberta',
      'peso': 1,
      'notaMaxima': 10,
      // depois a gente adiciona 'materia': idDaMateriaSelecionada
    };

    final resp = await ApiClient.post(basePath, payload);

    if (resp.statusCode != 201) {
      throw Exception(
          'Status ${resp.statusCode}: ${resp.body}');
    }

    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    final json = body['avaliacao'] as Map<String, dynamic>;

    return _fromJsonToAtividadeMap(json);
  }

  static Future<Map<String, dynamic>> atualizar({
    required String id,
    String? titulo,
    String? tipo, // label da UI
    String? turma,
    String? dataEntrega,
    String? descricao,
    String? status,
  }) async {
    final payload = <String, dynamic>{};

    if (titulo != null) payload['nome'] = titulo;
    if (tipo != null) {
      final tipoEnum = _labelToEnum[tipo] ?? tipo;
      payload['tipo'] = tipoEnum;
    }
    if (turma != null) payload['turma'] = turma;
    if (dataEntrega != null) payload['dataEntrega'] = dataEntrega;
    if (descricao != null) payload['descricao'] = descricao;
    if (status != null) payload['status'] = status;

    final resp = await ApiClient.put('$basePath/$id', payload);

    if (resp.statusCode != 200) {
      throw Exception(
          'Status ${resp.statusCode}: ${resp.body}');
    }

    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    final json = body['avaliacao'] as Map<String, dynamic>;

    return _fromJsonToAtividadeMap(json);
  }

  static Future<void> deletar(String id) async {
    final resp = await ApiClient.delete('$basePath/$id');

    if (resp.statusCode != 200) {
      throw Exception(
          'Status ${resp.statusCode}: ${resp.body}');
    }
  }
}
