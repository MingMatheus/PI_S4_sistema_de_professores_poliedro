// lib/scr/services/aluno_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/aluno.dart';
import '../utils/url.dart';

class AlunoService {
  Future<List<Aluno>> getAlunos() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/alunos');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> alunosJson = decodedBody['alunos'];
      return alunosJson.map((json) => Aluno.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os alunos. Status: ${response.statusCode}');
    }
  }
}
