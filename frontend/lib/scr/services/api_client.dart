// lib/src/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  /// URL do back.
  /// Seu Node está na porta 8080 (log: "Servidor rodando na porta 8080")
  static const String baseUrl = 'http://localhost:8080';

  static Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();

    // >>> ALINHADO COM O LOGIN <<<
    final token =
        prefs.getString('jwt_token') ?? // é essa que o login salva
        prefs.getString('token') ??
        prefs.getString('authToken') ??
        prefs.getString('accessToken');

    // DEBUG: aparece no console do navegador (F12 > Console)
    if (token == null) {
      // ignore: avoid_print
      print('[ApiClient] Nenhum token encontrado no SharedPreferences.');
    } else {
      final preview =
          token.length > 10 ? token.substring(0, 10) : token;
      // ignore: avoid_print
      print('[ApiClient] Token encontrado (primeiros 10 chars): $preview...');
    }

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
    // ignore: avoid_print
    print('[ApiClient][GET] $url  headers: $headers');
    return http.get(url, headers: headers);
  }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final headers = await _buildHeaders();
    final url = Uri.parse('$baseUrl$path');
    // ignore: avoid_print
    print('[ApiClient][POST] $url  body: $body');
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
    // ignore: avoid_print
    print('[ApiClient][PUT] $url  body: $body');
    return http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String path) async {
    final headers = await _buildHeaders();
    final url = Uri.parse('$baseUrl$path');
    // ignore: avoid_print
    print('[ApiClient][DELETE] $url');
    return http.delete(url, headers: headers);
  }
}
