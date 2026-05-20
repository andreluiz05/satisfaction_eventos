import 'package:flutter/material.dart';


class SobreAppScreen extends StatelessWidget {
  const SobreAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo da Tecalli Tecnologia
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
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary,
              ),
            ),
            const Text(
              'Versão 1.0.0',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 30),

            // SESSÃO: O PROBLEMA (A DOR)
            _buildInfoCard(
              context,
              Icons.warning_rounded,
              'O Problema',
              'Gerenciar listas de convidados manualmente é um processo desorganizado, lento e suscetível a erros. A falta de comunicação centralizada entre anfitriões e convidados gera dores de cabeça, perda de controle e atrasos no dia do evento.',
            ),
            const SizedBox(height: 16),

            // SESSÃO: O OBJETIVO
            _buildInfoCard(
              context,
              Icons.track_changes_rounded,
              'Nosso Objetivo',
              'Proporcionar aos organizadores uma ferramenta digital rápida, segura e inteligente. O Satisfaction Eventos centraliza a gestão da festa e permite a confirmação de presença (RSVP) de forma simplificada através de códigos únicos.',
            ),
            const SizedBox(height: 16),

            // SESSÃO: DETALHES TÉCNICOS E SEGURANÇA
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
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Tecalli Tecnologia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              'DESENVOLVEDORES',
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            // André Luiz
            _buildDevCard('André Luiz', 'Fundador & Desenvolvedor', Icons.rocket_launch_rounded),
            const SizedBox(height: 12),
            // Ênio Enrique
            _buildDevCard('Enio Enrique', 'Desenvolvedor', Icons.code_rounded),
            const SizedBox(height: 12),
            // Emerson
            _buildDevCard('Emerson', 'Desenvolvedor', Icons.code_rounded),
            const SizedBox(height: 60),
            const Text(
              '© 2026 Tecalli Tecnologia. Todos os direitos reservados.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Molde para os Cartões de Informação (Dor, Objetivo, Técnico)
  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String description) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // Molde para os Cartões dos Desenvolvedores
  Widget _buildDevCard(String nome, String cargo, IconData icone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(15),
      ),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  cargo,
                  style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}