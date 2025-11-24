// lib/scr/services/materia_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../utils/url.dart';

class MateriaService {
  Future<List<Map<String, dynamic>>> getMaterias() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/materias');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      // A rota getTodasMaterias retorna um objeto { materias: [...] }
      final List<dynamic> materiasJson = decodedBody['materias'] ?? [];
      return materiasJson.cast<Map<String, dynamic>>();
    } else {
      developer.log('Falha ao carregar matérias. Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Falha ao carregar as matérias.');
    }
  }
}
