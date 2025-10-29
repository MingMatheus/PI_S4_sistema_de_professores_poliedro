// telas/home/widgets/dashboard/mensagens_card.dart
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

    final w = MediaQuery.sizeOf(context).width;

    // 👉 até 1550px mostra só 2 pra não ficar apertado
    final maxItens = w < 1550 ? 2 : 3;
    final mensagens = todas.take(maxItens).toList();

    return SizedBox(
      height: 315,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.hardEdge,
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
              const SizedBox(height: 12),

              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 12), // 👈 folga no rodapé
                  physics: const ClampingScrollPhysics(),
                  itemCount: mensagens.length,
                  separatorBuilder: (_, __) => const Divider(height: 20),
                  itemBuilder: (_, i) => _MensagemItem(mensagem: mensagens[i]),
                ),
              ),
            ],
          ),
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
