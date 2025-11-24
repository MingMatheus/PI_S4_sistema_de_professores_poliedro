// lib/scr/services/aviso_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/aviso.dart';
import '../utils/url.dart';

class AvisoService {
  Future<List<Aviso>> getMeusAvisos() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/avisos/meus');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> avisosJson = decodedBody['avisos'];
      return avisosJson.map((json) => Aviso.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os avisos. Status: ${response.statusCode}');
    }
  }
}
