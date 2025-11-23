// lib/scr/services/nota_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../models/nota.dart';
import '../utils/url.dart';

class NotaService {

  Future<List<Nota>> getMinhasNotas() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final url = Uri.parse('${getApiBaseUrl()}/api/notas/minhas');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> notasJson = decodedBody['notas'];
      return notasJson.map((json) => Nota.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as notas. Status: ${response.statusCode}');
    }
  }

  /// Salva as notas de uma atividade específica.
  /// No backend, isso deve iterar sobre as notas e usar `findOneAndUpdate`
  /// para criar ou atualizar cada nota no banco de dados.
  Future<void> salvarNotasDaAtividade(Map<String, dynamic> atividade) async {
    // Simula o salvamento de notas no servidor
    developer.log('Salvando notas para a atividade: ${atividade['titulo']}', name: 'NotaService');
    developer.log('Payload: $atividade', name: 'NotaService');
    
    await Future.delayed(const Duration(seconds: 1));
    
    developer.log('Notas salvas com sucesso (simulação).', name: 'NotaService');
    // Aqui viria a lógica de chamada para a API (ex: http.post(...))
  }
}
