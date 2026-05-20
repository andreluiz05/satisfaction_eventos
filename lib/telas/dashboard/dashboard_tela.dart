import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/controlers/eventos_controlador.dart';
import '../../backend/models/evento_modelo.dart';
import '../../backend/models/convidado_modelo.dart'; 
import '../eventos/detalhes_evento_tela.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: SatisfactionController.instance,
      builder: (context, _) {
        final ctrl = SatisfactionController.instance;
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
                        style: TextStyle(
                           fontSize: 22,
                           fontWeight: FontWeight.w900, 
                            color: theme.colorScheme.onSurface, 
                                 letterSpacing: -0.5,
                                ),
                                ),
                               ],
                  ),
                  background: Padding(
                    padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Painel de Gestão', style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(20)), child: Text('${ctrl.eventos.length} operações ativas', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF475569), fontSize: 12))),
                          ],
                        ),
                        IconButton(
                          icon: Icon(ctrl.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                          onPressed: () { HapticFeedback.lightImpact(); ctrl.toggleTheme(); }
                        )
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ),

              ctrl.eventos.isEmpty 
                ? SliverFillRemaining(child: _emptyState())
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
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
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444), 
                                    borderRadius: BorderRadius.circular(24)
                                  ), 
                                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 32)
                                ),
                                child: _eventoCard(context, e, theme),
                              );
                        },
                        childCount: ctrl.eventos.length,
                      ),
                    ),
                  ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () { HapticFeedback.lightImpact(); _showAddDialog(context); },
            backgroundColor: theme.colorScheme.primary,
            elevation: 8,
            label: const Text('NOVO EVENTO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.grey.withAlpha(25), shape: BoxShape.circle), child: const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey)),
        const SizedBox(height: 24),
        const Text('Nada encontrado', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.grey)),
      ],
    ),
  );

  Widget _eventoCard(BuildContext context, Evento e, ThemeData theme) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, 8))]),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () { HapticFeedback.lightImpact(); Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetail(eventoId: e.id))); },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: theme.colorScheme.primary.withAlpha(25), borderRadius: BorderRadius.circular(20)), child: Icon(Icons.confirmation_num_rounded, color: theme.colorScheme.primary, size: 28)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(tag: 'title_${e.id}', child: Material(color: Colors.transparent, child: Text(e.nome, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: theme.colorScheme.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis))),
                    const SizedBox(height: 6),
                    Row(children: [const Icon(Icons.place_rounded, size: 14, color: Colors.grey), const SizedBox(width: 4), Expanded(child: Text(e.local, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      e.id,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

void _confirmarDelecaoEvento(BuildContext context, String eventoId, String nome) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
          SizedBox(width: 10),
          Text('Excluir Evento?', style: TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
      content: Text('Você tem certeza que deseja excluir o evento "$nome"?\n\nIsso removerá permanentemente todos os convidados e dados vinculados a ele.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCELAR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            HapticFeedback.heavyImpact();
            SatisfactionController.instance.deletarEvento(eventoId);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Evento removido com sucesso.'))
            );
          },
          child: const Text('EXCLUIR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}
  void _showAddDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final n = TextEditingController(), l = TextEditingController(), d = TextEditingController(), h = TextEditingController(), desc = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(28, 12, 28, MediaQuery.of(context).viewInsets.bottom + 32),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 48, height: 6, decoration: BoxDecoration(color: Colors.grey.withAlpha(76), borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 32),
              const Text('Criar Evento', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26)),
              const SizedBox(height: 24),
              TextFormField(controller: n, decoration: InputDecoration(labelText: 'Nome do Evento', prefixIcon: const Icon(Icons.title_rounded), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
              const SizedBox(height: 16),
              TextFormField(controller: l, decoration: InputDecoration(labelText: 'Localização', prefixIcon: const Icon(Icons.place_rounded), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: TextFormField(controller: d, readOnly: true, decoration: InputDecoration(labelText: 'Data', prefixIcon: const Icon(Icons.calendar_today_rounded), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)), onTap: () async { DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100)); if (date != null) d.text = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}"; }, validator: (v) => v!.isEmpty ? 'Obrigatório' : null)),
                const SizedBox(width: 16),
                Expanded(child: TextFormField(controller: h, readOnly: true, decoration: InputDecoration(labelText: 'Horário', prefixIcon: const Icon(Icons.access_time_rounded), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)), onTap: () async { TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now()); if (time != null && context.mounted) h.text = time.format(context); }, validator: (v) => v!.isEmpty ? 'Obrigatório' : null)),
              ]),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)
                )
              ),
              const SizedBox(height: 32),
              SizedBox(width: double.infinity, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), onPressed: () { 
                if (formKey.currentState!.validate()) { 
                  SatisfactionController.instance.salvarEvento(Evento(id: SatisfactionController.instance.generateEventId(), nome: n.text, local: l.text, data: d.text, horario: h.text, descricao: desc.text, convidados: <Convidado>[])); 
                  Navigator.pop(context); 
                } 
              }, child: const Text('SALVAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)))),
            ],
          ),
        ),
      ),
    );
  }
}
