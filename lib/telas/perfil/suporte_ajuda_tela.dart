import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../tema/suporte_ajuda_tela_estilo.dart';

class SuporteAjudaScreen extends StatelessWidget {
  const SuporteAjudaScreen({super.key});

  Future<void> chamarNoWhatsApp() async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/5531998235716");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }

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
        title: const Text('Suporte e Ajuda', style: SuporteAjudaTelaEstilo.estiloTituloAppBar),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.help_outline_rounded, size: 80, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Como podemos ajudar?',
                style: SuporteAjudaTelaEstilo.estiloPerguntaCabecalho,
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'PERGUNTAS FREQUENTES',
              style: SuporteAjudaTelaEstilo.estiloCabecalhoSessao(Colors.grey[600]),
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

            Text(
              'Entre em Suporte conosco',
              style: SuporteAjudaTelaEstilo.estiloTituloSessaoContato(theme.colorScheme),
            ),
            const SizedBox(height: 4),
            Text(
              'Para elogios, reportar bugs e outras coisas.',
              style: SuporteAjudaTelaEstilo.estiloSubtituloSessaoContato(Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            
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

  Widget _buildFaqItem(ThemeData theme, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: SuporteAjudaTelaEstilo.decoracaoCardFaq(theme.colorScheme),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: theme.colorScheme.primary,
          collapsedIconColor: Colors.grey,
          title: Text(
            question,
            style: SuporteAjudaTelaEstilo.estiloPerguntaFaq(theme.colorScheme),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: SuporteAjudaTelaEstilo.estiloRespostaFaq(theme.colorScheme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, ThemeData theme, IconData icon, String title, String subtitle, String actionText, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: SuporteAjudaTelaEstilo.decoracaoCardContato(theme.colorScheme),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: SuporteAjudaTelaEstilo.decoracaoIconeContato(theme.colorScheme),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: SuporteAjudaTelaEstilo.estiloTituloContato),
                const SizedBox(height: 4),
                Text(subtitle, style: SuporteAjudaTelaEstilo.estiloSubtituloContato),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            child: Text(actionText, style: SuporteAjudaTelaEstilo.estiloTextoBotaoContato(theme.colorScheme)),
          ),
        ],
      ),
    );
  }
}
