import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../backend/controllers/eventos_controlador.dart';
import '../../backend/controllers/login_controlador.dart';
import '../../backend/models/convidado_modelo.dart';
import '../../backend/models/evento_modelo.dart';
import '../../backend/services/imgbb_servico.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EventDetail extends StatelessWidget {
  final String eventoId;
  const EventDetail({super.key, required this.eventoId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: SatisfactionController.instance,
      builder: (context, _) {
        final ctrl = SatisfactionController.instance;
        final eventoList = ctrl.eventos.where((e) => e.id == eventoId).toList();
        if (eventoList.isEmpty) return const Scaffold();
        final evento = eventoList.first;

        final currentHost = LoginControlador.instance.current;
        if (currentHost == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Evento')),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Você precisa entrar com um anfitrião para ver ou editar eventos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          );
        }

        final p = ctrl.getTaxaResposta(evento);

        final currentHostId = currentHost.id;
        final isOwner = currentHostId == evento.anfitriaoId;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                stretch: true,
                backgroundColor: theme.colorScheme.primary,
                iconTheme: const IconThemeData(color: Colors.white),
                actions: isOwner
                    ? [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              _showEditEventDialog(context, evento),
                        ),
                      ]
                    : null,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  titlePadding: const EdgeInsets.only(
                    left: 48,
                    bottom: 16,
                    right: 16,
                  ),
                  title: Hero(
                    tag: 'title_${evento.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        evento.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _eventBackgroundImage(evento),

                      // ALTERE O SEU CONTAINER PARA USAR DEGRADÊ COM TRANSPARÊNCIA (withAlpha):
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF3B0B59).withAlpha(140),
                              const Color(0xFF6A1B9A).withAlpha(220),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      if (evento.imagemFundoUrl == null ||
                          evento.imagemFundoUrl!.isEmpty)
                        Positioned(
                          bottom: -40,
                          right: 560,
                          child: Opacity(
                            opacity: 0.15,
                            child: Image.asset(
                              'assets/imagens/logo_marca.png',
                              height: 250,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 100, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.event_available_rounded,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${evento.data} • ${evento.horario}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.place_rounded,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  evento.local,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.vpn_key_rounded,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Código: ${evento.id}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // CARD DE DESCRIÇÃO
              if (evento.descricao.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.notes_rounded,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sobre o Evento',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            evento.descricao,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // CARD DE TAXA DE RESPOSTA
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Taxa de Resposta',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E5FF).withAlpha(51),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${(p * 100).toInt()}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF00838F),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: p),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeOutQuart,
                            builder: (context, val, _) =>
                                LinearProgressIndicator(
                                  value: val,
                                  backgroundColor: Colors.grey.withAlpha(25),
                                  color: const Color(0xFF00E5FF),
                                  minHeight: 10,
                                ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${evento.convidados.where((c) => c.status != PresencaStatus.none).length} de ${evento.convidados.length} convidados responderam',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: evento.convidados.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Text(
                              "Nenhum convidado.",
                              style: TextStyle(
                                color: Colors.grey.withAlpha(204),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final c = evento.convidados[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: theme.colorScheme.primary
                                    .withAlpha(25),
                                foregroundColor: theme.colorScheme.primary,
                                child: Text(
                                  c.iniciais,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                c.nome,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: c.status == PresencaStatus.accepted
                                      ? Colors.green
                                      : c.status == PresencaStatus.refused
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.email,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.statusLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: c.status == PresencaStatus.accepted
                                          ? Colors.green
                                          : c.status == PresencaStatus.refused
                                          ? Colors.red
                                          : Colors.grey,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: isOwner
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blueAccent,
                                            size: 20,
                                          ),
                                          onPressed: () => _showEditGuestDialog(
                                            context,
                                            evento,
                                            c,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.redAccent,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            _confirmarDelecao(
                                              context,
                                              evento.id,
                                              c.id,
                                              c.nome,
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          );
                        }, childCount: evento.convidados.length),
                      ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
          floatingActionButton: isOwner
              ? FloatingActionButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _addGuest(context, evento.id);
                  },
                  backgroundColor: theme.colorScheme.secondary,
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: Color(0xFF003D4C),
                  ),
                )
              : null,
        );
      },
    );
  }

  void _confirmarDelecao(
    BuildContext context,
    String eventoId,
    String convidadoId,
    String nome,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Excluir?', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        content: Text(
          'Tem certeza que deseja remover "$nome" da lista? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCELAR',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              HapticFeedback.heavyImpact();
              SatisfactionController.instance.deletarConvidado(
                eventoId,
                convidadoId,
              );
              Navigator.pop(context);
            },
            child: const Text(
              'EXCLUIR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addGuest(BuildContext context, String eventoId) {
    _showGuestDialog(context, eventoId, null);
  }

  void _showGuestDialog(
    BuildContext context,
    String eventoId,
    Convidado? convidado,
  ) {
    final formKey = GlobalKey<FormState>();
    final n = TextEditingController(text: convidado?.nome ?? '');
    final e = TextEditingController(text: convidado?.email ?? '');
    final title = convidado == null ? 'Novo Convidado' : 'Editar Convidado';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Código do Evento: ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      eventoId,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: n,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: e,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A1B9A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final guest = convidado == null
                    ? Convidado(
                        id: DateTime.now().toString(),
                        nome: n.text,
                        email: e.text,
                      )
                    : Convidado(
                        id: convidado.id,
                        nome: n.text,
                        email: e.text,
                        status: convidado.status,
                      );

                if (convidado == null) {
                  SatisfactionController.instance.adicionarConvidado(
                    eventoId,
                    guest,
                  );
                } else {
                  SatisfactionController.instance.editarConvidado(
                    eventoId,
                    guest,
                  );
                }

                Navigator.pop(context);
              }
            },
            child: Text(
              convidado == null ? 'Adicionar' : 'Salvar',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditGuestDialog(
    BuildContext context,
    Evento evento,
    Convidado convidado,
  ) {
    _showGuestDialog(context, evento.id, convidado);
  }

  Widget _eventBackgroundImage(Evento evento) {
    final imageUrl = evento.imagemFundoUrl;
    if (imageUrl == null || imageUrl.isEmpty) return const SizedBox.shrink();

    final alignment = Alignment(0, evento.imagemFundoAlinhamentoY);

    Widget image({required BoxFit fit}) {
      if (imageUrl.startsWith('http')) {
        return Image.network(imageUrl, fit: fit, alignment: alignment);
      }
      if (kIsWeb) return const SizedBox.shrink();
      return Image.file(File(imageUrl), fit: fit, alignment: alignment);
    }

    if (!evento.imagemFundoMostrarInteira) {
      return image(fit: BoxFit.cover);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        image(fit: BoxFit.cover),
        Container(color: Colors.black.withAlpha(80)),
        image(fit: BoxFit.contain),
      ],
    );
  }

  Widget _imageFitControls({
    required bool hasImage,
    required bool mostrarFotoInteira,
    required double alinhamentoFotoY,
    required ValueChanged<bool> onMostrarFotoInteiraChanged,
    required ValueChanged<double> onAlinhamentoFotoChanged,
  }) {
    if (!hasImage) return const SizedBox.shrink();

    String sliderLabel(double value) {
      if (value <= -0.5) return 'Topo';
      if (value >= 0.5) return 'Base';
      return 'Centro';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Mostrar foto inteira',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          value: mostrarFotoInteira,
          onChanged: onMostrarFotoInteiraChanged,
        ),
        if (!mostrarFotoInteira) ...[
          Text(
            'Posição vertical: ${sliderLabel(alinhamentoFotoY)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: alinhamentoFotoY,
            min: -1,
            max: 1,
            divisions: 4,
            label: sliderLabel(alinhamentoFotoY),
            onChanged: onAlinhamentoFotoChanged,
          ),
        ],
      ],
    );
  }

  void _showEditEventDialog(BuildContext context, Evento evento) {
    final formKey = GlobalKey<FormState>();
    final nome = TextEditingController(text: evento.nome);
    final local = TextEditingController(text: evento.local);
    final data = TextEditingController(text: evento.data);
    final horario = TextEditingController(text: evento.horario);
    final desc = TextEditingController(text: evento.descricao);
    String? caminhoImagemSelecionada = evento.imagemFundoUrl;
    String? deleteUrlImagemSelecionada = evento.imagemFundoDeleteUrl;
    bool mostrarFotoInteira = evento.imagemFundoMostrarInteira;
    double alinhamentoFotoY = evento.imagemFundoAlinhamentoY;
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Editar Evento',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> escolherImagem() async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
              );

              if (pickedFile == null) return;

              setStateDialog(() => isUploading = true);
              final upload = await ImgbbServico.uploadImageBytes(
                await pickedFile.readAsBytes(),
              );

              setStateDialog(() {
                if (upload != null) {
                  caminhoImagemSelecionada = upload.url;
                  deleteUrlImagemSelecionada = upload.deleteUrl;
                }
                isUploading = false;
              });
            }

            return Form(
              key: formKey,
              child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: escolherImagem,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withAlpha(51),
                        width: 2,
                      ),
                      image:
                          caminhoImagemSelecionada != null &&
                              caminhoImagemSelecionada!.isNotEmpty &&
                              (caminhoImagemSelecionada!.startsWith('http') ||
                                  !kIsWeb)
                          ? DecorationImage(
                              image:
                                  caminhoImagemSelecionada!.startsWith('http')
                                  ? NetworkImage(caminhoImagemSelecionada!)
                                        as ImageProvider
                                  : FileImage(File(caminhoImagemSelecionada!)),
                              fit: mostrarFotoInteira
                                  ? BoxFit.contain
                                  : BoxFit.cover,
                              alignment: Alignment(0, alinhamentoFotoY),
                            )
                          : null,
                    ),
                    child: isUploading
                        ? const Center(child: CircularProgressIndicator())
                        : caminhoImagemSelecionada == null ||
                              caminhoImagemSelecionada!.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_rounded,
                                size: 34,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Adicionar foto de fundo',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    radius: 18,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      onPressed: escolherImagem,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    backgroundColor: Colors.redAccent,
                                    radius: 18,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        if (evento.imagemFundoUrl !=
                                                caminhoImagemSelecionada &&
                                            evento.imagemFundoDeleteUrl !=
                                                deleteUrlImagemSelecionada) {
                                          ImgbbServico.deleteImage(
                                            deleteUrlImagemSelecionada,
                                          );
                                        }
                                        setStateDialog(() {
                                          caminhoImagemSelecionada = null;
                                          deleteUrlImagemSelecionada = null;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                _imageFitControls(
                  hasImage: caminhoImagemSelecionada != null &&
                      caminhoImagemSelecionada!.isNotEmpty,
                  mostrarFotoInteira: mostrarFotoInteira,
                  alinhamentoFotoY: alinhamentoFotoY,
                  onMostrarFotoInteiraChanged: (value) {
                    setStateDialog(() => mostrarFotoInteira = value);
                  },
                  onAlinhamentoFotoChanged: (value) {
                    setStateDialog(() => alinhamentoFotoY = value);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nome,
                  decoration: InputDecoration(
                    labelText: 'Nome do Evento',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: local,
                  decoration: InputDecoration(
                    labelText: 'Localização',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: data,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    prefixIcon: const Icon(Icons.calendar_today_rounded),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  onTap: () async {
                    final initialDate =
                        _parseBrazilDate(data.text) ?? DateTime.now();
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: const Locale('pt', 'BR'),
                    );
                    if (selected != null) {
                      data.text = _formatBrazilDate(selected);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: horario,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Horário',
                    prefixIcon: const Icon(Icons.access_time_rounded),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  onTap: () async {
                    final initialTime =
                        _parseBrazilTime(horario.text) ?? TimeOfDay.now();
                    final selected = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                      builder: (context, child) => MediaQuery(
                        data: MediaQuery.of(
                          context,
                        ).copyWith(alwaysUse24HourFormat: true),
                        child: child ?? const SizedBox.shrink(),
                      ),
                    );
                    if (selected != null) {
                      horario.text = _formatBrazilTime(selected);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: desc,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Descrição (Opcional)',
                    alignLabelWithHint: true,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (evento.imagemFundoUrl != caminhoImagemSelecionada &&
                  evento.imagemFundoDeleteUrl != deleteUrlImagemSelecionada) {
                ImgbbServico.deleteImage(deleteUrlImagemSelecionada);
              }
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A1B9A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final updated = Evento(
                  id: evento.id,
                  nome: nome.text,
                  local: local.text,
                  data: data.text,
                  horario: horario.text,
                  descricao: desc.text,
                  convidados: evento.convidados,
                  anfitriaoId: evento.anfitriaoId,
                  imagemFundoUrl: caminhoImagemSelecionada,
                  imagemFundoDeleteUrl: deleteUrlImagemSelecionada,
                  imagemFundoMostrarInteira: mostrarFotoInteira,
                  imagemFundoAlinhamentoY: alinhamentoFotoY,
                );
                SatisfactionController.instance.editarEvento(updated);
                if (evento.imagemFundoUrl != caminhoImagemSelecionada) {
                  ImgbbServico.deleteImage(evento.imagemFundoDeleteUrl);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatBrazilDate(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  }

  DateTime? _parseBrazilDate(String value) {
    try {
      final parts = value.split('/');
      if (parts.length != 3) return null;
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  String _formatBrazilTime(TimeOfDay value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay? _parseBrazilTime(String value) {
    try {
      final parts = value.split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }
}
