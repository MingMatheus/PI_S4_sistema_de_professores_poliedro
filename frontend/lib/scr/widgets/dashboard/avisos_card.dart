import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AvisosCard extends StatelessWidget {
  const AvisosCard({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: poliedroBlue);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Últimos avisos', style: titleStyle),
            const SizedBox(height: 16),
            _buildAvisoItem(context, title: 'Notas atualizadas', details: 'Resultados da prova sobre Leis de Newton disponíveis na aba de notas.', tag: 'Física'),
            const Divider(height: 32),
            _buildAvisoItem(context, title: 'Trabalho em grupo', details: 'Entrega do mapa conceitual sobre Globalização até 09/10.', tag: 'Geografia'),
            const Divider(height: 32),
            _buildAvisoItem(context, title: 'Notas atualizadas', details: 'Resultados da prova sobre Leis de Newton disponíveis na aba de notas.', tag: 'Física'),
            const Divider(height: 32),
            _buildAvisoItem(context, title: 'Novo material disponível', details: 'Arquivo "Funções Quadráticas Exercícios Resolvidos" já está disponível para download', tag: 'Matemática'),
            const Divider(height: 32),
            _buildAvisoItem(context, title: 'Prova P2 marcada', details: 'Avaliação de Genética e Hereditariedade no dia 14/10 às 10h20.', tag: 'Biologia'),
          ],
        ),
      ),
    );
  }

  Widget _buildAvisoItem(BuildContext context, {required String title, required String details, required String tag}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lightbulb_outline, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(details),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: poliedroBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(tag, style: const TextStyle(color: poliedroBlue, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}