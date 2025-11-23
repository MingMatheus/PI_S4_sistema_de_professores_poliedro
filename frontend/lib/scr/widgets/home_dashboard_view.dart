import 'package:flutter/material.dart';
import 'dashboard/materiais_card.dart';
import 'dashboard/notas_card.dart';
import 'dashboard/avisos_card.dart';

/// Dashboard MOBILE (Mensagens removido)
/// 1) Materiais de aula
/// 2) Notas e Médias
/// 3) Últimos avisos
class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({
    super.key,
    required this.onSectionTap,
  });

  /// callback que avisa qual seção o usuário clicou
  /// 1 = Materiais, 2 = Notas, 3 = Avisos (seguindo HomeScreen)
  final void Function(int index) onSectionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F4F7),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MateriaisCard(),
              const SizedBox(height: 12),

              const NotasCard(),
              const SizedBox(height: 12),

              //  card Avisos clicável (leva para aba 3)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSectionTap(3),
                child: const AvisosCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
