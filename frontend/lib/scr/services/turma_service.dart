// lib/scr/services/turma_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/turma.dart';
import '../utils/url.dart';

class TurmaService {
  Future<List<Turma>> getTurmas() async {
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
      final List<dynamic> turmasJson = decodedBody['turmas'];
      return turmasJson.map((json) => Turma.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as turmas. Status: ${response.statusCode}');
    }
  }
}
