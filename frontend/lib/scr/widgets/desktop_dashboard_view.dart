import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DesktopDashboardView extends StatelessWidget {
  const DesktopDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildMensagensCard(context),
                const SizedBox(height: 24),
                _buildMateriaisCard(context),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildNotasCard(context),
                const SizedBox(height: 24),
                _buildLogoCard(context),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildAvisosCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMensagensCard(BuildContext context) {
    final titleStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
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
            _buildMensagemItem(
              context,
              sender: 'Prof. Silva - Física',
              message:
                  '“Olá, João. Recebi seu trabalho e gostei muito da sua análise na questão 4. Apenas um detalhe para o futuro: lembre-se de...”',
              time: 'Hoje, 15:20',
            ),
            const Divider(height: 32),
            _buildMensagemItem(
              context,
              sender: 'Secretaria Acadêmica',
              message:
                  '“Prezada Ana, recebemos o atestado médico que você enviou referente a sua ausência na semana passada. Já está tudo certo.”',
              time: 'Ontem, 17:55',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotasCard(BuildContext context) {
    final titleStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
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
            _buildNotaItem(context,
                title: 'Nota de Prova',
                details: 'Matemática - Prova Bimestral (P2): 8.5 / 10'),
            const SizedBox(height: 12),
            _buildNotaItem(context,
                title: 'Nota de Exercício',
                details:
                    'Química - Lista de Exercícios (Tabela Periódica): 10 / 10'),
            const SizedBox(height: 12),
            _buildNotaItem(context,
                title: 'Nota de Trabalho em Grupo',
                details:
                    'História - Trabalho em Grupo (Revolução Industrial): 9.0 / 10'),
          ],
        ),
      ),
    );
  }

  Widget _buildAvisosCard(BuildContext context) {
    final titleStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Últimos avisos', style: titleStyle),
            const SizedBox(height: 16),
            _buildAvisoItem(context,
                title: 'Notas atualizadas',
                details:
                    'Resultados da prova sobre Leis de Newton disponíveis na aba de notas.',
                tag: 'Física'),
            const Divider(height: 32),
            _buildAvisoItem(context,
                title: 'Trabalho em grupo',
                details:
                    'Entrega do mapa conceitual sobre Globalização até 09/10.',
                tag: 'Geografia'),
            const Divider(height: 32),
            _buildAvisoItem(context,
                title: 'Notas atualizadas',
                details:
                    'Resultados da prova sobre Leis de Newton disponíveis na aba de notas.',
                tag: 'Física'),
            const Divider(height: 32),
            _buildAvisoItem(context,
                title: 'Novo material disponível',
                details:
                    'Arquivo "Funções Quadráticas Exercícios Resolvidos" já está disponível para download',
                tag: 'Matemática'),
            const Divider(height: 32),
            _buildAvisoItem(context,
                title: 'Prova P2 marcada',
                details:
                    'Avaliação de Genética e Hereditariedade no dia 14/10 às 10h20.',
                tag: 'Biologia'),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriaisCard(BuildContext context) {
    final titleStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Materiais de aula', style: titleStyle),
            const SizedBox(height: 16),
            _buildMaterialItem(context,
                icon: Icons.description_outlined,
                title: 'Lista de Exercícios - Funções Quadráticas.pdf',
                details: 'Matemática - Adicionado hoje (06/10)'),
            const Divider(height: 24),
            _buildMaterialItem(context,
                icon: Icons.link_outlined,
                title: 'Vídeo: A Célula Animal (Link para YouTube)',
                details: 'Biologia - Adicionado ontem (05/10)'),
            const Divider(height: 24),
            _buildMaterialItem(context,
                icon: Icons.notes_outlined,
                title: 'Instruções para o Ensaio Final.docx',
                details: 'Literatura - Adicionado em 03/10'),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoCard(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Image.asset(
        'assets/images/logo.jpg',
        height: 150,
      ),
    ));
  }

  Widget _buildMensagemItem(BuildContext context,
      {required String sender, required String message, required String time}) {
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

  Widget _buildNotaItem(BuildContext context,
      {required String title, required String details}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_box_outline_blank, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(details, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvisoItem(BuildContext context,
      {required String title, required String details, required String tag}) {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: poliedroBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(tag,
                    style: const TextStyle(
                        color: poliedroBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String details}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(details,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}