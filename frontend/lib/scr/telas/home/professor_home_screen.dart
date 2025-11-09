import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../login/login_screen.dart';

class ProfessorHomeScreen extends StatelessWidget {
  const ProfessorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

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

      // ============ BODY =============
      body: isMobile
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context, size),
    );
  }

  // ============ DESKTOP =============
  Widget _buildDesktopLayout(BuildContext context, Size size) {
    return Row(
      children: [
        // ==== COLUNA ESQUERDA ====
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Painel do Professor',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: size.width > 1300 ? 3 : 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.8, // ← deixa os cards mais retangulares
                    children: const [
                      _ProfessorCard(
                        color: Color(0xFF1976D2),
                        icon: Icons.people_alt_rounded,
                        title: 'Turmas',
                        subtitle:
                            'Criar, editar e gerenciar turmas e alunos.',
                      ),
                      _ProfessorCard(
                        color: Color(0xFF43A047),
                        icon: Icons.menu_book_rounded,
                        title: 'Materiais',
                        subtitle:
                            'Publicar e editar materiais de aula e apostilas.',
                      ),
                      _ProfessorCard(
                        color: Color(0xFF7E57C2),
                        icon: Icons.assignment_rounded,
                        title: 'Atividades',
                        subtitle:
                            'Publicar e corrigir atividades dos alunos.',
                      ),
                      _ProfessorCard(
                        color: Color(0xFFFFB300),
                        icon: Icons.star_rate_rounded,
                        title: 'Notas',
                        subtitle:
                            'Lançar e editar notas de provas e atividades.',
                      ),
                      _ProfessorCard(
                        color: Color(0xFFE53935),
                        icon: Icons.campaign_rounded,
                        title: 'Avisos',
                        subtitle:
                            'Publicar comunicados e mensagens para as turmas.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ==== COLUNA DIREITA (LOGO) ====
        Container(
          width: 300,
          color: poliedroBlue,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(18),
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
                width: 170,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============ MOBILE =============
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: poliedroBlue,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.jpg',
                width: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text(
                'Painel do Professor',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: const [
                _ProfessorCard(
                  color: Color(0xFF1976D2),
                  icon: Icons.people_alt_rounded,
                  title: 'Turmas',
                  subtitle: 'Criar, editar e gerenciar turmas e alunos.',
                ),
                SizedBox(height: 12),
                _ProfessorCard(
                  color: Color(0xFF43A047),
                  icon: Icons.menu_book_rounded,
                  title: 'Materiais',
                  subtitle: 'Publicar e editar materiais de aula e apostilas.',
                ),
                SizedBox(height: 12),
                _ProfessorCard(
                  color: Color(0xFF7E57C2),
                  icon: Icons.assignment_rounded,
                  title: 'Atividades',
                  subtitle: 'Publicar e corrigir atividades dos alunos.',
                ),
                SizedBox(height: 12),
                _ProfessorCard(
                  color: Color(0xFFFFB300),
                  icon: Icons.star_rate_rounded,
                  title: 'Notas',
                  subtitle: 'Lançar e editar notas de provas e atividades.',
                ),
                SizedBox(height: 12),
                _ProfessorCard(
                  color: Color(0xFFE53935),
                  icon: Icons.campaign_rounded,
                  title: 'Avisos',
                  subtitle:
                      'Publicar comunicados e mensagens para as turmas.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ======== COMPONENTE DE CARD ========
class _ProfessorCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ProfessorCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  State<_ProfessorCard> createState() => _ProfessorCardState();
}

class _ProfessorCardState extends State<_ProfessorCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _hovering
                  ? widget.color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.07),
              blurRadius: _hovering ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: _hovering
                ? widget.color.withOpacity(0.5)
                : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              widget.icon,
              size: 32,
              color: _hovering ? widget.color : Colors.grey.shade700,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: _hovering ? widget.color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
