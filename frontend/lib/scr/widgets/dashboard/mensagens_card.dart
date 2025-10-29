import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MensagensCard extends StatelessWidget {
  const MensagensCard({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.bold, color: poliedroBlue);

    final todas = <_Msg>[
      _Msg('Prof. Silva - Física',
          '“Olá, João. Recebi seu trabalho e gostei da análise na questão 4. Para as próximas, lembre-se de...”',
          'Hoje, 15:20'),
      _Msg('Secretaria Acadêmica',
          '“Prezada Ana, recebemos o atestado médico referente à sua ausência na semana passada. Já está tudo certo.”',
          'Ontem, 17:55'),
      _Msg('Prof. Marta - Matemática',
          '“Bom trabalho no último exercício. Confira os comentários no item (b) da função quadrática.”',
          'Ontem, 10:12'),
    ];

    final width = MediaQuery.sizeOf(context).width;
    final isNotebook = width < 1366;
    // Em notebook mostramos só 2 para evitar overflow
    final mensagens = isNotebook ? todas.take(2).toList() : todas;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline, color: poliedroBlue),
                const SizedBox(width: 8),
                Text('Mensagens', style: titleStyle),
              ],
            ),
            const SizedBox(height: 16),

            // lista (com truncamento para evitar texto sair do card)
            ...mensagens.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MensagemItem(mensagem: m),
                )),
          ],
        ),
      ),
    );
  }
}

class _MensagemItem extends StatelessWidget {
  const _MensagemItem({required this.mensagem});
  final _Msg mensagem;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mensagem.titulo,
          style: txt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          mensagem.preview,
          style: txt.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          mensagem.horario,
          style: txt.bodySmall?.copyWith(color: Colors.grey[700]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Divider(height: 20),
      ],
    );
  }
}

class _Msg {
  final String titulo;
  final String preview;
  final String horario;
  _Msg(this.titulo, this.preview, this.horario);
}
