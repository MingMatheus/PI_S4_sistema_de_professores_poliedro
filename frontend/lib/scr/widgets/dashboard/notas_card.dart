import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class NotasCard extends StatelessWidget {
  const NotasCard({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: poliedroBlue);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart_outlined, color: poliedroBlue),
                const SizedBox(width: 8),
                Text('Notas e Médias', style: titleStyle),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotaItem(context, title: 'Nota de Prova', details: 'Matemática - Prova Bimestral (P2): 8.5 / 10'),
            const SizedBox(height: 12),
            _buildNotaItem(context, title: 'Nota de Exercício', details: 'Química - Lista de Exercícios (Tabela Periódica): 10 / 10'),
            const SizedBox(height: 12),
            _buildNotaItem(context, title: 'Nota de Trabalho em Grupo', details: 'História - Trabalho em Grupo (Revolução Industrial): 9.0 / 10'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotaItem(BuildContext context, {required String title, required String details}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_box_outline_blank, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(details, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}