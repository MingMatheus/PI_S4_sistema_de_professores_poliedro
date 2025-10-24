import 'package:flutter/material.dart';
import './avisos_card.dart';
import './materiais_card.dart';
import './mensagens_card.dart';
import './notas_card.dart';

class DesktopDashboardView extends StatelessWidget {
  const DesktopDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column( // Layout principal agora é uma Coluna
        children: [
          // Linha de Cima
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 5, // Proporção pode ser ajustada
                child: MensagensCard(),
              ),
              const SizedBox(width: 24),
              const Expanded(
                flex: 3, // Proporção pode ser ajustada
                child: NotasCard(),
              ),
            ],
          ),
          const SizedBox(height: 24), // Espaço entre as linhas

          // Linha de Baixo
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 5, // Ocupa mais espaço
                child: MateriaisCard(),
              ),
              const SizedBox(width: 24),
              const Expanded(
                flex: 3, // Ocupa menos espaço
                child: AvisosCard(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}