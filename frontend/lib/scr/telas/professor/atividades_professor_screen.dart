import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ProfessorAtividadesScreen extends StatelessWidget {
  const ProfessorAtividadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        title: const Text('Atividades - Professor'),
      ),
      body: const Center(
        child: Text(
          'Aqui o professor vai criar atividades e ver respostas dos alunos.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
