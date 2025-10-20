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

    return Card(
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

            // 1
            _buildMensagemItem(
              context,
              sender: 'Prof. Silva - Física',
              message:
                  '“Olá, João. Recebi seu trabalho e gostei da análise na questão 4. Para as próximas, lembre-se de…”',
              time: 'Hoje, 15:20',
            ),
            const Divider(height: 32),

            // 2
            _buildMensagemItem(
              context,
              sender: 'Secretaria Acadêmica',
              message:
                  '“Prezada Ana, recebemos o atestado médico referente à sua ausência na semana passada. Já está tudo certo.”',
              time: 'Ontem, 17:55',
            ),
            const Divider(height: 32),

            // 3 (novo)
            _buildMensagemItem(
              context,
              sender: 'Prof. Marta - Matemática',
              message:
                  '“Bom trabalho no último exercício. Confira os comentários no item (b) da função quadrática.”',
              time: 'Ontem, 10:12',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMensagemItem(
    BuildContext context, {
    required String sender,
    required String message,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sender,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[700])),
        const SizedBox(height: 8),
        Text(time,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey)),
      ],
    );
  }
}
