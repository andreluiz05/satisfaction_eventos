import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/controllers/login_controlador.dart';
import '../../tema/recuperar_senha_tela_estilo.dart';

class RecuperarSenhaScreen extends StatefulWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  State<RecuperarSenhaScreen> createState() => _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends State<RecuperarSenhaScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _enviando = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _enviarEmail() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      setState(() => _enviando = true);

      final email = _emailController.text.trim();

      final sucesso = await LoginControlador.instance.enviarEmailRecuperacao(
        email,
      );

      if (!mounted) return;
      setState(() => _enviando = false);

      if (sucesso) {
        _mostrarDialogoSucesso(email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Erro: E-mail não encontrado ou falha no envio. Tente novamente.',
              style: RecuperarSenhaTelaEstilo.textoSnackbar,
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _mostrarDialogoSucesso(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.mark_email_read_rounded, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text(
              'E-mail Enviado!',
              textAlign: TextAlign.center,
              style: RecuperarSenhaTelaEstilo.textoTituloDialogo,
            ),
          ],
        ),
        content: Text(
          'Acabamos de enviar o link de redefinição de senha para o e-mail:\n\n$email',
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: RecuperarSenhaTelaEstilo.estiloBotaoDialogo,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'VOLTAR PARA O LOGIN',
                style: RecuperarSenhaTelaEstilo.textoBotaoDialogo,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RecuperarSenhaTelaEstilo.corFundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_reset_rounded,
                  size: 100,
                  color: RecuperarSenhaTelaEstilo.corAcento,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Esqueceu sua senha?',
                  style: RecuperarSenhaTelaEstilo.textoTitulo,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Digite o e-mail cadastrado na sua conta. Nós enviaremos um link de redefinição de senha para você.',
                  textAlign: TextAlign.center,
                  style: RecuperarSenhaTelaEstilo.textoSubtitulo,
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _emailController,
                  style: RecuperarSenhaTelaEstilo.estiloTextoInput,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.white70,
                    ),
                    labelText: 'E-mail',
                    labelStyle: RecuperarSenhaTelaEstilo.estiloLabelInput,
                    filled: true,
                    fillColor: Colors.black.withAlpha(51),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: RecuperarSenhaTelaEstilo.corAcento,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (v) => v!.isEmpty || !v.contains('@')
                      ? 'Digite um e-mail válido'
                      : null,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: RecuperarSenhaTelaEstilo.estiloBotaoPrincipal,
                    onPressed: _enviando ? null : _enviarEmail,
                    child: _enviando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'ENVIAR E-MAIL',
                            style: RecuperarSenhaTelaEstilo.textoBotaoPrincipal,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
