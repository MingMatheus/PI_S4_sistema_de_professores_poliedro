import 'package:flutter/material.dart';
import 'professor_option_card.dart';

class ProfessorMateriaisCard extends StatelessWidget {
  const ProfessorMateriaisCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessorOptionCard(
      icon: Icons.folder_copy_outlined,
      title: 'Materiais',
      subtitle: 'Publicar e editar materiais de aula e apostilas.',
      onTap: () {
        Navigator.pushNamed(context, '/professor/materiais');
      },
    );
  }
}
