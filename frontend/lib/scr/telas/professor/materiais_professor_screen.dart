import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ProfessorMateriaisScreen extends StatelessWidget {
  const ProfessorMateriaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        title: const Text('Materiais - Professor'),
      ),
      body: const Center(
        child: Text(
          'Aqui o professor vai publicar e gerenciar materiais de aula e apostilas.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
