import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard_tela.dart';
import '../perfil/perfil_tela.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _telas = [const Dashboard(), const PerfilScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _telas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) { HapticFeedback.selectionClick(); setState(() => _currentIndex = i); },
        elevation: 10,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded, color: Color(0xFF6A1B9A)), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: Color(0xFF6A1B9A)), label: 'Perfil'),
        ],
      ),
    );
  }
}