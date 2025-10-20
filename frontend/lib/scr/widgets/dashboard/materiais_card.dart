import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MateriaisCard extends StatelessWidget {
  const MateriaisCard({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: poliedroBlue);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Materiais de aula', style: titleStyle),
            const SizedBox(height: 16),
            _buildMaterialItem(context, icon: Icons.description_outlined, title: 'Lista de Exercícios - Funções Quadráticas.pdf', details: 'Matemática - Adicionado hoje (06/10)'),
            const Divider(height: 24),
            _buildMaterialItem(context, icon: Icons.link_outlined, title: 'Vídeo: A Célula Animal (Link para YouTube)', details: 'Biologia - Adicionado ontem (05/10)'),
            const Divider(height: 24),
            _buildMaterialItem(context, icon: Icons.notes_outlined, title: 'Instruções para o Ensaio Final.docx', details: 'Literatura - Adicionado em 03/10'),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialItem(BuildContext context, {required IconData icon, required String title, required String details}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(details, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}