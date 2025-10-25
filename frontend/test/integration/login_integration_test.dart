import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

String prettyJson(Object? data) =>
    const JsonEncoder.withIndent('  ').convert(data);

void main() {
  group('Login - integração (API simulada)', () {
    test('200 | credenciais válidas', () async {
      final client = MockClient((request) async {
        final body = jsonDecode(request.body);
        if (body['email'] == 'teste@aluno.com' && body['senha'] == '123456') {
          return http.Response(
            jsonEncode({'mensagem': 'Login realizado com sucesso', 'token': 'abc123'}),
            200,
            headers: {'Content-Type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({'mensagem': 'Credenciais inválidas'}),
          401,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final url = Uri.parse('http://localhost:8080/auth/login');
      final body = {'email': 'teste@aluno.com', 'senha': '123456'};
      final resp = await client.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));

      printOnFailure('''
[LOGIN TEST - 200]
URL...........: $url
Expected code.: 200
Actual code...: ${resp.statusCode}
Request body..: ${prettyJson(body)}
Response body.: ${prettyJson(jsonDecode(resp.body))}
''');

      expect(resp.statusCode, 200,
          reason: 'Credenciais válidas devem retornar 200 e um token.');
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      expect(json['mensagem'], 'Login realizado com sucesso');
      expect(json.containsKey('token'), isTrue);
    });

    test('401 | senha incorreta', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({'mensagem': 'Credenciais inválidas'}),
          401,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final url = Uri.parse('http://localhost:8080/auth/login');
      final body = {'email': 'teste@aluno.com', 'senha': 'errada'};
      final resp = await client.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));

      printOnFailure('''
[LOGIN TEST - 401]
URL...........: $url
Expected code.: 401
Actual code...: ${resp.statusCode}
Request body..: ${prettyJson(body)}
Response body.: ${prettyJson(jsonDecode(resp.body))}
''');

      expect(resp.statusCode, 401,
          reason: 'Senha incorreta deve retornar código 401.');
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      expect(json['mensagem'], 'Credenciais inválidas');
    });

    test('400 | campos vazios', () async {
      final client = MockClient((request) async {
        final body = jsonDecode(request.body);
        if ((body['email'] ?? '').toString().isEmpty ||
            (body['senha'] ?? '').toString().isEmpty) {
          return http.Response(
            jsonEncode({'mensagem': 'Credenciais inválidas'}),
            400,
            headers: {'Content-Type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({'mensagem': 'Login realizado com sucesso', 'token': 'x'}),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final url = Uri.parse('http://localhost:8080/auth/login');
      final body = {'email': '', 'senha': ''};
      final resp = await client.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));

      printOnFailure('''
[LOGIN TEST - 400]
URL...........: $url
Expected code.: 400
Actual code...: ${resp.statusCode}
Request body..: ${prettyJson(body)}
Response body.: ${prettyJson(jsonDecode(resp.body))}
''');

      expect(resp.statusCode, 400,
          reason: 'Campos vazios devem retornar 400.');
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      expect(json['mensagem'], 'Credenciais inválidas');
    });

    test('500 | erro interno no servidor', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({'mensagem': 'Ocorreu um erro no servidor, tente novamente mais tarde'}),
          500,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final url = Uri.parse('http://localhost:8080/auth/login');
      final body = {'email': 'teste@aluno.com', 'senha': '123456'};
      final resp = await client.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));

      printOnFailure('''
[LOGIN TEST - 500]
URL...........: $url
Expected code.: 500
Actual code...: ${resp.statusCode}
Request body..: ${prettyJson(body)}
Response body.: ${prettyJson(jsonDecode(resp.body))}
''');

      expect(resp.statusCode, 500,
          reason: 'Erros internos devem retornar 500.');
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      expect(json['mensagem'],
          'Ocorreu um erro no servidor, tente novamente mais tarde');
    });
  });
}
