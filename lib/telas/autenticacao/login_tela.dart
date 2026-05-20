import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../navegacao/navegacao_principal_tela.dart';
import '../eventos/confirmacao_presenca_tela.dart';
import '../../backend/controlers/eventos_controlador.dart'; // Importante para buscar os eventos
import '../../backend/controlers/login_controlador.dart';
import 'cadastro_tela.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnfitriao = true;

  // Variável para controlar a visibilidade da senha
  bool _ocultarSenha = true;

  // Controladores para os campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  // Lógica de login para Anfitrião e Convidado
  void _fazerLogin() async {
    HapticFeedback.heavyImpact();

    if (isAnfitriao) {
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      if (email.isEmpty || senha.isEmpty) {
        _mostrarMensagem('Preencha o e-mail e a senha.', isErro: true);
        return;
      }

      // Login dinâmico usando o novo controlador seguro
      final usuario = await LoginControlador.instance.login(email, senha);

      if (!mounted) return;

      if (usuario != null) {
        // Religa o Firebase para puxar os eventos OTIMIZADOS e filtrados desse anfitrião
        SatisfactionController.instance.monitorarFirebase();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      } else {
        _mostrarMensagem('E-mail ou senha incorretos.', isErro: true);
      }
    } else {
      final codigo = _codigoController.text.trim().toUpperCase();

      if (codigo.isEmpty) {
        _mostrarMensagem('Digite o código do evento.', isErro: true);
        return;
      }

      try {
        // Busca o evento diretamente no Firebase pelo código (permite acesso sem login de anfitrião)
        final evento = await SatisfactionController.instance
            .buscarEventoPorCodigo(codigo);
        if (evento == null) {
          _mostrarMensagem(
            'Evento não encontrado. Verifique o código.',
            isErro: true,
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmacaoPresencaScreen(evento: evento),
          ),
        );
      } catch (e) {
        _mostrarMensagem(
          'Erro ao buscar evento. Tente novamente.',
          isErro: true,
        );
      }
    }
  }

  // Função para os alertas coloridos
  void _mostrarMensagem(String msg, {required bool isErro}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: isErro ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B0B59), Color(0xFF003D4C)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF9C27B0).withAlpha(51),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9C27B0).withAlpha(51),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          Center(
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/imagens/logo_marca.png',
                          height: 240,
                          width: 400,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),

                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(76),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              _loginTab("Anfitrião", isAnfitriao, () {
                                HapticFeedback.selectionClick();
                                setState(() => isAnfitriao = true);
                              }),
                              _loginTab("Convidado", !isAnfitriao, () {
                                HapticFeedback.selectionClick();
                                setState(() => isAnfitriao = false);
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        if (isAnfitriao) ...[
                          _inputField(
                            'E-mail do Organizador',
                            Icons.alternate_email,
                            controller: _emailController,
                          ),
                          const SizedBox(height: 16),
                          _inputField(
                            'Senha',
                            Icons.lock_outline,
                            obscure: _ocultarSenha,
                            controller: _senhaController,
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
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Instruções enviadas para o e-mail!',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Esqueceu a senha?',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CadastroScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Criar conta',
                                  style: TextStyle(
                                    color: Color(0xFF00E5FF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          _inputField(
                            'Código do Evento',
                            Icons.confirmation_num_outlined,
                            controller: _codigoController,
                          ),
                          const SizedBox(height: 40),
                        ],

                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00E5FF),
                              foregroundColor: const Color(0xFF003D4C),
                              elevation: 10,
                              shadowColor: const Color(
                                0xFF00E5FF,
                              ).withAlpha(128),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: _fazerLogin, // Função ativada aqui
                            child: const Text(
                              'ENTRAR',
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
        ],
      ),
    );
  }

  Widget _loginTab(String t, bool active, VoidCallback fn) => Expanded(
    child: InkWell(
      onTap: fn,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuart,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF6A1B9A) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          t,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.white : Colors.white54,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    ),
  );

  Widget _inputField(
    String l,
    IconData i, {
    bool obscure = false,
    TextEditingController? controller,
    Widget? suffixIcon, // <-- Agora a função aceita receber o ícone
  }) => TextField(
    controller: controller,
    obscureText: obscure,
    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    decoration: InputDecoration(
      prefixIcon: Icon(i, color: Colors.white70),
      suffixIcon: suffixIcon, // <-- E renderiza ele aqui no canto direito
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
    ),
  );
}
