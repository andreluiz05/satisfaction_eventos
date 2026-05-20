import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
// Importação do controlador de login para realizar o cadastro com segurança usando bcrypt no Firebase
import '../../backend/controlers/login_controlador.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  // Variáveis para controlar a visibilidade das senhas organizadas com segurança no Estado
  bool _ocultarSenha = true;
  bool _ocultarConfirmaSenha = true;

  // Controladores para os campos de texto
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

      // Envia os dados para o NOVO controlador criptografado
      await LoginControlador.instance.register(nome, email, senha);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Conta criada com sucesso!',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Volta para a tela de login após o cadastro com sucesso
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com Gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B0B59), Color(0xFF003D4C)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          // Círculo decorativo de fundo
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00E5FF).withAlpha(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withAlpha(30),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Botão de Voltar para o Login
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
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(25),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: Colors.white.withAlpha(51),
                                width: 1.5,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Um emoji colorido e alegre que transmite confraternização!
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      '🎉', // Party Popper - O lança confetes!
                                      style: TextStyle(
                                        fontSize:
                                            64, // Tamanho grande e impactante
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Criar Conta',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const Text(
                                    'Torne-se um Anfitrião🥳',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  _inputField(
                                    'Nome Completo',
                                    Icons.person_outline,
                                    controller: _nomeController,
                                    validador: (v) =>
                                        v!.isEmpty ? 'Preencha seu nome' : null,
                                  ),
                                  const SizedBox(height: 16),
                                  _inputField(
                                    'E-mail',
                                    Icons.alternate_email,
                                    controller: _emailController,
                                    validador: (v) => !v!.contains('@')
                                        ? 'E-mail inválido'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  _inputField(
                                    'Senha',
                                    Icons.lock_outline,
                                    obscure: _ocultarSenha,
                                    controller: _senhaController,
                                    validador: (v) => v!.length < 6
                                        ? 'Mínimo de 6 caracteres'
                                        : null,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _ocultarSenha
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        HapticFeedback.selectionClick();
                                        setState(() {
                                          _ocultarSenha = !_ocultarSenha;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  _inputField(
                                    'Confirmar Senha',
                                    Icons.lock_reset_rounded,
                                    obscure: _ocultarConfirmaSenha,
                                    controller: _confirmaSenhaController,
                                    validador: (v) => v != _senhaController.text
                                        ? 'As senhas não coincidem'
                                        : null,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _ocultarConfirmaSenha
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        HapticFeedback.selectionClick();
                                        setState(() {
                                          _ocultarConfirmaSenha =
                                              !_ocultarConfirmaSenha;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF00E5FF,
                                        ),
                                        foregroundColor: const Color(
                                          0xFF003D4C,
                                        ),
                                        elevation: 10,
                                        shadowColor: const Color(
                                          0xFF00E5FF,
                                        ).withAlpha(128),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      onPressed: _realizarCadastro,
                                      child: const Text(
                                        'CADASTRAR',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                          letterSpacing: 1.5,
                                        ),
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

  Widget _inputField(
    String l,
    IconData i, {
    bool obscure = false,
    TextEditingController? controller,
    String? Function(String?)? validador,
    Widget? suffixIcon,
  }) => TextFormField(
    controller: controller,
    obscureText: obscure,
    validator: validador,
    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    decoration: InputDecoration(
      prefixIcon: Icon(i, color: Colors.white70),
      suffixIcon: suffixIcon,
      labelText: l,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.black.withAlpha(51),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
      ),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
