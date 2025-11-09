import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorTurmasCard extends StatelessWidget {
  const ProfessorTurmasCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.people_alt_rounded,
      color: const Color(0xFF1976D2),
      title: 'Turmas',
      subtitle: 'Criar, editar e gerenciar turmas e alunos.',
      onTap: () {
        Navigator.pushNamed(context, '/professor/turmas');
      },
    );
  }
}
