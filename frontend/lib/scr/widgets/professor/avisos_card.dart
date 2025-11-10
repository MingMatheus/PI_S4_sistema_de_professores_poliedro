import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorAvisosCard extends StatelessWidget {
  const ProfessorAvisosCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.notifications_none_outlined,
      title: 'Avisos',
      subtitle: 'Publicar comunicados e mensagens para as turmas.',
      onTap: () {
        Navigator.pushNamed(context, '/professor/avisos');
      },
    );
  }
}
