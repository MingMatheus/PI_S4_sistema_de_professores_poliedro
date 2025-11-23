import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MateriaisScreen extends StatelessWidget {
  const MateriaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    // ===== fundo diagonal =====
    final bool isWide   = w >= 1200;
    final bool isPhoneNarrow = w < 420;

    final double imgScale   = isWide ? 1.32 : (isPhoneNarrow ? 1.42 : 1.12);
    final double imgOffsetY = isWide ? 195  : (isPhoneNarrow ? 5 : -10);
    final double imgOffsetX = 0.0;

    const bg = Color(0xFFF2F4F7);

    return Container(
      color: bg,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.bottomRight,
                child: OverflowBox(
                  minWidth: 0, minHeight: 0,
                  maxWidth: double.infinity, maxHeight: double.infinity,
                  alignment: Alignment.bottomRight,
                  child: Transform.translate(
                    offset: Offset(imgOffsetX, imgOffsetY),
                    child: Transform.scale(
                      scale: imgScale,
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
          ),

          // =================== conteúdo ===================
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;

                // breakpoints (desktop intacto)
                late int cross;
                late double aspect;
                EdgeInsets pagePad = const EdgeInsets.fromLTRB(24, 18, 24, 28);
                double hSpace = 12, vSpace = 12;

                if (w >= 1400) {
                  cross = 4; aspect = 2.8;
                } else if (w >= 1080) {
                  cross = 4; aspect = 2.6;
                } else if (w >= 740) {
                  cross = 2; aspect = 2.2;
                } else if (w >= 420) {
                  // phones/mini-tablets “largos”: 2 colunas
                  cross = 2; aspect = 2.35;
                  pagePad = const EdgeInsets.fromLTRB(20, 16, 20, 24);
                  hSpace = 10; vSpace = 10;
                } else {
                  //  very-narrow phones (ex.: 320px): 1 coluna = sem overflow
                  cross = 1; aspect = 3.6;
                  pagePad = const EdgeInsets.fromLTRB(16, 14, 16, 24);
                  hSpace = 10; vSpace = 10;
                }

                final titleStyle = Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700,
                               color: Colors.black.withOpacity(0.85));

                // Garante que o conteúdo ocupe no mínimo a altura da tela
                final double minBodyHeight = c.maxHeight - pagePad.vertical;

                return SingleChildScrollView(
                  padding: pagePad,
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(minHeight: minBodyHeight),
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
                            crossAxisSpacing: hSpace,
                            mainAxisSpacing:  vSpace,
                          ),
                          itemBuilder: (_, i) => _MateriaCard(
                            m: _materias[i],
                            compact: w < 420, // modo compacto só no cel estreito
                          ),
                        ),
                      ],
                    ),
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
  final bool compact; // ← ativa no cel estreito (<420)
  const _MateriaCard({required this.m, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final EdgeInsets pad = compact
        ? const EdgeInsets.fromLTRB(12, 10, 10, 8)
        : const EdgeInsets.fromLTRB(12, 10, 10, 8);

    final titleStyle = txt.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: compact ? 14 : txt.titleMedium?.fontSize,
      height: compact ? 1.08 : null,
    );

    final bodyStyle = txt.bodySmall!.copyWith(
      color: Colors.black.withOpacity(0.75),
      fontSize: compact ? 12 : 13,
      height: compact ? 1.18 : 1.22,
    );

    final double iconSize = compact ? 18 : 18;

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Padding(
          padding: pad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle),
              const SizedBox(height: 4),
              Expanded(
                child: DefaultTextStyle(
                  style: bodyStyle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prof. ${m.professor}',
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(m.quando,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.open_in_new_rounded,
                    size: iconSize, color: poliedroBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
