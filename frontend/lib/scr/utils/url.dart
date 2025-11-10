import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

String getApiBaseUrl() {
  if (kIsWeb) {
    // 1. Está rodando na WEB (Chrome)
    return "http://localhost:8080";
  }

  // Se não é web, é seguro checar 'Platform' (Mobile/Desktop)
  if (Platform.isAndroid) {
    // 2. Está rodando no Emulador ANDROID
    // Esta é a ÚNICA exceção que usa o IP especial.
    return "http://10.0.2.2:8080";
  } else {
    // 3. Está rodando em QUALQUER OUTRA plataforma nativa
    // (Windows, iOS Simulator, macOS, Linux)
    // Todos estes podem acessar o host usando localhost.
    return "http://localhost:8080";
  }
}