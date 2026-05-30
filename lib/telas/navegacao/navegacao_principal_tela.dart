import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard_tela.dart';
import '../perfil/perfil_tela.dart';
import '../../tema/navegacao_principal_tela_estilo.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _telas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          HapticFeedback.selectionClick();
          setState(() => _currentIndex = i);
        },
        elevation: 10,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(
              Icons.dashboard_rounded,
              color: NavegacaoPrincipalEstilo.corIconeSelecionado(theme),
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person,
              color: NavegacaoPrincipalEstilo.corIconeSelecionado(theme),
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
