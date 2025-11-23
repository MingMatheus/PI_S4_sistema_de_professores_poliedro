// lib/src/services/nota_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class NotaService {
  static String get _basePath => ApiClient.notaBasePath;

  /// Busca notas de uma avaliação específica
  /// GET /nota/por-avaliacao/:id
  static Future<List<Map<String, dynamic>>> getNotasByAvaliacao(
    String avaliacaoId,
  ) async {
    final http.Response response =
        await ApiClient.get('$_basePath/por-avaliacao/$avaliacaoId');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final notas = body['notas'] as List<dynamic>? ?? [];
      return notas.cast<Map<String, dynamic>>();
    } else {
      throw Exception(
          'Erro ao buscar notas (status ${response.statusCode})');
    }
  }

  /// Cria OU atualiza uma nota
  ///
  /// - Se [notaId] == null -> POST /nota
  /// - Se [notaId] != null -> PUT  /nota/:id
  static Future<void> criarOuAtualizarNota({
    String? notaId,
    required String avaliacaoId,
    required String alunoId,
    required double notaObtida,
  }) async {
    if (notaId == null || notaId.isEmpty) {
      // Criar nova nota
      final response = await ApiClient.post(_basePath, {
        'notaObtida': notaObtida,
        'aluno': alunoId,
        'avaliacao': avaliacaoId,
      });

      if (response.statusCode != 201 && response.statusCode != 200) {
        final body = _tentaLerMensagem(response);
        throw Exception(
            'Erro ao criar nota (${response.statusCode}): $body');
      }
    } else {
      // Atualizar nota existente
      final response = await ApiClient.put('$_basePath/$notaId', {
        'notaObtida': notaObtida,
      });

      if (response.statusCode != 200) {
        final body = _tentaLerMensagem(response);
        throw Exception(
            'Erro ao atualizar nota (${response.statusCode}): $body');
      }
    }
  }

  /// Recebe a 'atividade' (Map) com a lista de notas
  /// Espera formato:
  /// {
  ///   'avaliacaoId': '...',
  ///   'notas': [
  ///     {
  ///       'notaId': '...',    // opcional (id da Nota no Mongo)
  ///       'alunoId': '...',   // OBRIGATÓRIO pra bater no back
  ///       'nomeAluno': '...', // só visual
  ///       'nota': 8.5,        // valor da nota
  ///     },
  ///     ...
  ///   ]
  /// }
  static Future<void> salvarNotasDaAtividade(
      Map<String, dynamic> atividade) async {
    final avaliacaoId = (atividade['avaliacaoId'] as String?) ?? '';
    if (avaliacaoId.isEmpty) {
      throw Exception(
          'atividade["avaliacaoId"] vazio. Preencha o ID da avaliação.');
    }

    final List<dynamic> linhas = atividade['notas'] as List<dynamic>? ?? [];

    for (final dynamic linha in linhas) {
      final map = linha as Map<String, dynamic>;

      final alunoId = map['alunoId'] as String?;
      final notaId = map['notaId'] as String?;
      final notaValor = map['nota'] as num?;

      if (alunoId == null || alunoId.isEmpty) {
        // pula linha sem alunoId (não tem como criar nota no back)
        continue;
      }

      if (notaValor == null) {
        // sem nota, ignora
        continue;
      }

      await criarOuAtualizarNota(
        notaId: notaId,
        avaliacaoId: avaliacaoId,
        alunoId: alunoId,
        notaObtida: notaValor.toDouble(),
      );
    }
  }

  static String _tentaLerMensagem(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['mensagem'] is String) {
        return body['mensagem'] as String;
      }
    } catch (_) {}
    return response.body;
  }
}
