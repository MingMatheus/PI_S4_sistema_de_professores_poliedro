import 'package:flutter/material.dart';
import 'package:frontend/scr/app.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async { // Tornar main assíncrona
  // Garante que os bindings do Flutter foram inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa os dados de locale para formatação de data em Português
  await initializeDateFormatting('pt_BR', null);
  
  runApp(App());
}