import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorMateriaisCard extends StatelessWidget {
  const ProfessorMateriaisCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.menu_book_rounded,
      color: const Color(0xFF43A047),
      title: 'Materiais',
      subtitle: 'Publicar e editar materiais de aula e apostilas.',
      onTap: () {
        // depois: navegar para tela de materiais do professor
      },
    );
  }
}
