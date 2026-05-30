import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/controllers/eventos_controlador.dart';
import '../../backend/models/evento_modelo.dart';
import '../../backend/models/convidado_modelo.dart';
import '../../backend/utils/platform_image.dart';
import '../../tema/confirmacao_presenca_tela_estilo.dart';
import '../autenticacao/login_tela.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Widget _eventBackgroundImage() {
    final imageUrl = widget.evento.imagemFundoUrl;
    if (imageUrl == null || imageUrl.isEmpty) return const SizedBox.shrink();

    final alignment = Alignment(0, widget.evento.imagemFundoAlinhamentoY);

    Widget image({required BoxFit fit}) {
      if (imageUrl.startsWith('http')) {
        return Image.network(imageUrl, fit: fit, alignment: alignment);
      }
      return localFileImage(imageUrl, fit: fit, alignment: alignment);
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
            child: Container(decoration: ConfirmacaoPresencaEstilo.fundoOverlayBlur),
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
            style: ConfirmacaoPresencaEstilo.textoDialog,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ConfirmacaoPresencaEstilo.botaoDialog,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                },
                child: const Text('VOLTAR AO INÍCIO', style: ConfirmacaoPresencaEstilo.textoBotaoDialog),
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

          // 2. O GRADIENTE ESCURECEDOR
          Container(
            decoration: BoxDecoration(
              gradient: ConfirmacaoPresencaEstilo.gradienteFundoTransparente,
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
                        const Icon(Icons.celebration_rounded, size: 80, color: ConfirmacaoPresencaEstilo.corAcento),
                        const SizedBox(height: 16),
                        Text(widget.evento.nome, textAlign: TextAlign.center, style: ConfirmacaoPresencaEstilo.nomeEvento),
                        const SizedBox(height: 8),
                        Text('${widget.evento.data} às ${widget.evento.horario}', style: ConfirmacaoPresencaEstilo.dataHoraEvento),
                        Text(widget.evento.local, textAlign: TextAlign.center, style: ConfirmacaoPresencaEstilo.localEvento),
                        
                        // Exibição da Descrição para o Convidado
                        if (widget.evento.descricao.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ConfirmacaoPresencaEstilo.containerDescricao,
                            child: Column(
                              children: [
                                const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 20),
                                const SizedBox(height: 8),
                                Text(
                                  widget.evento.descricao,
                                  textAlign: TextAlign.center,
                                  style: ConfirmacaoPresencaEstilo.textoDescricao,
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),

                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: ConfirmacaoPresencaEstilo.containerBusca,
                          child: Column(
                            children: [
                              const Text('Encontre seu convite', style: ConfirmacaoPresencaEstilo.tituloBusca),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                style: ConfirmacaoPresencaEstilo.textoCampoInput,
                                decoration: InputDecoration(
                                  hintText: 'Digite o e-mail cadastrado',
                                  hintStyle: ConfirmacaoPresencaEstilo.textoCampoHint,
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
                                  style: ConfirmacaoPresencaEstilo.estiloBotaoElevado.copyWith(
                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                  ),
                                  onPressed: _buscarConvite,
                                  child: const Text('BUSCAR', style: ConfirmacaoPresencaEstilo.textoBotaoPrincipal),
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        if (_buscou && _convidadoEncontrado == null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: ConfirmacaoPresencaEstilo.containerErro,
                            child: const Row(children: [
                              Icon(Icons.error_outline_rounded, color: ConfirmacaoPresencaEstilo.corErro),
                              SizedBox(width: 12),
                              Expanded(child: Text('E-mail não encontrado na lista de convidados.', style: ConfirmacaoPresencaEstilo.textoErro))
                            ]),
                          ),

                        if (_buscou && _convidadoEncontrado != null)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: ConfirmacaoPresencaEstilo.containerSucesso,
                            child: Column(
                              children: [
                                CircleAvatar(radius: 30, backgroundColor: ConfirmacaoPresencaEstilo.corDecorativa.withAlpha(25), child: Text(_convidadoEncontrado!.iniciais, style: ConfirmacaoPresencaEstilo.textoIniciais)),
                                const SizedBox(height: 16),
                                Text('Olá, ${_convidadoEncontrado!.nome}!', style: ConfirmacaoPresencaEstilo.textoSaudacao),
                                const SizedBox(height: 8),
                                const Text('Você irá a este evento?', style: ConfirmacaoPresencaEstilo.textoPerguntaPresenca),
                                const SizedBox(height: 24),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: ConfirmacaoPresencaEstilo.botaoNaoIrei,
                                        onPressed: () => _responderConvite(PresencaStatus.refused),
                                        child: const Text('NÃO IREI', style: ConfirmacaoPresencaEstilo.textoBotaoNaoIrei),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ConfirmacaoPresencaEstilo.botaoConfirmar,
                                        onPressed: () => _responderConvite(PresencaStatus.accepted),
                                        child: const Text('CONFIRMAR', style: ConfirmacaoPresencaEstilo.textoBotaoConfirmar),
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
