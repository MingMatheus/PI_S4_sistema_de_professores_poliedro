import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../login/login_screen.dart';

import '../../widgets/professor/turmas_card.dart';
import '../../widgets/professor/materiais_card.dart';
import '../../widgets/professor/atividades_card.dart';
import '../../widgets/professor/notas_card.dart';
import '../../widgets/professor/avisos_card.dart';

class ProfessorHomeScreen extends StatelessWidget {
  const ProfessorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: poliedroBlue,
        elevation: 2,
        title: const Text(
          'Portal Poliedro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),
      body: isMobile
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context, size),
    );
  }

  // ================= DESKTOP =================
  Widget _buildDesktopLayout(BuildContext context, Size size) {
    final width = size.width;
    final crossAxisCount = width > 1400 ? 3 : 2;

    return Row(
      children: [
        // coluna esquerda: título + grid de cards
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 18, 32, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Painel do Professor',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.6,
                    children: const [
                      ProfessorTurmasCard(),
                      ProfessorMateriaisCard(),
                      ProfessorAtividadesCard(),
                      ProfessorNotasCard(),
                      ProfessorAvisosCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // coluna direita: logo fixa no azul
        Container(
          width: 260,
          color: poliedroBlue,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo.jpg',
                width: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= MOBILE =================
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // faixa azul com logo + título (igual vibe Poliedro)
        Container(
          width: double.infinity,
          color: poliedroBlue,
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.jpg',
                width: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              const Text(
                'Painel do Professor',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // cards empilhados
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: const [
                ProfessorTurmasCard(),
                SizedBox(height: 10),
                ProfessorMateriaisCard(),
                SizedBox(height: 10),
                ProfessorAtividadesCard(),
                SizedBox(height: 10),
                ProfessorNotasCard(),
                SizedBox(height: 10),
                ProfessorAvisosCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
