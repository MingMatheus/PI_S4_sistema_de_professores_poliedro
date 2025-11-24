import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../home/professor_home_screen.dart'; // ← import da nova tela a dos fessor
import '../home/home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../utils/url.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  // CONFIGURAÇÕES PRINCIPAIS DO CARD
  final double cardWidth = 380;
  final double cardHeight = 400;
  final double cardTopSpacing = 94;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final url = Uri.parse("${getApiBaseUrl()}/api/auth/login");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      setState(() => _isLoading = false);

      if(response.statusCode == 200)
      {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // Salva o token JWT
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        // Redireciona para a tela do PROFESSOR (temporário)
        if (!mounted) return;

        Map<String, dynamic> tokenPayload = JwtDecoder.decode(token);
        String role = tokenPayload["role"];

        if(role == "professor")
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProfessorHomeScreen()),
          );
        }
        else
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
      else
      {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['mensagem'] ?? 'Falha no login')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao conectar com o servidor.')),
      );
    }
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
                cardTopSpacing: cardTopSpacing,
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
        width: cardWidth,
        height: cardHeight,
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
  final double cardTopSpacing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
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
