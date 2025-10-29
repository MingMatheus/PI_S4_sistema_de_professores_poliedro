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

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 300, // 🔹 reduzi mais pra o card subir na tela
      ),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.12),
        margin: const EdgeInsets.only(bottom: 4), // 🔹 tira espaço embaixo
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // BREAKPOINTS: tamanhos da logo (desktop/web)
              double? logoSize;
              if (constraints.maxWidth >= 1100) {
                logoSize = 240;
              } else if (constraints.maxWidth >= 900) {
                logoSize = 210;
              } else if (constraints.maxWidth >= 700) {
                logoSize = 180;
              } else {
                logoSize = null; // mobile: some
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // lista de materiais
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
                        const SizedBox(height: 12),

                        // mostra só 4 itens pra caber sem overflow
                        ..._itens.take(4).map((e) => _MaterialItem(e)).toList(),
                      ],
                    ),
                  ),

                  // logo do Poliedro
                  if (logoSize != null) ...[
                    const SizedBox(width: 24),
                    SizedBox(
                      width: logoSize,
                      height: logoSize,
                      child: Card(
                        elevation: 3,
                        shadowColor: Colors.black.withOpacity(0.12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ---------------- Dados ----------------

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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(m.icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.titulo,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
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
  _Material({
    required this.icon,
    required this.titulo,
    required this.descricao,
  });
}
