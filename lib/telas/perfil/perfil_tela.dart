import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../autenticacao/login_tela.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/imagens/logo_marca.png', height: 28),
            const SizedBox(width: 12),
            Text('Meu Perfil', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 24)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: theme.colorScheme.primary, width: 2)),
                child: CircleAvatar(
                  radius: 50, 
                  backgroundColor: theme.colorScheme.primary.withAlpha(25), 
                  child: Icon(Icons.person, size: 50, color: theme.colorScheme.primary)
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Organizador(a)', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 4),
            const Text('admin@satisfaction.com', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            const SizedBox(height: 40),
            
            _menuItem(context, Icons.edit_rounded, 'Editar Dados', theme),
            _menuItem(context, Icons.security_rounded, 'Privacidade e Senha', theme),
            _menuItem(context, Icons.help_outline_rounded, 'Suporte e Ajuda', theme),
            
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444).withAlpha(25), 
                  foregroundColor: const Color(0xFFEF4444), 
                  elevation: 0, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
                onPressed: () { 
                  HapticFeedback.heavyImpact(); 
                  // Limpa a pilha de navegação e volta para o login
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false
                  ); 
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('SAIR DA CONTA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4))]),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: theme.colorScheme.primary.withAlpha(25), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: theme.colorScheme.primary)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Função disponível na versão premium.')));
        },
      ),
    );
  }
}