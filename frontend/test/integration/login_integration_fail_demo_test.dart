import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

String prettyJson(Object? data) =>
    const JsonEncoder.withIndent('  ').convert(data);

void main() {
  group('Login - integração (exemplo de falha)', () {
    test(
      'Exemplo | esperado 200, recebido 401',
      () async {
        final client = MockClient((_) async {
          return http.Response(
            jsonEncode({'mensagem': 'Credenciais inválidas'}),
            401,
            headers: {'Content-Type': 'application/json'},
          );
        });

        final url = Uri.parse('http://localhost:8080/auth/login');
        final requestBody = {'email': 'teste@aluno.com', 'senha': 'errada'};
        final resp = await client.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        printOnFailure('''
[LOGIN | EXEMPLO DE FALHA]
URL...........: $url
Expected code.: 200
Actual code...: ${resp.statusCode}
Request hdrs..: ${prettyJson({'Content-Type': 'application/json'})}
Request body..: ${prettyJson(requestBody)}
Response hdrs.: ${prettyJson(resp.headers)}
Response body.: ${prettyJson(jsonDecode(resp.body))}
''');

        expect(resp.statusCode, 200,
            reason: 'Exemplo de evidência visual de falha controlada.');
      },
      skip: 'Teste de falha proposital — usado apenas como evidência.',
    );
  });
}
