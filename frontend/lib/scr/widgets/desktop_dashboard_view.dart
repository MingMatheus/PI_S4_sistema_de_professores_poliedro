import 'package:flutter/material.dart';
import 'dashboard/avisos_card.dart';
import 'dashboard/materiais_card.dart';
import 'dashboard/mensagens_card.dart';
import 'dashboard/notas_card.dart';

class DesktopDashboardView extends StatelessWidget {
  const DesktopDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COLUNA ESQUERDA (Mensagens + Notas + Materiais)
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // linha superior (Mensagens e Notas com alturas iguais)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          Expanded(child: MensagensCard()),
                          SizedBox(width: 24),
                          Expanded(child: NotasCard()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const MateriaisCard(),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // COLUNA DIREITA (Avisos vai até embaixo)
              Flexible(
                flex: 3,
                child: SizedBox(
                  height: constraints.maxHeight - 48, // 24 top + 24 bottom
                  child: const AvisosCard(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
