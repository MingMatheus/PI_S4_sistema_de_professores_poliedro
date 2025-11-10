import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ProfessorNotasScreen extends StatelessWidget {
  const ProfessorNotasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        title: const Text('Notas - Professor'),
      ),
      body: const Center(
        child: Text(
          'Aqui o professor vai lançar e editar notas de provas e atividades.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
