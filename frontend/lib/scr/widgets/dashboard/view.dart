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
          const Expanded(
            flex: 3,
            child: Column(
              children: [
                MensagensCard(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const Expanded(
            flex: 2,
            child: Column(
              children: [
                NotasCard(),
                SizedBox(height: 24),
                MateriaisCard(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const Expanded(
            flex: 3,
            child: Column(
              children: [
                AvisosCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}