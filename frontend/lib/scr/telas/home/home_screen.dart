import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/desktop_dashboard_view.dart';
import '../../widgets/home_dashboard_view.dart';
import '../../widgets/main_layout.dart';
import '../login/login_screen.dart';

// telas
import 'materiais_screen.dart';
import 'notas_screen.dart';
import 'avisos_screen.dart'; // Avisos

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 720;

    // páginas das abas (DESKTOP)
    final List<Widget> pages = [
      DesktopDashboardView(
        onSectionTap: _onItemTapped, // <- home com cards clicáveis
      ),                              // 0 Início
      const MateriaisScreen(),        // 1 Materiais
      const NotasScreen(),            // 2 Notas
      const AvisosScreen(),           // 3 Avisos
    ];

    final int safeIndex = _selectedIndex.clamp(0, pages.length - 1);

    if (isDesktop) {
      return MainLayout(
        selectedIndex: safeIndex,
        onDestinationSelected: _onItemTapped,
        child: pages[safeIndex],
      );
    }

    return _buildMobileLayout(safeIndex);
  }

  Scaffold _buildMobileLayout(int safeIndex) {
    // páginas das abas (MOBILE)
    final List<Widget> mobileWidgetOptions = [
      HomeDashboardView(
        onSectionTap: _onItemTapped, // <- home com cards clicáveis
      ),                              // 0 Início
      const MateriaisScreen(),        // 1 Materiais
      const NotasScreen(),            // 2 Notas
      const AvisosScreen(),           // 3 Avisos
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
      body: mobileWidgetOptions[safeIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: poliedroBlue,
        elevation: 8,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.folder : Icons.folder_outlined,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.bar_chart : Icons.bar_chart_outlined,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.notifications
                  : Icons.notifications_none_outlined,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
