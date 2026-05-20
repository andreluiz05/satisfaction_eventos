import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../autenticacao/login_tela.dart';
import '../../backend/controlers/login_controlador.dart';
import 'editar_dados.dart';
import 'privacidade_senha_tela.dart';
import 'sobre_app_tela.dart';
import 'suporte_ajuda_tela.dart';

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
            Text(
              'Meu Perfil',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary.withAlpha(25),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              LoginControlador.instance.current?.nome ?? 'Organizador(a)',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              LoginControlador.instance.current?.email ?? '',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            _menuItem(
              context,
              Icons.edit_rounded,
              'Editar Dados',
              theme,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditarDadosPage()),
                );
              },
            ),
            _menuItem(
              context,
              Icons.security_rounded,
              'Privacidade e Senha',
              theme,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacidadeSenhaScreen()),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.help_outline_rounded, color: theme.colorScheme.primary),
                ),
                title: Text(
                  'Suporte e Ajuda',
                  style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SuporteAjudaScreen()),
                  );
                },
              ),
            ),

            // NOVO BOTÃO SOBRE O APP (Tecalli Tecnologia)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary),
                ),
                title: Text(
                  'Sobre o App',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SobreAppScreen()),
                  );
                },
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444).withAlpha(25),
                  foregroundColor: const Color(0xFFEF4444),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  // Limpa a pilha de navegação e volta para o login
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  'SAIR DA CONTA',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    ThemeData theme, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap ?? () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Função disponível na versão premium.'),
            ),
          );
        },
      ),
    );
  }
}
