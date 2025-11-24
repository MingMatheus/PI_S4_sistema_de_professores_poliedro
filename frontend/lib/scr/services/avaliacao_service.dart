// lib/scr/services/avaliacao_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../utils/url.dart';

class AvaliacaoService {
  Future<List<Map<String, dynamic>>> getAvaliacoes() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/avaliacoes');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> avaliacoesJson = decodedBody['avaliacoes'] ?? [];
      return avaliacoesJson.cast<Map<String, dynamic>>();
    } else {
      developer.log('Falha ao carregar avaliações. Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Falha ao carregar as avaliações.');
    }
  }

  Future<Map<String, dynamic>> createAvaliacao(Map<String, dynamic> data) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/avaliacoes');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      developer.log('Falha ao criar avaliação. Status: ${response.statusCode}, Body: ${response.body}');
      final error = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(error['mensagem'] ?? 'Falha ao criar a avaliação.');
    }
  }

  Future<void> updateAvaliacao(String id, Map<String, dynamic> data) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/avaliacoes/$id');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      developer.log('Falha ao atualizar avaliação. Status: ${response.statusCode}, Body: ${response.body}');
      final error = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(error['mensagem'] ?? 'Falha ao atualizar a avaliação.');
    }
  }

  Future<void> deleteAvaliacao(String id) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/avaliacoes/$id');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      developer.log('Falha ao deletar avaliação. Status: ${response.statusCode}, Body: ${response.body}');
      final error = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(error['mensagem'] ?? 'Falha ao deletar a avaliação.');
    }
  }
}
