import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ProfessorAvisosScreen extends StatelessWidget {
  const ProfessorAvisosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        title: const Text('Avisos - Professor'),
      ),
      body: const Center(
        child: Text(
          'Aqui o professor vai publicar comunicados e mensagens para as turmas.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
