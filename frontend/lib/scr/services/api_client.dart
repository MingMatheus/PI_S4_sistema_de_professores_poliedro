// lib/src/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  /// URL do back.
  /// Como você roda o Flutter no Chrome na MESMA máquina do Node,
  /// pode usar localhost tranquilo.
  static const String baseUrl = 'http://localhost:3000';

  /// Prefixo da rota de notas.
  /// Se no seu back estiver como app.use("/api/nota"...),
  /// MUDA aqui para '/api/nota'.
  static const String notaBasePath = '/nota';

  static Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    // Ajuste a chave se no seu login você salvou com outro nome
    final token = prefs.getString('token');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<http.Response> get(String path) async {
    final headers = await _buildHeaders();
    final url = Uri.parse('$baseUrl$path');
    return http.get(url, headers: headers);
  }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final headers = await _buildHeaders();
    final url = Uri.parse('$baseUrl$path');
    return http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final headers = await _buildHeaders();
    final url = Uri.parse('$baseUrl$path');
    return http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String path) async {
    final headers = await _buildHeaders();
    final url = Uri.parse('$baseUrl$path');
    return http.delete(url, headers: headers);
  }
}
