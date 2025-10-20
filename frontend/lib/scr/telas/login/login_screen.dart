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

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    // simulação de login
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: isSmallScreen
            ? _buildLoginForm(context)
            : Row(
                children: [
                  Expanded(
                    flex: 7, // Proporção do Figma: 672px -> flex 7
                    child: Container(
                      color: poliedroBlue,
                      child: Center(
                        // Usando ClipRRect para arredondar a imagem diretamente
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8), // Corner radius de 8
                              child: Image.asset(
                                'assets/images/logo.jpg',
                                width: constraints.maxWidth * 0.45, // 45% da largura da coluna azul
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 13, // Proporção do Figma: 1248px (resto) -> flex 13
                    child: Center(
                      child: SingleChildScrollView(
                        child: _buildLoginForm(context),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      // ##### DIMENSÕES DO FIGMA APLICADAS AQUI #####
      width: 600,   // LARGURA FIXA DE 600
      height: 500,  // ALTURA FIXA DE 500
      // ##### FIM DA MUDANÇA #####
      margin: const EdgeInsets.all(24.0),
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0), // Padding ajustado
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        // Alinha o conteúdo no centro verticalmente dentro da caixa de 500px
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Acesso ao Portal Poliedro',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: _emailController,
            label: 'E-mail',
            hint: 'Digite seu e-mail',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _senhaController,
            label: 'Senha',
            hint: 'Digite sua senha',
            isPassword: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Esqueci minha senha',
                style: TextStyle(color: poliedroBlue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: poliedroPink))
              : ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Entrar'),
                ),
          // O copyright foi removido daqui para não ficar preso no meio
          // Se quiser, podemos adicioná-lo fora da caixa
        ],
      ),
    );
  }
}