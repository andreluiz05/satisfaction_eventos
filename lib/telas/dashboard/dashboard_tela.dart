import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/controllers/eventos_controlador.dart';
import '../../backend/controllers/login_controlador.dart';
import '../../backend/models/evento_modelo.dart';
import '../../backend/models/convidado_modelo.dart';
import '../../backend/utils/platform_image.dart';
import '../eventos/detalhes_evento_tela.dart';
import '../../tema/dashboard_tela_estilo.dart';

//IMPORT ADICIONAIS PARA MANIPULAÇÃO DE IMAGENS E INTEGRAÇÃO COM O ImgBB
import 'package:image_picker/image_picker.dart';

// -----------------------------------------------
// IMPORT DO SERVIÇO DE UPLOAD DE IMAGENS PARA O ImgBB
import '../../backend/services/imgbb_servico.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: SatisfactionController.instance,
      builder: (context, _) {
        final ctrl = SatisfactionController.instance;
        final currentHost = LoginControlador.instance.current;
        final hasHost = currentHost != null;
        return Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                centerTitle: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Meus Eventos',
                        style: DashboardEstilo.tituloAppBar(theme),
                      ),
                    ],
                  ),
                  background: Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      left: 24,
                      right: 24,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Painel de Gestão',
                              style: DashboardEstilo.subtituloAppBar(theme),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: DashboardEstilo.badgeOperacoes(theme),
                              child: Text(
                                '${ctrl.eventos.length} operações ativas',
                                style: DashboardEstilo.badgeOperacoesTexto(
                                  theme,
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            ctrl.isDarkMode
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            ctrl.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: TextField(
                    onChanged: ctrl.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Buscar evento ou local...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ),

              !hasHost
                  ? SliverFillRemaining(child: _emptyStateNoHost())
                  : ctrl.eventos.isEmpty
                  ? SliverFillRemaining(child: _emptyState())
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final e = ctrl.eventos[i];
                          return Dismissible(
                            key: Key(e.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              _confirmarDelecaoEvento(context, e.id, e.nome);
                              return false;
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: DashboardEstilo.fundoDelecao,
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            child: _eventoCard(context, e, theme),
                          );
                        }, childCount: ctrl.eventos.length),
                      ),
                    ),
            ],
          ),
          floatingActionButton: hasHost
              ? FloatingActionButton.extended(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showAddDialog(context);
                  },
                  backgroundColor: theme.colorScheme.primary,
                  elevation: 8,
                  label: const Text(
                    'NOVO EVENTO',
                    style: DashboardEstilo.textoBotaoNovoEvento,
                  ),
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                )
              : null,
        );
      },
    );
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: DashboardEstilo.iconeEstadoVazio,
          child: const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Nenhum evento encontrado',
          style: DashboardEstilo.textoEstadoVazio,
        ),
      ],
    ),
  );

  Widget _emptyStateNoHost() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: DashboardEstilo.iconeEstadoVazio,
          child: const Icon(
            Icons.lock_outline_rounded,
            size: 64,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Faça login para ver e criar seus eventos.',
          textAlign: TextAlign.center,
          style: DashboardEstilo.textoEstadoVazio,
        ),
      ],
    ),
  );

  Widget _eventoCard(
    BuildContext context,
    Evento e,
    ThemeData theme,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: DashboardEstilo.cardEvento(theme),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EventDetail(eventoId: e.id)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                clipBehavior: Clip.antiAlias,
                decoration: DashboardEstilo.imagemCardEvento(theme),
                child:
                    e.imagemFundoUrl != null &&
                        e.imagemFundoUrl!.isNotEmpty &&
                        e.imagemFundoUrl!.startsWith('http')
                    ? Image.network(
                        e.imagemFundoUrl!,
                        fit: BoxFit.cover,
                        // Mostra a bolinha de carregamento enquanto a imagem não carrega
                        loadingBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) {
                                return child; // A imagem já carregou, mostra a imagem normal
                              }
                              // Enquanto não carrega, mostra a bolinha
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                        alignment: Alignment(0, e.imagemFundoAlinhamentoY),
                      )
                    : Icon(
                        Icons.confirmation_num_rounded,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'title_${e.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          e.nome,
                          style: DashboardEstilo.tituloCardEvento(theme),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            e.local,
                            style: DashboardEstilo.localCardEvento,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: DashboardEstilo.badgeIdEvento(theme),
                    child: Text(
                      e.id,
                      style: DashboardEstilo.badgeIdEventoTexto(theme),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.edit_outlined,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _showEditEventDialog(context, e);
                        },
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

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
            style: DashboardEstilo.textoSwitch,
          ),
          value: mostrarFotoInteira,
          onChanged: onMostrarFotoInteiraChanged,
        ),
        if (!mostrarFotoInteira) ...[
          Text(
            'Posição vertical: ${sliderLabel(alinhamentoFotoY)}',
            style: DashboardEstilo.textoSliderLabel,
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

    // Puxa a imagem atual que já estava no banco
    String? caminhoImagemSelecionada = evento.imagemFundoUrl;
    String? deleteUrlImagemSelecionada = evento.imagemFundoDeleteUrl;
    bool mostrarFotoInteira = evento.imagemFundoMostrarInteira;
    double alinhamentoFotoY = evento.imagemFundoAlinhamentoY;
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Editar Evento', style: DashboardEstilo.tituloDialog),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> escolherImagem() async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null) {
                setStateDialog(
                  () => isUploading = true,
                ); // Mostra o carregamento

                // Envia para a nuvem em vez de copiar para a pasta local
                final upload = await ImgbbServico.uploadImageBytes(
                  await pickedFile.readAsBytes(),
                );

                setStateDialog(() {
                  if (upload != null) {
                    caminhoImagemSelecionada = upload.url;
                    deleteUrlImagemSelecionada = upload.deleteUrl;
                  }
                  isUploading = false; // Esconde o carregamento
                });
              }
            }

            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: escolherImagem,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: DashboardEstilo.placeholderImagemDialog
                            .copyWith(
                              image:
                                  caminhoImagemSelecionada != null &&
                                      caminhoImagemSelecionada!.isNotEmpty &&
                                      (caminhoImagemSelecionada!.startsWith(
                                            'http',
                                          ) ||
                                          localFileImageProvider(
                                                caminhoImagemSelecionada!,
                                              ) !=
                                              null)
                                  ? DecorationImage(
                                      image:
                                          caminhoImagemSelecionada!.startsWith(
                                            'http',
                                          )
                                          ? NetworkImage(
                                                  caminhoImagemSelecionada!,
                                                )
                                                as ImageProvider
                                          : localFileImageProvider(
                                              caminhoImagemSelecionada!,
                                            )!,
                                      fit: mostrarFotoInteira
                                          ? BoxFit.contain
                                          : BoxFit.cover,
                                      alignment: Alignment(0, alinhamentoFotoY),
                                    )
                                  : null,
                            ),
                        child: isUploading
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 12),
                                  Text(
                                    'Carregando foto, aguarde...',
                                    style:
                                        DashboardEstilo.textoCarregandoImagem,
                                  ),
                                ],
                              )
                            : caminhoImagemSelecionada == null ||
                                  caminhoImagemSelecionada!.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_rounded,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Trocar foto',
                                    style: DashboardEstilo.textoTrocarFoto,
                                  ),
                                ],
                              )
                            : Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // BOTÃO DE EDITAR (Lápis)
                                      CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        radius: 16,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          onPressed: escolherImagem,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // BOTÃO DE REMOVER (X)
                                      CircleAvatar(
                                        backgroundColor: Colors.redAccent,
                                        radius: 16,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),

                                          onPressed: () async {
                                            // Só tenta apagar do celular se NÃO for um link da internet (http)
                                            if (caminhoImagemSelecionada !=
                                                    null &&
                                                !caminhoImagemSelecionada!
                                                    .startsWith('http')) {
                                              try {
                                                await deleteLocalFileIfExists(
                                                  caminhoImagemSelecionada!,
                                                );
                                              } catch (e) {
                                                debugPrint(
                                                  'Erro ao apagar imagem: $e',
                                                );
                                              }
                                            }

                                            // 2. Limpa a variável e atualiza a tela
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
                      hasImage:
                          caminhoImagemSelecionada != null &&
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
            style: DashboardEstilo.botaoSalvarDialog,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final updated = Evento(
                  id: evento.id,
                  nome: nome.text,
                  local: local.text,
                  data: data.text,
                  horario: horario.text,
                  descricao: desc.text,
                  imagemFundoUrl:
                      caminhoImagemSelecionada, // <-- Mantém a imagem salva!
                  imagemFundoDeleteUrl: deleteUrlImagemSelecionada,
                  imagemFundoMostrarInteira: mostrarFotoInteira,
                  imagemFundoAlinhamentoY: alinhamentoFotoY,
                  convidados: evento.convidados,
                  anfitriaoId: evento.anfitriaoId,
                );
                SatisfactionController.instance.editarEvento(updated);
                if (evento.imagemFundoUrl != caminhoImagemSelecionada) {
                  ImgbbServico.deleteImage(evento.imagemFundoDeleteUrl);
                }
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Salvar',
              style: DashboardEstilo.textoBotaoSalvar,
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      nome.dispose();
      local.dispose();
      data.dispose();
      horario.dispose();
      desc.dispose();
    });
  }

  String _formatBrazilDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }

  DateTime? _parseBrazilDate(String value) {
    if (value.isEmpty) return null;
    final parts = value.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  String _formatBrazilTime(TimeOfDay value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay? _parseBrazilTime(String value) {
    if (value.isEmpty) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _confirmarDelecaoEvento(
    BuildContext context,
    String eventoId,
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
            Text('Excluir Evento?', style: DashboardEstilo.tituloDialog),
          ],
        ),
        content: Text(
          'Você tem certeza que deseja excluir o evento "$nome"?\n\nIsso removerá permanentemente todos os convidados e dados vinculados a ele.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCELAR',
              style: DashboardEstilo.textoBotaoCancelar,
            ),
          ),
          ElevatedButton(
            style: DashboardEstilo.botaoExcluirDialog,
            onPressed: () async {
              HapticFeedback.heavyImpact();
              await SatisfactionController.instance.deletarEvento(eventoId);
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Evento removido com sucesso.')),
              );
            },
            child: const Text(
              'EXCLUIR',
              style: DashboardEstilo.textoBotaoExcluir,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final n = TextEditingController(),
        l = TextEditingController(),
        d = TextEditingController(),
        h = TextEditingController(),
        desc = TextEditingController();

    // 1. Variável local para guardar a imagem
    String? caminhoImagemSelecionada;
    String? deleteUrlImagemSelecionada;
    bool mostrarFotoInteira = true;
    double alinhamentoFotoY = -1;
    bool isUploading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      builder: (context) => StatefulBuilder(
        // 2. Motor para atualizar a foto na tela!
        builder: (context, setStateDialog) {
          // 3. Função para abrir a galeria
          Future<void> escolherImagem() async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(
              source: ImageSource.gallery,
            );

            if (pickedFile != null) {
              setStateDialog(() => isUploading = true); // Mostra o progresso

              // Chama o serviço do ImgBB e envia para a internet
              final upload = await ImgbbServico.uploadImageBytes(
                await pickedFile.readAsBytes(),
              );

              setStateDialog(() {
                if (upload != null) {
                  caminhoImagemSelecionada =
                      upload.url; // Agora guarda o link 'http'
                  deleteUrlImagemSelecionada = upload.deleteUrl;
                }
                isUploading = false; // Esconde o progresso
              });
            }
          }

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              28,
              12,
              28,
              MediaQuery.of(context).viewInsets.bottom + 32,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 6,
                      decoration: DashboardEstilo.handleBottomSheet,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Criar Evento',
                    style: DashboardEstilo.tituloBottomSheet,
                  ),
                  const SizedBox(height: 24),

                  // 4. Área visual para adicionar a foto
                  GestureDetector(
                    onTap: escolherImagem,
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: DashboardEstilo.placeholderImagemBottomSheet
                          .copyWith(
                            image:
                                caminhoImagemSelecionada != null &&
                                    (caminhoImagemSelecionada!.startsWith(
                                          'http',
                                        ) ||
                                        localFileImageProvider(
                                              caminhoImagemSelecionada!,
                                            ) !=
                                            null)
                                ? DecorationImage(
                                    image:
                                        caminhoImagemSelecionada!.startsWith(
                                          'http',
                                        )
                                        ? NetworkImage(
                                                caminhoImagemSelecionada!,
                                              )
                                              as ImageProvider
                                        : localFileImageProvider(
                                            caminhoImagemSelecionada!,
                                          )!,
                                    fit: mostrarFotoInteira
                                        ? BoxFit.contain
                                        : BoxFit.cover,
                                    alignment: Alignment(0, alinhamentoFotoY),
                                  )
                                : null,
                          ),
                      child: isUploading
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 12),
                                Text(
                                  'Carregando foto, aguarde...',
                                  style: DashboardEstilo.textoCarregandoImagem,
                                ),
                              ],
                            )
                          : caminhoImagemSelecionada == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Adicionar foto de fundo (Opcional)',
                                  style: DashboardEstilo.textoTrocarFoto,
                                ),
                              ],
                            )
                          : Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // BOTÃO DE REMOVER (X)
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
                                        onPressed: () async {
                                          // 1. Só tentamos apagar se for um arquivo local
                                          if (caminhoImagemSelecionada !=
                                                  null &&
                                              !caminhoImagemSelecionada!
                                                  .startsWith('http')) {
                                            try {
                                              await deleteLocalFileIfExists(
                                                caminhoImagemSelecionada!,
                                              );
                                            } catch (e) {
                                              debugPrint(
                                                'Erro ao apagar arquivo: $e',
                                              );
                                            }
                                          }
                                          // 2. Limpa a variável
                                          ImgbbServico.deleteImage(
                                            deleteUrlImagemSelecionada,
                                          );
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
                    hasImage:
                        caminhoImagemSelecionada != null &&
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
                    controller: n,
                    decoration: InputDecoration(
                      labelText: 'Nome do Evento',
                      prefixIcon: const Icon(Icons.title_rounded),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: l,
                    decoration: InputDecoration(
                      labelText: 'Localização',
                      prefixIcon: const Icon(Icons.place_rounded),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: d,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Data',
                            prefixIcon: const Icon(
                              Icons.calendar_today_rounded,
                            ),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              locale: const Locale('pt', 'BR'),
                            );
                            if (date != null) d.text = _formatBrazilDate(date);
                          },
                          validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: h,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Horário',
                            prefixIcon: const Icon(Icons.access_time_rounded),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onTap: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(
                                  context,
                                ).copyWith(alwaysUse24HourFormat: true),
                                child: child ?? const SizedBox.shrink(),
                              ),
                            );
                            if (time != null && context.mounted)
                              h.text = _formatBrazilTime(time);
                          },
                          validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: desc,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Descrição (Opcional)',
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.notes_rounded),
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: DashboardEstilo.botaoSalvarBottomSheet,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          SatisfactionController.instance.salvarEvento(
                            Evento(
                              id: SatisfactionController.instance
                                  .generateEventId(),
                              nome: n.text,
                              local: l.text,
                              data: d.text,
                              horario: h.text,
                              descricao: desc.text,
                              imagemFundoUrl:
                                  caminhoImagemSelecionada, // <-- 5. Enviando o caminho para o Banco!
                              imagemFundoDeleteUrl: deleteUrlImagemSelecionada,
                              imagemFundoMostrarInteira: mostrarFotoInteira,
                              imagemFundoAlinhamentoY: alinhamentoFotoY,
                              convidados: <Convidado>[],
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'SALVAR',
                        style: DashboardEstilo.textoBotaoSalvarBottomSheet,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).whenComplete(() {
      n.dispose();
      l.dispose();
      d.dispose();
      h.dispose();
      desc.dispose();
    });
  }
}
