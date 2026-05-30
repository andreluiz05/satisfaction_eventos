import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../tema/cadastro_tela_estilo.dart';
import '../../backend/controllers/login_controlador.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  bool _ocultarSenha = true;
  bool _ocultarConfirmaSenha = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController =
      TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  void _realizarCadastro() async {
    HapticFeedback.heavyImpact();

    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text.trim();
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      final existe = await LoginControlador.instance.emailExists(email);
      if (existe) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Já existe uma conta com esse e-mail.',
              style: CadastroTelaEstilo.textoSnackbar,
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      await LoginControlador.instance.register(nome, email, senha);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Conta criada com sucesso!',
            style: CadastroTelaEstilo.textoSnackbar,
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: CadastroTelaEstilo.gradienteFundo,
            ),
          ),
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: CadastroTelaEstilo.decoracaoCirculoFundo(
                CadastroTelaEstilo.corAcento,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration:
                                CadastroTelaEstilo.decoracaoGlassmorphism,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person_add_alt_1_rounded,
                                    size: 80,
                                    color: CadastroTelaEstilo.corAcento,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Criar Conta',
                                    style: CadastroTelaEstilo.textoTitulo,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Preencha os dados abaixo',
                                    style: CadastroTelaEstilo.textoSubtitulo,
                                  ),
                                  const SizedBox(height: 40),
                                  _buildTextField(
                                    controller: _nomeController,
                                    label: 'Nome Completo',
                                    icon: Icons.person_outline,
                                    validator: (v) =>
                                        v!.isEmpty ? 'Digite seu nome' : null,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    controller: _emailController,
                                    label: 'E-mail',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) => !v!.contains('@')
                                        ? 'E-mail inválido'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    controller: _senhaController,
                                    label: 'Senha',
                                    icon: Icons.lock_outline,
                                    obscure: _ocultarSenha,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _ocultarSenha
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () => setState(
                                        () => _ocultarSenha = !_ocultarSenha,
                                      ),
                                    ),
                                    validator: (v) => v!.length < 6
                                        ? 'Mínimo 6 caracteres'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    controller: _confirmaSenhaController,
                                    label: 'Confirmar Senha',
                                    icon: Icons.lock_reset_rounded,
                                    obscure: _ocultarConfirmaSenha,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _ocultarConfirmaSenha
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () => setState(
                                        () => _ocultarConfirmaSenha =
                                            !_ocultarConfirmaSenha,
                                      ),
                                    ),
                                    validator: (v) => v != _senhaController.text
                                        ? 'As senhas não coincidem'
                                        : null,
                                  ),
                                  const SizedBox(height: 40),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: ElevatedButton(
                                      style:
                                          CadastroTelaEstilo.estiloBotaoElevado,
                                      onPressed: _realizarCadastro,
                                      child: const Text(
                                        'CADASTRAR',
                                        style: CadastroTelaEstilo
                                            .textoBotaoPrincipal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: Colors.black.withAlpha(51),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: CadastroTelaEstilo.corAcento,
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.orangeAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
