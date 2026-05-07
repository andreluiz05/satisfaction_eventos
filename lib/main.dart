import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await SatisfactionController.instance.initCache();

  runApp(const SatisfactionApp());
}

class SatisfactionApp extends StatelessWidget {
  const SatisfactionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SatisfactionController.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Satisfaction Eventos',
          themeMode: SatisfactionController.instance.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A1B9A), primary: const Color(0xFF6A1B9A), secondary: const Color(0xFF00E5FF), surface: Colors.white, brightness: Brightness.light),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9C27B0), primary: const Color(0xFF9C27B0), secondary: const Color(0xFF00E5FF), surface: const Color(0xFF1E293B), brightness: Brightness.dark),
          ),
          home: SatisfactionController.instance.isCarregando 
              ? const Scaffold(body: Center(child: CircularProgressIndicator())) 
              : const LoginScreen(),
        );
      }
    );
  }
}

class Convidado {
  String id, nome, email;
  bool presenca;
  Convidado({required this.id, required this.nome, required this.email, this.presenca = false});

  String get iniciais => nome.trim().split(RegExp(' +')).map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase();

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'email': email, 'presenca': presenca};
  
  factory Convidado.fromJson(Map<String, dynamic> json) => Convidado(
    id: json['id'], nome: json['nome'], email: json['email'], presenca: json['presenca'] ?? false,
  );
}

class Evento {
  String id, nome, local, data, horario;
  List<Convidado> convidados;
  Evento({required this.id, required this.nome, required this.local, required this.data, required this.horario, required this.convidados});

  Map<String, dynamic> toJson() => {
    'id': id, 'nome': nome, 'local': local, 'data': data, 'horario': horario,
    'convidados': convidados.map((c) => c.toJson()).toList(),
  };

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'], nome: json['nome'], local: json['local'], data: json['data'], horario: json['horario'],
    convidados: (json['convidados'] as List).map((c) => Convidado.fromJson(c)).toList(),
  );
}

class SatisfactionController extends ChangeNotifier {
  static final SatisfactionController instance = SatisfactionController._();
  SatisfactionController._();

  final List<Evento> _eventos = [];
  String _searchQuery = '';
  bool isDarkMode = false;
  bool isCarregando = true; 
  static const String _cacheKey = 'satisfaction_db_v2';

  Future<void> initCache() async {
    isCarregando = true;
    notifyListeners(); 

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cacheKey);
      
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _eventos.clear();
        _eventos.addAll(decoded.map((e) => Evento.fromJson(e)).toList());
      } else {
        _eventos.add(Evento(id: '1', nome: 'Apresentação AV2', local: 'Laboratório TI - Bloco B', data: '20/05/2026', horario: '19:00', convidados: [
          Convidado(id: 'c1', nome: 'Ênio', email: 'enio@uninassau.com', presenca: true),
          Convidado(id: 'c2', nome: 'Camila', email: 'camila@uninassau.com', presenca: false),
          Convidado(id: 'c3', nome: 'Miguel', email: 'miguel@email.com', presenca: true),
          Convidado(id: 'c4', nome: 'Aquiles', email: 'aquiles@uninassau.com', presenca: false),
          Convidado(id: 'c5', nome: 'Rian', email: 'rian@uninassau.com', presenca: true),
        ]));
        await _salvarCache();
      }
    } catch (e) {
      debugPrint("Erro ao carregar cache: $e");
    } finally {
      isCarregando = false;
      notifyListeners(); 
    }
  }

  Future<void> _salvarCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_eventos.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, jsonString);
  }

  List<Evento> get eventos => _searchQuery.isEmpty 
    ? _eventos 
    : _eventos.where((e) => e.nome.toLowerCase().contains(_searchQuery.toLowerCase()) || e.local.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  void toggleTheme() { isDarkMode = !isDarkMode; notifyListeners(); }

  void setSearchQuery(String query) { _searchQuery = query; notifyListeners(); }

  void salvarEvento(Evento e) {
    final i = _eventos.indexWhere((item) => item.id == e.id);
    if (i != -1) { _eventos[i] = e; } else { _eventos.add(e); }
    _salvarCache(); 
    notifyListeners();
  }

  void deletarEvento(String id) { 
    _eventos.removeWhere((e) => e.id == id); 
    _salvarCache(); 
    notifyListeners(); 
  }

  void adicionarConvidado(String eventoId, Convidado c) {
    _eventos.firstWhere((e) => e.id == eventoId).convidados.add(c);
    _salvarCache(); 
    notifyListeners();
  }

  void deletarConvidado(String eventoId, String convidadoId) {
    _eventos.firstWhere((e) => e.id == eventoId).convidados.removeWhere((c) => c.id == convidadoId);
    _salvarCache(); 
    notifyListeners();
  }

  void atualizarPresenca(String eventoId, String convidadoId, bool presenca) {
    _eventos.firstWhere((e) => e.id == eventoId).convidados.firstWhere((c) => c.id == convidadoId).presenca = presenca;
    _salvarCache(); 
    notifyListeners();
  }

  double getTaxaPresenca(Evento e) => e.convidados.isEmpty ? 0 : e.convidados.where((c) => c.presenca).length / e.convidados.length;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnfitriao = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF3B0B59), Color(0xFF003D4C)], begin: Alignment.topRight, end: Alignment.bottomLeft))),
          Positioned(top: -100, right: -50, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF9C27B0).withAlpha(51), boxShadow: [BoxShadow(color: const Color(0xFF9C27B0).withAlpha(51), blurRadius: 100)]))),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(color: Colors.white.withAlpha(25), borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.white.withAlpha(51), width: 1.5)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withAlpha(25), shape: BoxShape.circle), child: const Icon(Icons.hub_outlined, color: Color(0xFF00E5FF), size: 48)),
                        const SizedBox(height: 16),
                        const Text('SATISFACTION\nEVENTOS', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2, height: 1.2)),
                        const SizedBox(height: 40),
                        
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.black.withAlpha(76), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              _loginTab("Anfitrião", isAnfitriao, () { HapticFeedback.selectionClick(); setState(() => isAnfitriao = true); }),
                              _loginTab("Convidado", !isAnfitriao, () { HapticFeedback.selectionClick(); setState(() => isAnfitriao = false); }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        _inputField(isAnfitriao ? 'E-mail do Organizador' : 'Código do Evento', Icons.alternate_email),
                        const SizedBox(height: 16),
                        
                        // NOVA ÁREA DE SENHA E RECUPERAÇÃO
                        if (isAnfitriao) ...[
                          _inputField('Senha', Icons.lock_outline, obscure: true),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Instruções enviadas para o e-mail!')));
                                },
                                child: const Text('Esqueceu a senha?', style: TextStyle(color: Colors.white70, fontSize: 13)),
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tela de cadastro em desenvolvimento.')));
                                },
                                child: const Text('Criar conta', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          const SizedBox(height: 40),
                        ],
                        
                        SizedBox(
                          width: double.infinity, height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: const Color(0xFF003D4C), elevation: 10, shadowColor: const Color(0xFF00E5FF).withAlpha(128), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
                            },
                            child: const Text('ENTRAR', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5)),
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

  Widget _loginTab(String t, bool active, VoidCallback fn) => Expanded(child: InkWell(onTap: fn, borderRadius: BorderRadius.circular(16), child: AnimatedContainer(duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart, padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: active ? const Color(0xFF6A1B9A) : Colors.transparent, borderRadius: BorderRadius.circular(16)), child: Text(t, textAlign: TextAlign.center, style: TextStyle(color: active ? Colors.white : Colors.white54, fontWeight: active ? FontWeight.bold : FontWeight.normal, fontSize: 15)))));

  Widget _inputField(String l, IconData i, {bool obscure = false}) => TextField(obscureText: obscure, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500), decoration: InputDecoration(prefixIcon: Icon(i, color: Colors.white70), labelText: l, labelStyle: const TextStyle(color: Colors.white60), filled: true, fillColor: Colors.black.withAlpha(51), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5))));
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  // AQUI INCLUÍMOS A NOVA TELA DE PERFIL
  final List<Widget> _telas = [const Dashboard(), const PerfilScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _telas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) { HapticFeedback.selectionClick(); setState(() => _currentIndex = i); },
        elevation: 10,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded, color: Color(0xFF6A1B9A)), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: Color(0xFF6A1B9A)), label: 'Perfil'),
        ],
      ),
    );
  }
}

// NOVA TELA DE PERFIL COM OPÇÃO DE SAIR
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Meu Perfil', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 24)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: theme.colorScheme.primary, width: 2)),
                child: CircleAvatar(
                  radius: 50, 
                  backgroundColor: theme.colorScheme.primary.withAlpha(25), 
                  child: Icon(Icons.person, size: 50, color: theme.colorScheme.primary)
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Organizador(a)', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 4),
            const Text('admin@satisfaction.com', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            const SizedBox(height: 40),
            
            _menuItem(context, Icons.edit_rounded, 'Editar Dados', theme),
            _menuItem(context, Icons.security_rounded, 'Privacidade e Senha', theme),
            _menuItem(context, Icons.help_outline_rounded, 'Suporte e Ajuda', theme),
            
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444).withAlpha(25), 
                  foregroundColor: const Color(0xFFEF4444), 
                  elevation: 0, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
                onPressed: () { 
                  HapticFeedback.heavyImpact(); 
                  // VOLTA PARA A TELA DE LOGIN E LIMPA O HISTÓRICO
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false
                  ); 
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('SAIR DA CONTA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4))]),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: theme.colorScheme.primary.withAlpha(25), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: theme.colorScheme.primary)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Função disponível na versão premium.')));
        },
      ),
    );
  }
}

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
                backgroundColor: theme.scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                  title: Text('Meus Eventos', style: TextStyle(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface, letterSpacing: -0.5)),
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
                            background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 24), margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 32)),
                            onDismissed: (_) { HapticFeedback.mediumImpact(); ctrl.deletarEvento(e.id); },
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
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    ),
  );

  void _showAddDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final n = TextEditingController(), l = TextEditingController(), d = TextEditingController(), h = TextEditingController();
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
              const SizedBox(height: 32),
              SizedBox(width: double.infinity, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), onPressed: () { if (formKey.currentState!.validate()) { SatisfactionController.instance.salvarEvento(Evento(id: DateTime.now().toString(), nome: n.text, local: l.text, data: d.text, horario: h.text, convidados: [])); Navigator.pop(context); } }, child: const Text('SALVAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)))),
            ],
          ),
        ),
      ),
    );
  }
}

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
        final p = ctrl.getTaxaPresenca(evento);

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
                      Positioned(bottom: -50, right: -50, child: Icon(Icons.celebration_rounded, size: 200, color: Colors.white.withAlpha(25))),
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
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, 8))]),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Check-in', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: theme.colorScheme.onSurface)), 
                        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF00E5FF).withAlpha(51), borderRadius: BorderRadius.circular(20)), child: Text('${(p * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF00838F))))
                      ]),
                      const SizedBox(height: 20),
                      ClipRRect(borderRadius: BorderRadius.circular(10), child: TweenAnimationBuilder<double>(tween: Tween<double>(begin: 0, end: p), duration: const Duration(milliseconds: 1000), curve: Curves.easeOutQuart, builder: (context, val, _) => LinearProgressIndicator(value: val, backgroundColor: Colors.grey.withAlpha(25), color: const Color(0xFF00E5FF), minHeight: 10))),
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
                              title: Text(c.nome, style: TextStyle(fontWeight: FontWeight.w800, color: c.presenca ? theme.colorScheme.onSurface : Colors.grey, decoration: c.presenca ? TextDecoration.lineThrough : null)),
                              subtitle: Text(c.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              trailing: Checkbox(
                                value: c.presenca,
                                activeColor: const Color(0xFF10B981),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                onChanged: (v) { HapticFeedback.lightImpact(); ctrl.atualizarPresenca(evento.id, c.id, v!); },
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

  void _addGuest(BuildContext context, String eventoId) {
    final formKey = GlobalKey<FormState>();
    final n = TextEditingController(), e = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Novo Convidado', style: TextStyle(fontWeight: FontWeight.w900)),
      content: Form(
        key: formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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