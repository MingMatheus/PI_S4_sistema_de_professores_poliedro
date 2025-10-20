import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MateriaisCard extends StatelessWidget {
  const MateriaisCard({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.bold, color: poliedroBlue);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // lista
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.folder_outlined, color: poliedroBlue),
                      const SizedBox(width: 8),
                      Text('Materiais de aula', style: titleStyle),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildMaterialItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Lista de Exercícios - Funções Quadráticas.pdf',
                    details: 'Matemática · Adicionado hoje (06/10)',
                  ),
                  const SizedBox(height: 12),

                  _buildMaterialItem(
                    context,
                    icon: Icons.link_outlined,
                    title: 'Vídeo: A Célula Animal (YouTube)',
                    details: 'Biologia · Adicionado ontem (05/10)',
                  ),
                  const SizedBox(height: 12),

                  _buildMaterialItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Instruções para o Ensaio Final.docx',
                    details: 'Literatura · Adicionado em 03/10',
                  ),
                  const SizedBox(height: 12),

                  // novos (até fechar em 5)
                  _buildMaterialItem(
                    context,
                    icon: Icons.picture_as_pdf_outlined,
                    title: 'Exercícios Resolvidos - Cinemática.pdf',
                    details: 'Física · Adicionado em 02/10',
                  ),
                  const SizedBox(height: 12),

                  _buildMaterialItem(
                    context,
                    icon: Icons.slideshow_outlined,
                    title: 'Slides – Revolução Francesa.pptx',
                    details: 'História · Adicionado em 30/09',
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            // logo (lado direito)
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  // aumentei a logo
                  width: 260, // ajuste se quiser maior/menor
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String details,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Flexible(
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
}
