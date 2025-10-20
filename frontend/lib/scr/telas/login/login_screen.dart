import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  //  CONFIGURAÇÕES PRINCIPAIS DO CARD
  // Aqui você ajusta facilmente o tamanho e a distância da parte azul 
  final double cardWidth = 380;   //  largura do card
  final double cardHeight = 400;  //  altura do card
  final double cardTopSpacing = 94; //  distância do card até a faixa azul (mobile)

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // simulação
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: isSmallScreen
            ? _MobileLayout(
                buildCard: _buildLoginCard,
                cardTopSpacing: cardTopSpacing, // ← passa o espaçamento pro mobile
              )
            : _DesktopLayout(buildCard: _buildLoginCard),
      ),
    );
  }

  // ---------- CARD DE LOGIN ----------
  Widget _buildLoginCard({double? fixedWidth, double? fixedHeight}) {
    final form = Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.account_circle_outlined, size: 32, color: Colors.grey[600]),
          const SizedBox(height: 4),
          Text(
            'Acesso ao Portal Poliedro',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _emailController,
            label: 'E-mail',
            hint: 'Digite seu e-mail',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _senhaController,
            label: 'Senha',
            hint: 'Digite sua senha',
            isPassword: true,
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Esqueci minha senha',
                style: TextStyle(color: poliedroBlue, fontSize: 12.5),
              ),
            ),
          ),
          const SizedBox(height: 4),
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: poliedroPink))
              : ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: poliedroPink,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
          const SizedBox(height: 8),
        ],
      ),
    );

    final footer = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Text(
        '© 2024 Colégio Poliedro — Todos os direitos reservados.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[600], fontSize: 10.5),
      ),
    );

    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: cardWidth,   // ← usa o valor configurado lá em cima
        height: cardHeight, // ← idem
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Expanded(child: SingleChildScrollView(child: form)), footer],
        ),
      ),
    );
  }
}

// ---------- LAYOUT MOBILE ----------
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.buildCard,
    required this.cardTopSpacing,
  });

  final Widget Function({double? fixedWidth, double? fixedHeight}) buildCard;
  final double cardTopSpacing; // ← recebe o espaçamento configurável

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // FAIXA AZUL DE FORA A FORA
          Container(
            width: double.infinity,
            height: 190,
            color: poliedroBlue,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/logo.jpg',
              width: 110,
              fit: BoxFit.contain,
            ),
          ),

          // 🔧 AQUI É O ESPAÇAMENTO ENTRE O AZUL E O CARD
          SizedBox(height: cardTopSpacing),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: buildCard(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ---------- LAYOUT DESKTOP ----------
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.buildCard});
  final Widget Function({double? fixedWidth, double? fixedHeight}) buildCard;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            color: poliedroBlue,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  width: MediaQuery.of(context).size.width * 0.18,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 13,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: buildCard(fixedWidth: 480, fixedHeight: 360),
            ),
          ),
        ),
      ],
    );
  }
}
