import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorAtividadesCard extends StatelessWidget {
  const ProfessorAtividadesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.assignment_rounded,
      color: const Color(0xFF7E57C2),
      title: 'Atividades',
      subtitle: 'Publicar e corrigir atividades dos alunos.',
      onTap: () {
        // depois: navegar para tela de atividades
      },
    );
  }
}
