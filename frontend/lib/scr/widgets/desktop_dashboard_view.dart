import 'package:flutter/material.dart';
import 'dashboard/avisos_card.dart';
import 'dashboard/materiais_card.dart';
import 'dashboard/mensagens_card.dart';
import 'dashboard/notas_card.dart';

class DesktopDashboardView extends StatelessWidget {
  const DesktopDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COLUNA ESQUERDA (Mensagens/Notas + Materiais)
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Linha interna para Mensagens e Notas
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(
                        flex: 1, // <<<<<< MUDANÇA APLICADA AQUI (de 5 para 1)
                        child: MensagensCard(),
                      ),
                      const SizedBox(width: 24),
                      const Expanded(
                        flex: 1, // <<<<<< MUDANÇA APLICADA AQUI (de 3 para 1)
                        child: NotasCard(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Card Materiais
                const MateriaisCard(),
              ],
            ),
          ),
          const SizedBox(width: 24), // Espaço entre as colunas principais

          // COLUNA DIREITA (Avisos)
          const Expanded(
            flex: 3,
            child: AvisosCard(),
          ),
        ],
      ),
    );
  }
}