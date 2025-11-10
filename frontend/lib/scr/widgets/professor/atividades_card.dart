import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorAtividadesCard extends StatelessWidget {
  const ProfessorAtividadesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.assignment_outlined,
      title: 'Atividades',
      subtitle: 'Publicar e corrigir atividades dos alunos.',
      onTap: () {
        Navigator.pushNamed(context, '/professor/atividades');
      },
    );
  }
}
