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
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ▸ BREAKPOINTS e tamanhos da LOGO (só afeta desktop/web)
            //   - >= 1100px  → logo 300
            //   - >= 900px   → logo 260
            //   - >= 700px   → logo 220
            //   - < 700px    → esconde a logo (mobile)
            double? logoSize;
            if (constraints.maxWidth >= 1100) {
              logoSize = 300; // ← ajuste aqui se quiser maior/menor no desktop largo
            } else if (constraints.maxWidth >= 900) {
              logoSize = 260;
            } else if (constraints.maxWidth >= 700) {
              logoSize = 220;
            } else {
              logoSize = null; // mobile: some
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LISTA (ocupa todo espaço disponível)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.folder_open, color: poliedroBlue),
                          const SizedBox(width: 8),
                          Text('Materiais de aula', style: titleStyle),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._itens.map((e) => _MaterialItem(e)).toList(),
                    ],
                  ),
                ),

                // LOGO à direita (só aparece quando logoSize != null)
                if (logoSize != null) ...[
                  const SizedBox(width: 24),
                  SizedBox(
                    width: logoSize,
                    height: logoSize,
                    child: Card(
                      elevation: 3,
                      shadowColor: Colors.black.withOpacity(0.12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset('assets/images/logo.jpg', fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

// ---------------- Dados/Itens ----------------

final List<_Material> _itens = [
  _Material(
    icon: Icons.picture_as_pdf_outlined,
    titulo: 'Lista de Exercícios - Funções Quadráticas.pdf',
    descricao: 'Matemática · Adicionado hoje (06/10)',
  ),
  _Material(
    icon: Icons.ondemand_video_outlined,
    titulo: 'Vídeo: A Célula Animal (YouTube)',
    descricao: 'Biologia · Adicionado ontem (05/10)',
  ),
  _Material(
    icon: Icons.description_outlined,
    titulo: 'Instruções para o Ensaio Final.docx',
    descricao: 'Literatura · Adicionado em 03/10',
  ),
  _Material(
    icon: Icons.picture_as_pdf_outlined,
    titulo: 'Exercícios Resolvidos - Cinemática.pdf',
    descricao: 'Física · Adicionado em 02/10',
  ),
  _Material(
    icon: Icons.slideshow_outlined,
    titulo: 'Slides – Revolução Francesa.pptx',
    descricao: 'História · Adicionado em 30/09',
  ),
];

class _MaterialItem extends StatelessWidget {
  const _MaterialItem(this.m);
  final _Material m;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(m.icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.titulo,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(m.descricao, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Material {
  final IconData icon;
  final String titulo;
  final String descricao;
  _Material({required this.icon, required this.titulo, required this.descricao});
}
