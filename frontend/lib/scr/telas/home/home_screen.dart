import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/desktop_dashboard_view.dart';
import '../login/login_screen.dart';
import '../../widgets/home_dashboard_view.dart';

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

    if (isDesktop) {
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
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              backgroundColor: poliedroBlue,
              labelType: NavigationRailLabelType.none,
              indicatorColor: Colors.transparent,
              unselectedIconTheme: const IconThemeData(color: Colors.white, size: 44),
              selectedIconTheme: const IconThemeData(color: Colors.black, size: 44),
              minWidth: 75,
              groupAlignment: -1,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
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
            const Expanded(
              child: DesktopDashboardView(),
            ),
          ],
        ),
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
            icon: Icon(Icons.menu_book_outlined),
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