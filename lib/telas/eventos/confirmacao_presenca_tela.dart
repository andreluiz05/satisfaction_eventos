import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../backend/controllers/eventos_controlador.dart';
import '../../backend/models/evento_modelo.dart';
import '../../backend/models/convidado_modelo.dart';
import '../autenticacao/login_tela.dart';
import 'dart:io';
import 'dart:ui';

class ConfirmacaoPresencaScreen extends StatefulWidget {
  final Evento evento;
  const ConfirmacaoPresencaScreen({super.key, required this.evento});

  @override
  State<ConfirmacaoPresencaScreen> createState() => _ConfirmacaoPresencaScreenState();
}

class _ConfirmacaoPresencaScreenState extends State<ConfirmacaoPresencaScreen> {
  final TextEditingController _emailController = TextEditingController();
  Convidado? _convidadoEncontrado;
  bool _buscou = false;

  Widget _eventBackgroundImage() {
    final imageUrl = widget.evento.imagemFundoUrl;
    if (imageUrl == null || imageUrl.isEmpty) return const SizedBox.shrink();

    final alignment = Alignment(0, widget.evento.imagemFundoAlinhamentoY);

    Widget image({required BoxFit fit}) {
      if (imageUrl.startsWith('http')) {
        return Image.network(imageUrl, fit: fit, alignment: alignment);
      }
      if (kIsWeb) return const SizedBox.shrink();
      return Image.file(File(imageUrl), fit: fit, alignment: alignment);
    }

    if (!widget.evento.imagemFundoMostrarInteira) {
      return image(fit: BoxFit.cover);
    }

   return Stack(
      fit: StackFit.expand,
      children: [
        image(fit: BoxFit.cover), // Fundo esticado
        // Efeito de Desfoque (Blur) no fundo para não parecer "duas fotos"
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
            child: Container(color: Colors.black.withAlpha(120)),
          ),
        ),
        image(fit: BoxFit.contain), // Foto nítida em cima
      ],
    );
  }

  void _buscarConvite() {
    HapticFeedback.lightImpact();
    final emailDigitado = _emailController.text.trim().toLowerCase();

    if (emailDigitado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Digite seu e-mail para buscar.'), backgroundColor: Colors.redAccent));
      return;
    }

    try {
      final convidado = widget.evento.convidados.firstWhere(
        (c) => c.email.toLowerCase() == emailDigitado
      );
      setState(() {
        _convidadoEncontrado = convidado;
        _buscou = true;
      });
    } catch (e) {
      setState(() {
        _convidadoEncontrado = null;
        _buscou = true;
      });
    }
  }

  void _responderConvite(PresencaStatus novoStatus) {
    HapticFeedback.heavyImpact();
    if (_convidadoEncontrado != null) {
      SatisfactionController.instance.atualizarPresenca(
        widget.evento.id, 
        _convidadoEncontrado!.id, 
        novoStatus
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 64),
          content: Text(
            novoStatus == PresencaStatus.accepted 
              ? 'Sua presença foi confirmada com sucesso! Te esperamos lá.' 
              : 'Poxa, que pena! Avisamos o organizador que você não poderá ir.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                },
                child: const Text('VOLTAR AO INÍCIO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Stack(
        children: [
          Positioned.fill(child: _eventBackgroundImage()),

          // 2. O GRADIENTE ESCURECEDOR (com transparência para a foto aparecer)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B0B59).withAlpha(180),
                  const Color(0xFF003D4C).withAlpha(220)
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const Icon(Icons.celebration_rounded, size: 80, color: Color(0xFF00E5FF)),
                        const SizedBox(height: 16),
                        Text(widget.evento.nome, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Text('${widget.evento.data} às ${widget.evento.horario}', style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                        Text(widget.evento.local, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54, fontSize: 14)),
                        
                        // Exibição da Descrição para o Convidado
                        if (widget.evento.descricao.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(51),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withAlpha(25))
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 20),
                                const SizedBox(height: 8),
                                Text(
                                  widget.evento.descricao,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),

                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(color: Colors.white.withAlpha(25), borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.white.withAlpha(51))),
                          child: Column(
                            children: [
                              const Text('Encontre seu convite', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Digite o e-mail cadastrado',
                                  hintStyle: const TextStyle(color: Colors.white54),
                                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.black.withAlpha(51),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity, height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                  onPressed: _buscarConvite,
                                  child: const Text('BUSCAR', style: TextStyle(color: Color(0xFF003D4C), fontWeight: FontWeight.w900, letterSpacing: 1)),
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        if (_buscou && _convidadoEncontrado == null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.redAccent.withAlpha(51), borderRadius: BorderRadius.circular(16)),
                            child: const Row(children: [
                              Icon(Icons.error_outline_rounded, color: Colors.redAccent),
                              SizedBox(width: 12),
                              Expanded(child: Text('E-mail não encontrado na lista de convidados.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))
                            ]),
                          ),

                        if (_buscou && _convidadoEncontrado != null)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
                            child: Column(
                              children: [
                                CircleAvatar(radius: 30, backgroundColor: const Color(0xFF6A1B9A).withAlpha(25), child: Text(_convidadoEncontrado!.iniciais, style: const TextStyle(color: Color(0xFF6A1B9A), fontWeight: FontWeight.bold, fontSize: 20))),
                                const SizedBox(height: 16),
                                Text('Olá, ${_convidadoEncontrado!.nome}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF3B0B59))),
                                const SizedBox(height: 8),
                                const Text('Você irá a este evento?', style: TextStyle(fontSize: 16, color: Colors.grey)),
                                const SizedBox(height: 24),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                        onPressed: () => _responderConvite(PresencaStatus.refused),
                                        child: const Text('NÃO IREI', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                        onPressed: () => _responderConvite(PresencaStatus.accepted),
                                        child: const Text('CONFIRMAR', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
