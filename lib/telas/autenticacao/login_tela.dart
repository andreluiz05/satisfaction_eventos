import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../tema/login_tela_estilo.dart';
import '../navegacao/navegacao_principal_tela.dart';
import '../eventos/confirmacao_presenca_tela.dart';
import '../../backend/controllers/eventos_controlador.dart';
import '../../backend/controllers/login_controlador.dart';
import 'cadastro_tela.dart';
import 'recuperar_senha_tela.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnfitriao = false;
  bool _ocultarSenha = true;

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

  void _fazerLogin() async {
    HapticFeedback.heavyImpact();

    if (isAnfitriao) {
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      if (email.isEmpty || senha.isEmpty) {
        _mostrarMensagem('Preencha o e-mail e a senha.', isErro: true);
        return;
      }

      final usuario = await LoginControlador.instance.login(email, senha);

      if (!mounted) return;

      if (usuario != null) {
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

  void _mostrarMensagem(String msg, {required bool isErro}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: LoginTelaEstilo.textoSnackbar),
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
              gradient: LoginTelaEstilo.gradienteFundo,
            ),
          ),
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: LoginTelaEstilo.decoracaoCirculoFundo(
                LoginTelaEstilo.corDecorativa,
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
                    decoration: LoginTelaEstilo.decoracaoGlassmorphism,
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
                          decoration: LoginTelaEstilo.decoracaoTabs,
                          child: Row(
                            children: [
                              _loginTab("Convidado", !isAnfitriao, () {
                                HapticFeedback.selectionClick();
                                setState(() => isAnfitriao = false);
                              }),
                              _loginTab("Anfitrião", isAnfitriao, () {
                                HapticFeedback.selectionClick();
                                setState(() => isAnfitriao = true);
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
                                setState(() => _ocultarSenha = !_ocultarSenha);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const RecuperarSenhaScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Esqueceu a senha?',
                                  style: LoginTelaEstilo.textoLinkSimples,
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
                                  style: LoginTelaEstilo.textoLinkDestaque,
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
                            style: LoginTelaEstilo.estiloBotaoElevado,
                            onPressed: _fazerLogin,
                            child: const Text(
                              'ENTRAR',
                              style: LoginTelaEstilo.textoBotaoPrincipal,
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
          color: active
              ? LoginTelaEstilo.corDecorativa
              : Colors.transparent, // Ajustado para usar cor do estilo
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          t,
          textAlign: TextAlign.center,
          style: LoginTelaEstilo.estiloTextoTab(active),
        ),
      ),
    ),
  );

  Widget _inputField(
    String l,
    IconData i, {
    bool obscure = false,
    TextEditingController? controller,
    Widget? suffixIcon,
  }) => TextField(
    controller: controller,
    obscureText: obscure,
    style: LoginTelaEstilo.estiloTextoInput,
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
        borderSide: const BorderSide(
          color: LoginTelaEstilo.corAcento,
          width: 1.5,
        ),
      ),
    ),
  );
}
