import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AvisosScreen extends StatelessWidget {
  const AvisosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    // === Fundo diagonal ===
    final bool isWide        = w >= 1200;            // desktop/notebook
    final bool isPhoneNarrow = w < 420;              // celulares estreitos
    final double imgScale    = isWide ? 1.32 : (isPhoneNarrow ? 1.42 : 1.12);
    final double imgOffsetY  = isWide ? 0 : (isPhoneNarrow ? 5 : -10);
    final double imgOffsetX  = 0.0;

    const bg = Color(0xFFF2F4F7);

    return Container(
      color: bg,
      child: Stack(
        children: [
          //  fundo (ancorado no canto inferior-direito)
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

          // conteúdo
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cw = constraints.maxWidth;

                // paddings iguais aos da Notas
                EdgeInsets pagePad = const EdgeInsets.fromLTRB(24, 18, 24, 28);
                double vSpace = 12;
                if (cw < 740 && cw >= 420) {
                  pagePad = const EdgeInsets.fromLTRB(20, 16, 20, 24);
                  vSpace = 10;
                } else if (cw < 420) {
                  pagePad = const EdgeInsets.fromLTRB(16, 14, 16, 24);
                  vSpace = 10;
                }

                final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.85),
                    );

                // FIX: garante altura mínima = viewport
                final double minBodyHeight =
                    constraints.maxHeight - pagePad.vertical;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: pagePad,
                  child: Container(
                    constraints: BoxConstraints(minHeight: minBodyHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Avisos', style: titleStyle),
                        const SizedBox(height: 10),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _avisos.length,
                          separatorBuilder: (_, __) => SizedBox(height: vSpace),
                          itemBuilder: (_, i) => _AvisoCard(
                            aviso: _avisos[i],
                            compact: cw < 420,
                          ),
                        ),

                        // respiro pra não encostar no bottom bar
                        const SizedBox(height: 8),
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

// ===== dados =====
class _Aviso {
  final String titulo;
  final String corpo;
  final String quando;
  final bool lido; // false = não lido (preto) | true = lido (azul)
  const _Aviso({
    required this.titulo,
    required this.corpo,
    required this.quando,
    required this.lido,
  });
}

const _avisos = <_Aviso>[
  _Aviso(
    titulo: 'Prof. Silva — Física',
    corpo:
        'Olá João. Recebi seu trabalho e gostei muito da sua análise. Continue assim!',
    quando: 'Hoje — 15:20',
    lido: false,
  ),
  _Aviso(
    titulo: 'Prof. Marina — Matemática',
    corpo:
        'Corrigi sua lista. Você melhorou muito nas últimas atividades, continue praticando!',
    quando: 'Ontem — 18:45',
    lido: false,
  ),
  _Aviso(
    titulo: 'Prof. Lucas — Química',
    corpo:
        'Ótimo desempenho no laboratório, sua explicação das ligações covalentes foi ótima.',
    quando: 'Ontem — 09:10',
    lido: true,
  ),
  _Aviso(
    titulo: 'Coordenação — Poliedro',
    corpo:
        'Lembrando que o prazo para entrega dos trabalhos de revisão termina sexta-feira.',
    quando: '01/10 — 11:00',
    lido: true,
  ),
];

// ===== card =====
class _AvisoCard extends StatelessWidget {
  final _Aviso aviso;
  final bool compact;
  const _AvisoCard({required this.aviso, this.compact = false});

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
      color: Colors.black.withOpacity(0.78),
      fontSize: compact ? 12 : 13,
      height: 1.22,
    );

    final infoStyle = txt.bodySmall!.copyWith(
      color: Colors.black.withOpacity(0.55),
      fontSize: compact ? 12 : 13,
    );

    final double iconSize = compact ? 20 : 22;
    final Color iconColor = aviso.lido ? poliedroBlue : Colors.black87;

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: pad,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(aviso.titulo,
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: titleStyle),
                ),
                Icon(Icons.notifications_rounded, size: iconSize, color: iconColor),
              ],
            ),
            const SizedBox(height: 6),
            Text(aviso.corpo,
                style: bodyStyle, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Container(height: 1, color: Colors.black.withOpacity(0.06)),
            const SizedBox(height: 6),
            Text(aviso.quando, style: infoStyle),
          ],
        ),
      ),
    );
  }
}
