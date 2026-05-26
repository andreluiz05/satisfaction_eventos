import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart'; // Pacote necessário para o Realtime
import '../models/evento_modelo.dart';
import '../models/convidado_modelo.dart';
import '../services/firebase_servico.dart';
import '../services/imgbb_servico.dart';
import 'login_controlador.dart';

class SatisfactionController extends ChangeNotifier {
  static final SatisfactionController instance = SatisfactionController._();
  SatisfactionController._();

  final List<Evento> _eventos = [];
  String _searchQuery = '';
  bool isDarkMode = false;
  bool isCarregando = true;
  static const String _cacheKey = 'satisfaction_db_v2';
  
  final FirebaseServico _firebase = FirebaseServico();
  
  // Referência direta ao nó de eventos no Firebase para o fluxo contínuo
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("eventos");
  StreamSubscription<DatabaseEvent>? _subscription;

  // Gera um código único alfanumérico de 6 dígitos para identificação do evento
  String generateEventId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String id;
    do {
      id = String.fromCharCodes(
        Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
      );
    } while (_eventos.any((e) => e.id == id));
    return id;
  }

  // Inicia a escuta contínua do Firebase (Substitui o antigo initCache e refreshData)
  void monitorarFirebase() {
    isCarregando = true;
    notifyListeners();
    
    // Cancel previous subscription if any to avoid duplicate listeners
    _subscription?.cancel();

    // Cria um "túnel" que escuta qualquer mudança no banco em tempo real
    _subscription = _dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      _eventos.clear();

      if (data != null) {
        final currentHostId = LoginControlador.instance.current?.id;
        data.forEach((key, value) {
          // Converte o valor do Firebase para um Map que o Flutter entende
          final mapaData = Map<String, dynamic>.from(value);

          // Injeta a chave (key) do Firebase como o 'id' do evento
          mapaData['id'] = key;

          // Usa o método fromJson que já existe no seu modelo
          final evento = Evento.fromJson(mapaData);

          // Adiciona apenas eventos do anfitrião logado
          if (currentHostId != null && evento.anfitriaoId != null && evento.anfitriaoId == currentHostId) {
            _eventos.add(evento);
          }
        });
      }

      isCarregando = false;
      _salvarCacheLocal(); // Mantém o backup local sempre sincronizado
      notifyListeners(); // Força a tela a se atualizar automaticamente
      
    }, onError: (error) {
      debugPrint("Erro no Realtime: $error");
      _carregarCacheLocal(); // Fallback se houver erro de conexão
    });
  }

  // Carrega do armazenamento interno se o Firebase falhar ou estiver sem internet
  Future<void> _carregarCacheLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _eventos.clear();
      for (var item in decoded) {
        _eventos.add(Evento.fromJson(item));
      }
    }
    isCarregando = false;
    notifyListeners();
  }

  // Persiste a lista atual de eventos no armazenamento interno do celular
  Future<void> _salvarCacheLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_eventos.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, jsonString);
  }

  // Retorna a lista de eventos filtrada com base na busca do usuário
  List<Evento> get eventos {
    if (_searchQuery.isEmpty) {
      return _eventos;
    } else {
      return _eventos.where((e) {
        final nomeMatch = e.nome.toLowerCase().contains(_searchQuery.toLowerCase());
        final localMatch = e.local.toLowerCase().contains(_searchQuery.toLowerCase());
        return nomeMatch || localMatch;
      }).toList();
    }
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Adiciona um novo evento ou atualiza um existente no local e no Firebase
  Future<void> salvarEvento(Evento e) async {
     final currentHost = LoginControlador.instance.current;
     if (currentHost == null) {
       debugPrint('Não é possível salvar evento sem anfitrião logado.');
       return;
     }

     final index = _eventos.indexWhere((item) => item.id == e.id);
     if (index != -1) {
       _eventos[index] = e;
     } else {
       _eventos.add(e);
     }
     notifyListeners(); // Feedback imediato para o usuário

     e.anfitriaoId = currentHost.id;
     await _firebase.salvarEvento(e);
   }

  void deletarEvento(String id) async {
    final index = _eventos.indexWhere((e) => e.id == id);
    final deleteUrl = index == -1 ? null : _eventos[index].imagemFundoDeleteUrl;
    _eventos.removeWhere((e) => e.id == id);
    notifyListeners();
    await _firebase.deletar(id);
    await ImgbbServico.deleteImage(deleteUrl);
  }

  // --- Responsavel por deletar todos os eventos de um anfitrião específico (usado na exclusão de conta) ---
  Future<void> deletarTodosEventosDoAnfitriao(String anfitriaoId) async {
    // Pegamos uma cópia da lista para evitar erros de modificação durante o loop
    final eventosParaDeletar = _eventos.where((e) => e.anfitriaoId == anfitriaoId).toList();
    
    for (var evento in eventosParaDeletar) {
      deletarEvento(evento.id); // Reutilizamos o seu método de deleção de evento que já faz o trabalho completo
    }
  }
  // ------------------------------------

  void adicionarConvidado(String eventoId, Convidado c) async {
    final evento = _eventos.firstWhere((e) => e.id == eventoId);
    evento.convidados.add(c);
    notifyListeners();
    await _firebase.salvarEvento(evento);
  }

  void editarConvidado(String eventoId, Convidado convidado) async {
    final evento = _eventos.firstWhere((e) => e.id == eventoId);
    final index = evento.convidados.indexWhere((c) => c.id == convidado.id);
    if (index != -1) {
      evento.convidados[index] = convidado;
      notifyListeners();
      await _firebase.salvarEvento(evento);
    }
  }

  void deletarConvidado(String eventoId, String convidadoId) async {
    final evento = _eventos.firstWhere((e) => e.id == eventoId);
    evento.convidados.removeWhere((c) => c.id == convidadoId);
    notifyListeners();
    await _firebase.salvarEvento(evento);
  }

  // Atualiza o status de presença (confirmado/recusado) de um convidado específico
  void atualizarPresenca(String eventoId, String convidadoId, PresencaStatus status) async {
    try {
      final evento = _eventos.firstWhere((e) => e.id == eventoId);
      final convidado = evento.convidados.firstWhere((c) => c.id == convidadoId);
      convidado.status = status;
      notifyListeners();
      await _firebase.salvarEvento(evento);
      return;
    } catch (_) {
      // Evento não encontrado na lista local (provavelmente acesso via convidado). Buscar no Firebase.
    }

    try {
      final snap = await _dbRef.child(eventoId).get();
      if (!snap.exists) return;
      final mapa = Map<String, dynamic>.from(snap.value as Map);
      mapa['id'] = eventoId;
      if (mapa['convidados'] == null) mapa['convidados'] = [];
      final evento = Evento.fromJson(mapa);

      final idx = evento.convidados.indexWhere((c) => c.id == convidadoId);
      if (idx == -1) return;
      evento.convidados[idx].status = status;

      // Persistir alteração no Firebase
      await _firebase.salvarEvento(evento);

      // Atualizar cache local se já houver o evento carregado
      final localIndex = _eventos.indexWhere((e) => e.id == eventoId);
      if (localIndex != -1) {
        _eventos[localIndex] = evento;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao atualizar presença: $e');
    }
  }

  Future<void> editarEvento(Evento evento) async {
    await salvarEvento(evento);
  }

  // Busca um evento diretamente no Firebase pelo código (id)
  Future<Evento?> buscarEventoPorCodigo(String codigo) async {
    try {
      final snap = await _dbRef.child(codigo).get();
      if (!snap.exists) return null;
      final mapa = Map<String, dynamic>.from(snap.value as Map);
      mapa['id'] = codigo;
      // Garantir campo convidados
      if (mapa['convidados'] == null) mapa['convidados'] = [];
      return Evento.fromJson(mapa);
    } catch (e) {
      debugPrint('Erro ao buscar evento por código: $e');
      return null;
    }
  }

  // Calcula a porcentagem de convidados que já responderam (Aceitaram ou Recusaram)
  double getTaxaResposta(Evento e) {
    if (e.convidados.isEmpty) {
      return 0.0;
    }
    final respondidos = e.convidados.where((c) => c.status != PresencaStatus.none).length;
    return respondidos / e.convidados.length;
  }
}
