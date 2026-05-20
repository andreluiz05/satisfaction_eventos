import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../backend/controlers/login_controlador.dart';
import 'privacidade_senha_tela.dart';

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

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}
