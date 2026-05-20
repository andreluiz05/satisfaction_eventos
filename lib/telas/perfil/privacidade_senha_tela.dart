import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../backend/controlers/login_controlador.dart';

class PrivacidadeSenhaScreen extends StatefulWidget {
  const PrivacidadeSenhaScreen({super.key});

  @override
  State<PrivacidadeSenhaScreen> createState() => _PrivacidadeSenhaScreenState();
}

class _PrivacidadeSenhaScreenState extends State<PrivacidadeSenhaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _salvarSenha() async {
    final currentUser = LoginControlador.instance.current;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado. Faça login novamente.')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final currentPassword = _currentPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();

      if (!currentUser.verifyPassword(currentPassword)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha atual incorreta.')),
        );
        return;
      }

      await LoginControlador.instance.updateCurrent(password: newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha atualizada com sucesso.')),
      );
      Navigator.pop(context);
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
        title: const Text('Privacidade e Senha', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.lock_outline_rounded, size: 84, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              'Atualize sua senha de forma segura.',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Para segurança do seu perfil, informe a senha atual antes de definir uma nova senha.',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrent,
                    decoration: _fieldDecoration(
                      'Senha atual',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCurrent = !_obscureCurrent;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a senha atual.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    decoration: _fieldDecoration(
                      'Nova senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNew ? Icons.visibility_off : Icons.visibility,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNew = !_obscureNew;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a nova senha.';
                      }
                      if (value.length < 6) {
                        return 'A senha deve ter ao menos 6 caracteres.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    decoration: _fieldDecoration(
                      'Confirmar nova senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme a nova senha.';
                      }
                      if (value != _newPasswordController.text) {
                        return 'As senhas não coincidem.';
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
                      onPressed: _salvarSenha,
                      child: const Text(
                        'ALTERAR SENHA',
                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
