import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // permite rolar a tela se tiver muito conteúdo
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // avisos
        _buildAvisosCard(context),
        const SizedBox(height: 16),

        // mensagens
        _buildMensagensCard(context),
        const SizedBox(height: 16),

        // adicionar os outros cards como notas e etc
      ],
    );
  }

  // aba avisos
  Widget _buildAvisosCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Últimos avisos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // exemplos
            _buildAvisoItem(
              title: 'Notas atualizadas',
              subtitle: 'Resultados da prova sobre Leis de Newton...',
              tag: 'Física',
            ),
            _buildAvisoItem(
              title: 'Trabalho em grupo',
              subtitle: 'Entrega do mapa conceitual sobre Globalização...',
              tag: 'Geografia',
            ),
          ],
        ),
      ),
    );
  }

  // aba mensagens
  Widget _buildMensagensCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mensagens',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // exemplos
            _buildMensagemItem(
              sender: 'Prof. Silva - Física',
              message: '"Olá, João. Recebi seu trabalho..."',
              time: 'Hoje, 15:20',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvisoItem({required String title, required String subtitle, required String tag}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications_none_outlined, color: poliedroBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(tag, style: const TextStyle(color: poliedroBlue, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildMensagemItem({required String sender, required String message, required String time}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 18, backgroundColor: lightGrey, child: Icon(Icons.person_outline)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sender, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(message, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}