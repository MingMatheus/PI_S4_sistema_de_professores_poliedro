// lib/scr/services/serie_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/serie.dart';
import '../utils/url.dart';

class SerieService {
  Future<List<Serie>> getSeries() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/series');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> seriesJson = decodedBody['series'];
      return seriesJson.map((json) => Serie.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as séries. Status: ${response.statusCode}');
    }
  }
}
