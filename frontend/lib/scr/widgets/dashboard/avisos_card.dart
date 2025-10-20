import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AvisosCard extends StatelessWidget {
  const AvisosCard({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.bold, color: poliedroBlue);

    final avisos = <_Aviso>[
      _Aviso(
        'Notas atualizadas',
        'Resultados da prova sobre Leis de Newton disponíveis na aba de notas.',
        'Física',
      ),
      _Aviso(
        'Trabalho em grupo',
        'Entrega do mapa conceitual sobre Globalização até 09/10.',
        'Geografia',
      ),
      _Aviso(
        'Notas atualizadas',
        'Resultados da prova sobre Leis de Newton disponíveis na aba de notas.',
        'Física',
      ),
      _Aviso(
        'Novo material disponível',
        'Arquivo "Funções Quadráticas Exercícios Resolvidos" já disponível para download.',
        'Matemática',
      ),
      _Aviso(
        'Prova P2 marcada',
        'Avaliação de Genética e Hereditariedade no dia 14/10 às 10h20.',
        'Biologia',
      ),
      _Aviso(
        'Plantão de dúvidas',
        'Plantão extra de Matemática na quinta-feira, 18h às 19h.',
        'Matemática',
      ),
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Últimos avisos', style: titleStyle),
            const SizedBox(height: 16),

            // cada aviso em um mini-card
            for (final a in avisos) ...[
              _MiniAvisoCard(aviso: a),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniAvisoCard extends StatelessWidget {
  const _MiniAvisoCard({required this.aviso});
  final _Aviso aviso;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10, // 🔹 sombra mais perceptível
      shadowColor: Colors.black.withOpacity(0.5), // 🔹 cor da sombra reforçada
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline, color: poliedroBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aviso.titulo,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(aviso.detalhes,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: poliedroBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      aviso.tag,
                      style: const TextStyle(
                        color: poliedroBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Aviso {
  final String titulo;
  final String detalhes;
  final String tag;
  _Aviso(this.titulo, this.detalhes, this.tag);
}
