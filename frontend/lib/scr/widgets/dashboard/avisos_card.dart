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

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.12),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Últimos avisos', style: titleStyle),
            const SizedBox(height: 16),
            for (final a in _avisos) _AvisoItem(a),
          ],
        ),
      ),
    );
  }
}

class _AvisoItem extends StatelessWidget {
  const _AvisoItem(this.a);
  final _Aviso a;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF3F8)), // sutil
        // 💡 sombra mais leve, mas ainda perceptível
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: poliedroBlue, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.titulo,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  a.descricao,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: poliedroBlue.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: poliedroBlue.withOpacity(0.18)),
                  ),
                  child: Text(
                    a.tag,
                    style: const TextStyle(
                      color: poliedroBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<_Aviso> _avisos = [
  _Aviso(
    titulo: 'Notas atualizadas',
    descricao:
        'Resultados da prova sobre Leis de Newton disponíveis na aba de notas.',
    tag: 'Física',
  ),
  _Aviso(
    titulo: 'Trabalho em grupo',
    descricao: 'Entrega do mapa conceitual sobre Globalização até 09/10.',
    tag: 'Geografia',
  ),
  _Aviso(
    titulo: 'Novo material disponível',
    descricao:
        'Arquivo "Funções Quadráticas Exercícios Resolvidos" já disponível para download.',
    tag: 'Matemática',
  ),
  _Aviso(
    titulo: 'Prova P2 marcada',
    descricao:
        'Avaliação de Genética e Hereditariedade no dia 14/10 às 10h20.',
    tag: 'Biologia',
  ),
];

class _Aviso {
  final String titulo;
  final String descricao;
  final String tag;
  _Aviso({required this.titulo, required this.descricao, required this.tag});
}
