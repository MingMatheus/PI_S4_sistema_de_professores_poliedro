// lib/scr/services/aviso_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/aviso.dart';
import '../utils/url.dart';

class AvisoService {
  Future<List<Aviso>> getMeusAvisos() async {
    final token = await getToken();
    if (token == null) throw Exception('Token de autenticação não encontrado.');

    final url = Uri.parse('${getApiBaseUrl()}/api/avisos/meus');
    
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> avisosJson = decodedBody['avisos'];
      return avisosJson.map((json) => Aviso.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os avisos. Status: ${response.statusCode}');
    }
  }

  Future<Aviso> createAviso(Map<String, dynamic> avisoData) async {
    final token = await getToken();
    if (token == null) throw Exception('Token de autenticação não encontrado.');

    final url = Uri.parse('${getApiBaseUrl()}/api/avisos');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(avisoData),
    );

    if (response.statusCode == 201) {
      return Aviso.fromJson(jsonDecode(utf8.decode(response.bodyBytes))['aviso']);
    } else {
      throw Exception('Falha ao criar o aviso. Status: ${response.statusCode}');
    }
  }

  Future<Aviso> updateAviso(String id, Map<String, dynamic> avisoData) async {
    final token = await getToken();
    if (token == null) throw Exception('Token de autenticação não encontrado.');

    final url = Uri.parse('${getApiBaseUrl()}/api/avisos/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(avisoData),
    );

    if (response.statusCode == 200) {
       return Aviso.fromJson(jsonDecode(utf8.decode(response.bodyBytes))['aviso']);
    } else {
      throw Exception('Falha ao atualizar o aviso. Status: ${response.statusCode}');
    }
  }

  Future<void> deleteAviso(String id) async {
    final token = await getToken();
    if (token == null) throw Exception('Token de autenticação não encontrado.');

    final url = Uri.parse('${getApiBaseUrl()}/api/avisos/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir o aviso. Status: ${response.statusCode}');
    }
  }
}
