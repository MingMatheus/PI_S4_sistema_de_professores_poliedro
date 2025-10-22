import 'package:flutter/material.dart';
import 'dashboard/materiais_card.dart';
import 'dashboard/notas_card.dart';
import 'dashboard/mensagens_card.dart';
import 'dashboard/avisos_card.dart';

/// Dashboard MOBILE
/// Ordem dos cards:
/// 1) Materiais de aula
/// 2) Notas e Médias
/// 3) Mensagens
/// 4) Últimos avisos
class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F4F7), // fundo clarinho igual ao mock
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              MateriaisCard(),
              SizedBox(height: 12),

              NotasCard(),
              SizedBox(height: 12),

              MensagensCard(),
              SizedBox(height: 12),

              AvisosCard(),
            ],
          ),
        ),
      ),
    );
  }
}
