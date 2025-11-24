import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorCriarMateriaisCard extends StatelessWidget {
  const ProfessorCriarMateriaisCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.add_box_outlined,
      title: 'Criar Matérias',
      subtitle: 'Crie e gerencie as matérias que você leciona.',
      onTap: () {
        // TODO: Implementar navegação para a tela de criar matérias
      },
    );
  }
}
