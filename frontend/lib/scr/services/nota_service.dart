// lib/scr/services/nota_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../models/nota.dart';
import '../utils/url.dart';

class NotaService {

  Future<List<Nota>> getMinhasNotas() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/notas/minhas');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> notasJson = decodedBody['notas'];
      return notasJson.map((json) => Nota.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as notas. Status: ${response.statusCode}');
    }
  }

  /// Salva as notas de uma atividade específica.
  /// No backend, isso deve iterar sobre as notas e usar `findOneAndUpdate`
  /// para criar ou atualizar cada nota no banco de dados.
  Future<void> salvarNotasDaAtividade(Map<String, dynamic> atividade) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = getApiBaseUrl();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final avaliacaoId = atividade['avaliacaoId'] as String?;
    if (avaliacaoId == null || avaliacaoId.isEmpty) {
      throw Exception('ID da avaliação não fornecido.');
    }

    final notasParaSalvar = (atividade['notas'] as List?) ?? [];
    if (notasParaSalvar.isEmpty) {
      developer.log('Nenhuma nota para salvar.', name: 'NotaService');
      return;
    }

    developer.log(
      'Salvando ${notasParaSalvar.length} notas para a avaliação ID: $avaliacaoId',
      name: 'NotaService',
    );

    final List<Future<void>> futures = [];

    for (final nota in notasParaSalvar) {
      final notaId = nota['notaId'] as String?;
      final alunoId = nota['alunoId'] as String?;
      final notaObtida = (nota['nota'] as num?)?.toDouble();

      // Não salva se a nota for nula
      if (notaObtida == null) continue;

      if (notaId != null && notaId.isNotEmpty) {
        // Atualizar nota existente
        final future = http
            .put(
          Uri.parse('$url/api/notas/$notaId'),
          headers: headers,
          body: jsonEncode({'notaObtida': notaObtida}),
        )
            .then((response) {
          if (response.statusCode != 200) {
            developer.log(
              'Erro ao ATUALIZAR nota ID $notaId. Status: ${response.statusCode}, Body: ${response.body}',
              name: 'NotaService',
              error: response.body,
            );
          }
        });
        futures.add(future);
      } else {
        // Criar nova nota (só se tiver alunoId)
        if (alunoId != null && alunoId.isNotEmpty) {
          final future = http
              .post(
            Uri.parse('$url/api/notas'),
            headers: headers,
            body: jsonEncode({
              'notaObtida': notaObtida,
              'aluno': alunoId,
              'avaliacao': avaliacaoId,
            }),
          )
              .then((response) {
            if (response.statusCode != 201) {
              developer.log(
                'Erro ao CRIAR nota para aluno ID $alunoId. Status: ${response.statusCode}, Body: ${response.body}',
                name: 'NotaService',
                error: response.body,
              );
            }
          });
          futures.add(future);
        }
      }
    }

    // Espera todas as chamadas terminarem
    try {
      await Future.wait(futures);
      developer.log('Operação de salvar notas concluída.', name: 'NotaService');
    } catch (e) {
      developer.log('Erro durante o Future.wait ao salvar notas.',
          name: 'NotaService', error: e);
      throw Exception('Ocorreu um erro ao salvar uma ou mais notas.');
    }
  }

  Future<List<Map<String, dynamic>>> getNotasDaAvaliacao(String avaliacaoId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/notas/por-avaliacao/$avaliacaoId');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      
      final List<dynamic> notasJson = decodedBody['notas'] ?? [];

      return notasJson.map((nota) {
        final alunoInfo = nota['aluno'] as Map<String, dynamic>?;
        return {
          'notaId': nota['_id'] as String?,
          'alunoId': alunoInfo?['_id'] as String?,
          'nomeAluno': alunoInfo?['nome'] as String? ?? 'Aluno não identificado',
          'nota': (nota['notaObtida'] as num?)?.toDouble(),
        };
      }).toList();
    } else {
      developer.log('Falha ao carregar notas da avaliação $avaliacaoId. Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Falha ao carregar as notas da avaliação.');
    }
  }

  Future<List<Map<String, dynamic>>> getTurmas() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/turmas');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> turmasJson = decodedBody['turmas'] ?? [];
      return turmasJson.cast<Map<String, dynamic>>();
    } else {
      developer.log('Falha ao carregar turmas. Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Falha ao carregar as turmas.');
    }
  }
}