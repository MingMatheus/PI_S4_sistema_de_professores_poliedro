import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorAvisosCard extends StatelessWidget {
  const ProfessorAvisosCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.campaign_rounded,
      color: const Color(0xFFE53935),
      title: 'Avisos',
      subtitle: 'Publicar comunicados e mensagens para as turmas.',
      onTap: () {
        // depois: navegar para tela de avisos
      },
    );
  }
}
