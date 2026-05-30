import 'package:flutter/material.dart';
import '../../tema/sobre_app_tela_estilo.dart';

class SobreAppScreen extends StatelessWidget {
  const SobreAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App', style: SobreAppTelaEstilo.estiloTituloAppBar),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/imagens/tecalli_tecnologia.png',
                height: 130,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Satisfaction Eventos',
              style: SobreAppTelaEstilo.estiloTituloApp(theme.colorScheme),
            ),
            const Text(
              'Versão 1.0.0',
              style: SobreAppTelaEstilo.estiloVersao,
            ),
            
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 30),

            _buildInfoCard(
              context,
              Icons.warning_rounded,
              'O Problema',
              'Gerenciar listas de convidados manualmente é um processo desorganizado, lento e suscetível a erros. A falta de comunicação centralizada entre anfitriões e convidados gera dores de cabeça, perda de controle e atrasos no dia do evento.',
            ),
            const SizedBox(height: 16),

            _buildInfoCard(
              context,
              Icons.track_changes_rounded,
              'Nosso Objetivo',
              'Proporcionar aos organizadores uma ferramenta digital rápida, segura e inteligente. O Satisfaction Eventos centraliza a gestão da festa e permite a confirmação de presença (RSVP) de forma simplificada através de códigos únicos.',
            ),
            const SizedBox(height: 16),

            _buildInfoCard(
              context,
              Icons.security_rounded,
              'Tecnologia e Segurança',
              '• Construído em Flutter (Dart) para alta performance.\n'
              '• Sincronização em tempo real via Firebase Realtime Database.\n'
              '• Arquitetura Multitenant (Isolamento de dados por Anfitrião).\n'
              '• Segurança de dados com hash de senhas via BCrypt.',
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 30),

            const Text(
              'Este aplicativo foi desenvolvido com excelência pela',
              textAlign: TextAlign.center,
              style: SobreAppTelaEstilo.estiloTextoRodape1,
            ),
            const Text(
              'Tecalli Tecnologia',
              style: SobreAppTelaEstilo.estiloTextoRodape2,
            ),
            const SizedBox(height: 40),
            const Text(
              'DESENVOLVEDORES',
              style: SobreAppTelaEstilo.estiloCabecalhoDevs,
            ),
            const SizedBox(height: 16),
            _buildDevCard('André Luiz', 'Fundador & Desenvolvedor', Icons.rocket_launch_rounded),
            const SizedBox(height: 12),
            _buildDevCard('Enio Enrique', 'Desenvolvedor', Icons.code_rounded),
            const SizedBox(height: 12),
            _buildDevCard('Emerson', 'Desenvolvedor', Icons.code_rounded),
            const SizedBox(height: 60),
            const Text(
              '© 2026 Tecalli Tecnologia. Todos os direitos reservados.',
              textAlign: TextAlign.center,
              style: SobreAppTelaEstilo.estiloCopyright,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String description) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: SobreAppTelaEstilo.decoracaoCardInfo(theme.colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: SobreAppTelaEstilo.estiloTituloCardInfo(theme.colorScheme),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: SobreAppTelaEstilo.estiloDescricaoCardInfo(theme.colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildDevCard(String nome, String cargo, IconData icone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: SobreAppTelaEstilo.decoracaoCardDev,
      child: Row(
        children: [
          Icon(icone, color: const Color(0xFF6A1B9A), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: SobreAppTelaEstilo.estiloNomeDev,
                ),
                const SizedBox(height: 4),
                Text(
                  cargo,
                  style: SobreAppTelaEstilo.estiloCargoDev,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
