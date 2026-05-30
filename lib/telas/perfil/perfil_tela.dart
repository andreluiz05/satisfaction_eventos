import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tema/perfil_tela_estilo.dart';
import '../autenticacao/login_tela.dart';
import '../../backend/controllers/login_controlador.dart';
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
              style: PerfilTelaEstilo.estiloTituloAppBar(theme.colorScheme),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: PerfilTelaEstilo.decoracaoAvatar(theme.colorScheme),
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
              style: PerfilTelaEstilo.estiloNome(theme.colorScheme),
            ),
            const SizedBox(height: 4),
            Text(
              LoginControlador.instance.current?.email ?? '',
              style: PerfilTelaEstilo.estiloEmail,
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
              decoration: PerfilTelaEstilo.decoracaoItemMenu(theme.colorScheme),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: PerfilTelaEstilo.decoracaoIconeMenu(theme.colorScheme),
                  child: Icon(Icons.help_outline_rounded, color: theme.colorScheme.primary),
                ),
                title: Text(
                  'Suporte e Ajuda',
                  style: PerfilTelaEstilo.estiloTituloMenu(theme.colorScheme),
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
              decoration: PerfilTelaEstilo.decoracaoItemMenu(theme.colorScheme),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: PerfilTelaEstilo.decoracaoIconeMenu(theme.colorScheme),
                  child: Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary),
                ),
                title: Text(
                  'Sobre o App',
                  style: PerfilTelaEstilo.estiloTituloMenu(theme.colorScheme),
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

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: PerfilTelaEstilo.estiloBotaoSair(),
                onPressed: () async {
                  HapticFeedback.heavyImpact();
                  await LoginControlador.instance.signOut();
                  if (!context.mounted) return;
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
                  style: PerfilTelaEstilo.textoBotaoSair,
                ),
              ),
            ),
            const SizedBox(height: 12),
      
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
      decoration: PerfilTelaEstilo.decoracaoItemMenu(theme.colorScheme),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: PerfilTelaEstilo.decoracaoIconeMenu(theme.colorScheme),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(
          title,
          style: PerfilTelaEstilo.estiloTituloMenu(theme.colorScheme),
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
