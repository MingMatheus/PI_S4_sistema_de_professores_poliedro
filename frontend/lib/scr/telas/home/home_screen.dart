import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/desktop_dashboard_view.dart';
import '../../widgets/home_dashboard_view.dart';
import '../../widgets/main_layout.dart';
import '../login/login_screen.dart';

// telas
import 'materiais_screen.dart';
import 'notas_screen.dart'; // ⬅️ nova tela de Notas

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

    // páginas (4 abas: Início, Materiais, Notas, Avisos)
    final List<Widget> pages = [
      const DesktopDashboardView(),   // 0 Início
      const MateriaisScreen(),        // 1 Materiais
      const NotasScreen(),            // 2 Notas ✅
      const Center(child: Text('Página de Avisos')), // 3 Avisos (placeholder)
    ];

    final safeIndex = _selectedIndex.clamp(0, pages.length - 1);

    if (isDesktop) {
      return MainLayout(
        selectedIndex: safeIndex,
        onDestinationSelected: _onItemTapped,
        child: pages[safeIndex],
      );
    } else {
      return _buildMobileLayout(safeIndex);
    }
  }

  Scaffold _buildMobileLayout(int safeIndex) {
    final List<Widget> mobileWidgetOptions = <Widget>[
      const HomeDashboardView(),  // 0
      const MateriaisScreen(),    // 1
      const NotasScreen(),        // 2 ✅
      const Center(child: Text('Página de Avisos')), // 3
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Poliedro', style: TextStyle(fontSize: 22)),
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
      body: mobileWidgetOptions[safeIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: poliedroBlue,
        elevation: 8,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1 ? Icons.folder : Icons.folder_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2 ? Icons.bar_chart : Icons.bar_chart_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 3
                ? Icons.notifications
                : Icons.notifications_none_outlined),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
