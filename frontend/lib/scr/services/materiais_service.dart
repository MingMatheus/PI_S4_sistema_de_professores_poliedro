// lib/scr/services/materiais_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pasta.dart';
import '../models/arquivo.dart';
import '../utils/url.dart';

class MateriaisService {
  Future<Map<String, List<dynamic>>> getConteudoPasta({String? pastaId}) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final baseUrl = getApiBaseUrl();

    // Define URLs based on whether it's the root folder or a subfolder
    final pastasUrl = pastaId == null
        ? Uri.parse('$baseUrl/api/pastas')
        : Uri.parse('$baseUrl/api/pastas/$pastaId/subpastas');

    final arquivosUrl = pastaId == null
        ? Uri.parse('$baseUrl/api/arquivos')
        : Uri.parse('$baseUrl/api/arquivos/por-pasta/$pastaId');

    try {
      // Fetch folders and files in parallel
      final results = await Future.wait([
        http.get(pastasUrl, headers: headers),
        http.get(arquivosUrl, headers: headers),
      ]);

      final pastasResponse = results[0];
      final arquivosResponse = results[1];

      // Process folders
      if (pastasResponse.statusCode != 200) {
        throw Exception('Falha ao carregar as pastas. Status: ${pastasResponse.statusCode}');
      }
      final pastasJson = jsonDecode(utf8.decode(pastasResponse.bodyBytes))['pastas'] as List;
      final List<Pasta> pastas = pastasJson.map((json) => Pasta.fromJson(json)).toList();

      // Process files
      if (arquivosResponse.statusCode != 200) {
        throw Exception('Falha ao carregar os arquivos. Status: ${arquivosResponse.statusCode}');
      }
      final arquivosBody = jsonDecode(utf8.decode(arquivosResponse.bodyBytes));
      // Handle inconsistent key from the backend ('arquivos' vs 'arquivo')
      final List<dynamic> arquivosJson = arquivosBody['arquivos'] ?? arquivosBody['arquivo'] ?? [];
      final List<Arquivo> arquivos = arquivosJson.map((json) => Arquivo.fromJson(json)).toList();

      return {
        'pastas': pastas,
        'arquivos': arquivos,
      };
    } catch (e) {
      // Re-throw the exception to be caught by the FutureBuilder
      throw Exception('Erro ao buscar materiais: $e');
    }
  }
}
