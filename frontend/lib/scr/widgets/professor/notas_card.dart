import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorNotasCard extends StatelessWidget {
  const ProfessorNotasCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.star_rate_rounded,
      color: const Color(0xFFFFB300),
      title: 'Notas',
      subtitle: 'Lançar e editar notas de provas e atividades.',
      onTap: () {
        // depois: navegar para tela de notas
      },
    );
  }
}
