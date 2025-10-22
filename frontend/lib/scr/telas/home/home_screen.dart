import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/desktop_dashboard_view.dart';
import '../../widgets/home_dashboard_view.dart';
import '../../widgets/main_layout.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 720;

    final List<Widget> pages = [
      const DesktopDashboardView(),
      const Center(child: Text('Página de Materiais')),
      const Center(child: Text('Página de Notas')),
      const Center(child: Text('Página de Mensagens')),
      const Center(child: Text('Página de Avisos')),
    ];

    if (isDesktop) {
      return MainLayout(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        child: pages[_selectedIndex],
      );
    } else {
      return _buildMobileLayout();
    }
  }

  Scaffold _buildMobileLayout() {
    final List<Widget> mobileWidgetOptions = <Widget>[
      const HomeDashboardView(),
      const Center(child: Text('Página de Materiais')),
      const Center(child: Text('Página de Notas')),
      const Center(child: Text('Página de Mensagens')),
      const Center(child: Text('Página de Avisos')),
    ];

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
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: mobileWidgetOptions[_selectedIndex],

      // ──────────────── NAVBAR INFERIOR ────────────────
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: poliedroBlue,
        elevation: 8,
        showSelectedLabels: false,
        showUnselectedLabels: false,

        // cores gerais
        selectedItemColor: Colors.black, // ícone ativo preto sólido
        unselectedItemColor: Colors.white, // ícones inativos brancos

        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0
                  ? Icons.home // filled
                  : Icons.home_outlined, // outline
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1
                  ? Icons.folder // filled
                  : Icons.folder_outlined,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2
                  ? Icons.bar_chart // filled
                  : Icons.bar_chart_outlined,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.chat_bubble // filled
                  : Icons.chat_bubble_outline,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 4
                  ? Icons.notifications // filled
                  : Icons.notifications_none_outlined,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
