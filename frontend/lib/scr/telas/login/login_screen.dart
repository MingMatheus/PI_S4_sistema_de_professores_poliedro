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
  // Alterado de _raController para _emailController
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
    // Para criar um layout que se adapta ao tamanho da tela
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      // Usamos a cor de fundo do seu tema aqui
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: isSmallScreen
            ? _buildLoginForm(context) // Mostra só o formulário em telas pequenas
            : Row(
                children: [
                  // Coluna da Esquerda (Azul com a Logo)
                  Expanded(
                    flex: 1, // Ocupa 1/3 da tela
                    child: Container(
                      color: poliedroBlue, // Cor definida em app_colors.dart
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(32.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          // CORRIGIDO: Adicionado a extensão .jpg
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            width: 180, // Tamanho da imagem
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Coluna da Direita (Branca com o Formulário)
                  Expanded(
                    flex: 2, // Ocupa 2/3 da tela
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

  // Widget separado para o formulário, para reutilização e organização
  Widget _buildLoginForm(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.all(24.0), // Margem para telas pequenas
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
        mainAxisSize: MainAxisSize.min,
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

          // ALTERADO: Campo de RA para E-mail
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
          const SizedBox(height: 32),
          Text(
            '© 2025 Colégio Poliedro – Todos os direitos reservados',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}