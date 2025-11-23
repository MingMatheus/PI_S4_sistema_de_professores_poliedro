import 'package:flutter/material.dart';
import 'dashboard/notas_card.dart';
import 'dashboard/materiais_card.dart';
import 'dashboard/avisos_card.dart';

class DesktopDashboardView extends StatelessWidget {
  const DesktopDashboardView({
    super.key,
    required this.onSectionTap,
  });

  /// callback para mudar a aba no HomeScreen
  /// 1 = Materiais, 2 = Notas, 3 = Avisos
  final void Function(int index) onSectionTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        double scale = 1.0;
        if (w < 1366) scale = 0.96;
        if (w < 1180) scale = 0.90;

        const double outerGutterH = 0;
        const double outerGutterTop = 8;
        const double outerGutterBottom = 12;
        const double gap = 8.0;

        final double rightWidth = (w * 0.30).clamp(360.0, 520.0);
        final double leftWidth = w - rightWidth - gap;

        final double avisosMinHeight = w < 1366 ? 600 : 560;

        // COLUNA ESQUERDA (Notas e Materiais)
        final leftBlock = SizedBox(
          width: leftWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //  Notas clicável → index 2
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSectionTap(2),
                child: const _CappedHeight(child: NotasCard()),
              ),
              const SizedBox(height: gap),

              // Materiais clicável → index 1
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSectionTap(1),
                child: const MateriaisCard(),
              ),
            ],
          ),
        );

        // COLUNA DIREITA — Avisos clicável → index 3
        final rightBlock = SizedBox(
          width: rightWidth,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: avisosMinHeight),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSectionTap(3),
                child: const AvisosCard(),
              ),
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

class _CappedHeight extends StatelessWidget {
  const _CappedHeight({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 330),
      child: child,
    );
  }
}
