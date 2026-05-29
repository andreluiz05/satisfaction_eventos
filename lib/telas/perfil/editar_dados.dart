import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/controllers/login_controlador.dart';
import 'privacidade_senha_tela.dart';
import '../autenticacao/login_tela.dart';

class EditarDadosPage extends StatefulWidget {
  const EditarDadosPage({Key? key}) : super(key: key);

  @override
  State<EditarDadosPage> createState() => _EditarDadosPageState();
}

class _EditarDadosPageState extends State<EditarDadosPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final usuario = LoginControlador.instance.current;
    if (usuario != null) {
      _emailController.text = usuario.email;
      _nomeController.text = usuario.nome;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _salvarDados() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (LoginControlador.instance.current == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível atualizar os dados do usuário.')),
        );
        return;
      }

      await LoginControlador.instance.updateCurrent(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso.')),
        );
        Navigator.pop(context);
      }
    }
  }

  InputDecoration _fieldDecoration(String label, {Widget? suffixIcon}) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: theme.colorScheme.surface,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

// --- NOVA FUNÇÃO PROFISSIONAL DE EXCLUSÃO DE CONTA ---
  void _confirmarExclusaoConta(BuildContext context) {
    String fraseDigitada = "";
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false, // Força o usuário a interagir com os botões
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Excluir Conta?', 
                    style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFEF4444)),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aviso: Esta ação é irreversível. Sua conta, todos os seus eventos criados e as listas de convidados serão apagados permanentemente do nosso banco de dados.',
                  style: TextStyle(height: 1.5, color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                Text(
                  'Para confirmar, digite exatamente a frase abaixo:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFEF4444).withAlpha(100)),
                  ),
                  child: const Center(
                    child: Text(
                      'DESEJO EXCLUIR MINHA CONTA',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFEF4444),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (val) {
                    // Atualiza o estado da caixa de diálogo a cada letra digitada
                    setStateDialog(() {
                      fraseDigitada = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Digite a frase aqui...',
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.withAlpha(100)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCELAR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  disabledBackgroundColor: const Color(0xFFEF4444).withAlpha(100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                // O botão só fica habilitado se a frase digitada for exata
                onPressed: fraseDigitada == 'DESEJO EXCLUIR MINHA CONTA'
                    ? () async {
                        HapticFeedback.heavyImpact();
                        
                        // Executa a exclusão no backend
                        await LoginControlador.instance.deletarConta();
                        
                        if (context.mounted) {
                          // Limpa a pilha de telas e joga para o Login
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      }
                    : null, // null desativa o botão visualmente e o clique
                child: const Text('EXCLUIR TUDO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }
  @override Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Dados'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 72,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Atualize seus dados de perfil.',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Aqui você pode alterar nome e e-mail. A senha está disponível na tela de Privacidade e Senha.',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: _fieldDecoration('Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o nome.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldDecoration('Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o email.';
                      }
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                        return 'Email inválido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: _salvarDados,
                      child: const Text(
                        'SALVAR ALTERAÇÕES',
                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacidadeSenhaScreen()),
                );
              },
              icon: Icon(Icons.lock_outline_rounded, color: theme.colorScheme.primary),
              label: Text(
                'Alterar senha em Privacidade e Senha',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
            // Botão para excluir conta
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                _confirmarExclusaoConta(context);
              },
              icon: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
              label: const Text(
                'Excluir conta permanentemente',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
