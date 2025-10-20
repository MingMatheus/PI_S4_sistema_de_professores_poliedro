import 'package:flutter/material.dart';
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
    setState(() {
      _selectedIndex = index;
    });
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
      body: mobileWidgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            label: 'Materiais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Notas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            label: 'Avisos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}