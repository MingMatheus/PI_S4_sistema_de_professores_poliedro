import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../login/login_screen.dart';

class ProfessorTurmasScreen extends StatelessWidget {
  const ProfessorTurmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        title: const Text('Turmas - Professor'),
      ),
      body: const Center(
        child: Text(
          'Aqui o professor vai criar, editar e gerenciar turmas e alunos.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
