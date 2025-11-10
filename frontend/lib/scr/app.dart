import 'package:flutter/material.dart';
import 'telas/login/login_screen.dart';
import 'theme/app_theme.dart';

// telas principais
import 'telas/home/professor_home_screen.dart';

// telas individuais do professor
import 'telas/professor/turmas_professor_screen.dart';
import 'telas/professor/materiais_professor_screen.dart';
import 'telas/professor/atividades_professor_screen.dart';
import 'telas/professor/notas_professor_screen.dart';
import 'telas/professor/avisos_professor_screen.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Poliedro',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      // login decide pra onde vai (aluno ou professor)
      home: LoginScreen(),

      // rotas adicionadas apenas pro painel do professor
      routes: {
        '/professor-home': (context) => const ProfessorHomeScreen(),
        '/professor/turmas': (context) => const ProfessorTurmasScreen(),
        '/professor/materiais': (context) => const ProfessorMateriaisScreen(),
        '/professor/atividades': (context) => const ProfessorAtividadesScreen(),
        '/professor/notas': (context) => const ProfessorNotasScreen(),
        '/professor/avisos': (context) => const ProfessorAvisosScreen(),
      },
    );
  }
}
