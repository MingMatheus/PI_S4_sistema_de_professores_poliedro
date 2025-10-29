import 'package:flutter/material.dart';
import 'dashboard/mensagens_card.dart';
import 'dashboard/notas_card.dart';
import 'dashboard/materiais_card.dart';
import 'dashboard/avisos_card.dart';

class DesktopDashboardView extends StatelessWidget {
  const DesktopDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        // escala leve para telas menores
        double scale = 1.0;
        if (w < 1366) scale = 0.96;
        if (w < 1180) scale = 0.90;

        // margens laterais e espaçamento
        const double outerGutterH = 0;
        const double outerGutterTop = 8;
        const double outerGutterBottom = 12;
        const double gap = 8.0;

        // proporções
        final double rightWidth = (w * 0.30).clamp(360.0, 520.0);
        final double leftWidth = w - rightWidth - gap;

        // aumenta um pouco mais o card de avisos pra igualar Materiais
        final double avisosMinHeight = w < 1366 ? 620 : 560;

        // COLUNA ESQUERDA: mensagens, notas e materiais
        Widget leftBlock = SizedBox(
          width: leftWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Expanded(child: _CappedHeight(child: MensagensCard())),
                    SizedBox(width: gap),
                    Expanded(child: _CappedHeight(child: NotasCard())),
                  ],
                ),
              ),
              const SizedBox(height: gap),
              const MateriaisCard(),
            ],
          ),
        );

        // COLUNA DIREITA: últimos avisos
        Widget rightBlock = SizedBox(
          width: rightWidth,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: avisosMinHeight, // 🔹 agora desce mais
              ),
              child: const AvisosCard(),
            ),
          ),
        );

        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              outerGutterH, outerGutterTop, outerGutterH, outerGutterBottom),
            child: Transform.scale(
              alignment: Alignment.topCenter,
              scale: scale,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: w),
                child: Stack(
                  children: [
                    // base das duas colunas
                    SizedBox(
                      width: w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: leftWidth, child: leftBlock),
                          const SizedBox(width: gap),
                          SizedBox(width: rightWidth),
                        ],
                      ),
                    ),

                    // avisos posicionados na borda direita
                    Positioned(
                      top: 0,
                      right: 0,
                      width: rightWidth,
                      child: rightBlock,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// limita a altura dos cards de Mensagens e Notas
class _CappedHeight extends StatelessWidget {
  const _CappedHeight({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 315),
      child: child,
    );
  }
}
