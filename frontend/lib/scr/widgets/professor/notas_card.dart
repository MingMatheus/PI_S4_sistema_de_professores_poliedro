import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorNotasCard extends StatelessWidget {
  const ProfessorNotasCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.bar_chart_outlined,
      title: 'Notas',
      subtitle: 'Lançar e editar notas de provas e atividades.',
      onTap: () {
        Navigator.pushNamed(context, '/professor/notas');
      },
    );
  }
}
