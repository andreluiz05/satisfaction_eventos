import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SuporteAjudaScreen extends StatelessWidget { // (Pode ser StatefulWidget também, dependendo de como você criou)
  const SuporteAjudaScreen({super.key});

  // =========================================================
  // 2. COLE AS SUAS FUNÇÕES AQUI (Dentro da classe, antes do build)
  // =========================================================

  // Função para abrir o WhatsApp externamente
  Future<void> chamarNoWhatsApp() async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/5531998235716");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }

  // Função para abrir o aplicativo de E-mail
  Future<void> enviarEmail() async {
    final Uri emailUrl = Uri(
      scheme: 'mailto',
      path: 'tecalli.oficial@gmail.com',
      queryParameters: {'subject': 'Suporte - Satisfaction Eventos'},
    );
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suporte e Ajuda', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho Visual
            Center(
              child: Icon(Icons.help_outline_rounded, size: 80, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Como podemos ajudar?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 32),

            // SESSÃO DE FAQ (Perguntas Frequentes)
            Text(
              'PERGUNTAS FREQUENTES',
              style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            
            _buildFaqItem(
              theme,
              'Como criar um novo evento?',
              'Na sua Dashboard (tela inicial), clique no botão flutuante "NOVO EVENTO". Preencha os dados e salve. O aplicativo gerará um código de 6 dígitos automaticamente para esta festa.',
            ),
            _buildFaqItem(
              theme,
              'Como o convidado confirma presença?',
              'Basta enviar o código do seu evento para o convidado. Na tela de login do app, ele deve selecionar a aba "Convidado", inserir o código e o e-mail para confirmar ou recusar o convite.',
            ),
            _buildFaqItem(
              theme,
              'Posso acessar os eventos de outro anfitrião?',
              'Não. O sistema garante privacidade total. Você só tem acesso aos eventos que você mesmo criou com a sua conta.',
            ),

            const SizedBox(height: 32),

            // SESSÃO DE CONTATO (Atualizada Tecalli)
            Text(
              'Entre em Suporte conosco',
              style: TextStyle(letterSpacing: 0.5, fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              'Para elogios, reportar bugs e outras coisas.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 16),
            
            // Card do Gmail Oficial com link mailto
            _buildContactCard(
              context,
              theme,
              Icons.email_outlined,
              'E-mail',
              'tecalli.oficial@gmail.com',
              'Enviar e-mail',
              enviarEmail,
            ),
            const SizedBox(height: 12),
            
            // Card do WhatsApp Oficial com link direto
            _buildContactCard(
              context,
              theme,
              Icons.chat_bubble_outline_rounded,
              'WhatsApp',
              '+55 31 99823-5716',
              'Chamar no Zap',
              chamarNoWhatsApp,
            ),
          ],
        ),
      ),
    );
  }

  // Molde animado para as Perguntas Frequentes (ExpansionTile)
  Widget _buildFaqItem(ThemeData theme, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent), // Remove as linhas padrão do Flutter
        child: ExpansionTile(
          iconColor: theme.colorScheme.primary,
          collapsedIconColor: Colors.grey,
          title: Text(
            question,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: theme.colorScheme.onSurface),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Molde atualizado para receber a ação de clique do link externo
  Widget _buildContactCard(BuildContext context, ThemeData theme, IconData icon, String title, String subtitle, String actionText, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onTap(); // Executa o redirecionamento automático
            },
            child: Text(actionText, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}