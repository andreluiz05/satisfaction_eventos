import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/controlers/eventos_controlador.dart';
import '../../backend/models/convidado_modelo.dart';

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
        
        final p = ctrl.getTaxaResposta(evento);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                stretch: true,
                backgroundColor: theme.colorScheme.primary,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
                  titlePadding: const EdgeInsets.only(left: 48, bottom: 16, right: 16),
                  title: Hero(tag: 'title_${evento.id}', child: Material(color: Colors.transparent, child: Text(evento.nome, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)))),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF3B0B59), Color(0xFF6A1B9A)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
                      Positioned(
                        bottom: -40, 
                        right: 560, 
                        child: Opacity(
                          opacity: 0.15, 
                          child: Image.asset('assets/imagens/logo_marca.png', height: 250)
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 100, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [const Icon(Icons.event_available_rounded, color: Colors.white70, size: 16), const SizedBox(width: 8), Text('${evento.data} • ${evento.horario}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600))]),
                            const SizedBox(height: 8),
                            Row(children: [const Icon(Icons.place_rounded, color: Colors.white70, size: 16), const SizedBox(width: 8), Text(evento.local, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600))]),
                          ],
                        ),
                      )
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
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, 8))]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Icon(Icons.notes_rounded, color: theme.colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Text('Sobre o Evento', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: theme.colorScheme.onSurface)),
                          ]),
                          const SizedBox(height: 12),
                          Text(evento.descricao, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
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
                    decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, 8))]),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Taxa de Resposta', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: theme.colorScheme.onSurface)), 
                        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF00E5FF).withAlpha(51), borderRadius: BorderRadius.circular(20)), child: Text('${(p * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF00838F))))
                      ]),
                      const SizedBox(height: 20),
                      ClipRRect(borderRadius: BorderRadius.circular(10), child: TweenAnimationBuilder<double>(tween: Tween<double>(begin: 0, end: p), duration: const Duration(milliseconds: 1000), curve: Curves.easeOutQuart, builder: (context, val, _) => LinearProgressIndicator(value: val, backgroundColor: Colors.grey.withAlpha(25), color: const Color(0xFF00E5FF), minHeight: 10))),
                      const SizedBox(height: 12),
                      Text(
                        '${evento.convidados.where((c) => c.status != PresencaStatus.none).length} de ${evento.convidados.length} convidados responderam',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600),
                      )
                    ]),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: evento.convidados.isEmpty 
                  ? SliverToBoxAdapter(child: Center(child: Padding(padding: const EdgeInsets.all(40), child: Text("Nenhum convidado.", style: TextStyle(color: Colors.grey.withAlpha(204), fontWeight: FontWeight.w600)))))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final c = evento.convidados[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(backgroundColor: theme.colorScheme.primary.withAlpha(25), foregroundColor: theme.colorScheme.primary, child: Text(c.iniciais, style: const TextStyle(fontWeight: FontWeight.bold))),
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
                                  Text(c.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 4),
                                  Text(c.statusLabel, style: TextStyle(fontSize: 12, color: c.status == PresencaStatus.accepted ? Colors.green : c.status == PresencaStatus.refused ? Colors.red : Colors.grey, fontWeight: FontWeight.w700)),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                onPressed: () {
                                  _confirmarDelecao(context, evento.id, c.id, c.nome);
                                },
                              ),
                            ),
                          );
                        },
                        childCount: evento.convidados.length,
                      ),
                    ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)) 
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () { HapticFeedback.lightImpact(); _addGuest(context, evento.id); },
            backgroundColor: theme.colorScheme.secondary,
            child: const Icon(Icons.person_add_rounded, color: Color(0xFF003D4C)),
          ),
        );
      }
    );
  }

void _confirmarDelecao(BuildContext context, String eventoId, String convidadoId, String nome) {
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
      content: Text('Tem certeza que deseja remover "$nome" da lista? Esta ação não pode ser desfeita.'),
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
            SatisfactionController.instance.deletarConvidado(eventoId, convidadoId);
            Navigator.pop(context);
          },
          child: const Text('EXCLUIR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

  void _addGuest(BuildContext context, String eventoId) {
    final formKey = GlobalKey<FormState>();
    final n = TextEditingController(), e = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Novo Convidado', style: TextStyle(fontWeight: FontWeight.w900)),
      content: Form(
        key: formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Código do Evento: ', style: TextStyle(fontWeight: FontWeight.w600)),
                Text(eventoId, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(controller: n, decoration: InputDecoration(labelText: 'Nome Completo', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)), validator: (v) => v!.isEmpty ? 'Requerido' : null), 
          const SizedBox(height: 12),
          TextFormField(controller: e, decoration: InputDecoration(labelText: 'E-mail', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)), validator: (v) => v!.isEmpty ? 'Requerido' : null)
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () { 
            if(formKey.currentState!.validate()) {
              SatisfactionController.instance.adicionarConvidado(eventoId, Convidado(id: DateTime.now().toString(), nome: n.text, email: e.text)); 
              Navigator.pop(context); 
            }
          }, 
          child: const Text('Adicionar', style: TextStyle(color: Colors.white))
        )
      ],
    ));
  }
}
