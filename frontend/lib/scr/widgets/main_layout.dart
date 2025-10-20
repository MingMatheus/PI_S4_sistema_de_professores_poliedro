import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
// importa a tela de login (ajuste o caminho se o seu projeto for diferente)
import '../telas/login/login_screen.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const MainLayout({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  void _handleLogout(BuildContext context) {
    // se você tiver auth (ex.: FirebaseAuth), faça o signOut aqui antes de navegar:
    // await FirebaseAuth.instance.signOut();

    // navega para a tela de login e limpa todo o histórico (não permite voltar)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Portal Poliedro',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          IconButton(
            iconSize: 30,
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => _handleLogout(context),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: poliedroBlue,
            labelType: NavigationRailLabelType.none,
            indicatorColor: Colors.transparent,
            unselectedIconTheme: const IconThemeData(color: Colors.white, size: 44),
            selectedIconTheme: const IconThemeData(color: Colors.black, size: 44),
            minWidth: 75,
            groupAlignment: -1,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Início'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder_outlined),
                selectedIcon: Icon(Icons.folder),
                label: Text('Materiais'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text('Notas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.chat_bubble_outline),
                selectedIcon: Icon(Icons.chat_bubble),
                label: Text('Mensagens'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notifications_none_outlined),
                selectedIcon: Icon(Icons.notifications),
                label: Text('Avisos'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
