import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MateriaisScreen extends StatelessWidget {
  const MateriaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    // ======= CONTROLES DA IMAGEM 
    final bool isWide = w >= 1200;

    // ↑ escala maior para telas grandes
    final double imgScale = isWide ? 1.32 : 1.12;

    // ↓ empurra a imagem PARA BAIXO (positivo = desce)
    //   se quiser subir, usa valor negativo
    final double imgOffsetY = isWide ? 150 : 90;

    // → empurra um pouco para a direita/esquerda 
    final double imgOffsetX = 0; // deixa 0 se não quiser mexer
    // ============================================================

    const bg = Color(0xFFF2F4F7);

    return Container(
      color: bg,
      child: Stack(
        children: [
          // 🔵 FUNDO: imagem inteira, ancorada no canto inferior-direito,
          // ampliada e DESCIDA alguns pixels
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                  offset: Offset(imgOffsetX, imgOffsetY), // ↓ desce
                  child: Transform.scale(
                    scale: imgScale, // ↑ aumenta
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      'assets/images/poliedro_diagonal.png',
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🔹 CONTEÚDO
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;

                // 4 colunas no desktop, menores no resto
                late int cross;
                late double aspect;

                if (w >= 1400) {
                  cross = 4; aspect = 2.8;
                } else if (w >= 1080) {
                  cross = 4; aspect = 2.6;
                } else if (w >= 740) {
                  cross = 2; aspect = 2.2;
                } else {
                  cross = 1; aspect = 1.8;
                }

                final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.85),
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Materiais de aula', style: titleStyle),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _materias.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cross,
                          childAspectRatio: aspect,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (_, i) => _MateriaCard(m: _materias[i]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -------- MOCK --------
class _Materia {
  final String nome, professor, quando;
  const _Materia(this.nome, this.professor, this.quando);
}

const _materias = <_Materia>[
  _Materia('Matemática', 'Carlos de Almeida', 'Hoje 09:15'),
  _Materia('Português', 'Ângela dos Santos', 'Ontem 16:30'),
  _Materia('Geografia', 'Alexandre Matos', 'Ontem 11:22'),
  _Materia('História', 'Roberto Montenegro', 'Sex 14:00'),
  _Materia('Química', 'Isabelle Vieira', 'Hoje 11:05'),
  _Materia('Física', 'Paulo Machado', 'Qui 18:00'),
  _Materia('Biologia', 'Maria Conceição', 'Sex 08:47'),
  _Materia('Filosofia', 'Ricardo Oliveira', 'Hoje 10:30'),
  _Materia('Sociologia', 'Juliana Costa', 'Ontem 14:00'),
];

// -------- CARD --------
class _MateriaCard extends StatelessWidget {
  final _Materia m;
  const _MateriaCard({required this.m});

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                m.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: txt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: DefaultTextStyle(
                  style: txt.bodySmall!.copyWith(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 13,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prof. ${m.professor}', maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(m.quando, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.open_in_new_rounded, size: 18, color: poliedroBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
