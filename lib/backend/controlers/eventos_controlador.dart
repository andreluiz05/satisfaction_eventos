import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/evento_modelo.dart';
import '../models/convidado_modelo.dart';
import '../services/firebase_servico.dart'; // Import do serviço que criamos

class SatisfactionController extends ChangeNotifier {
  static final SatisfactionController instance = SatisfactionController._();
  SatisfactionController._();

  final List<Evento> _eventos = [];
  String _searchQuery = '';
  bool isDarkMode = false;
  bool isCarregando = true; 
  static const String _cacheKey = 'satisfaction_db_v2';
  
  // Instância do serviço Firebase
  final FirebaseServico _firebase = FirebaseServico();

  // Gerador de ID curto alfanumérico (6 dígitos)
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

  // Inicialização: Carrega do Firebase ou do cache local
  Future<void> initCache() async {
    isCarregando = true;
    notifyListeners(); 

    try {
      // 1. Tenta carregar do Firebase
      final eventosRemotos = await _firebase.lerEventos();
      
      if (eventosRemotos.isNotEmpty) {
        _eventos.clear();
        _eventos.addAll(eventosRemotos);
        await _salvarCacheLocal(); 
      } else {
        // 2. Fallback para o cache local se estiver offline ou sem dados na nuvem
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString(_cacheKey);
        
        if (jsonString != null && jsonString.isNotEmpty) {
          final List<dynamic> decoded = jsonDecode(jsonString);
          _eventos.clear();
          _eventos.addAll(decoded.map((e) => Evento.fromJson(e)).toList());
        } else {
          await _salvarCacheLocal();
        } // Se ambos falharem, _eventos permanecerá vazio, o que é aceitável para um novo usuário
      }
    } catch (e) {
      debugPrint("Erro ao carregar dados: $e");
    } finally {
      isCarregando = false;
      notifyListeners(); 
    }
  }

  Future<void> _salvarCacheLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_eventos.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, jsonString);
  }

  List<Evento> get eventos => _searchQuery.isEmpty 
    ? _eventos 
    : _eventos.where((e) => e.nome.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            e.local.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  void toggleTheme() { isDarkMode = !isDarkMode; notifyListeners(); }
  void setSearchQuery(String query) { _searchQuery = query; notifyListeners(); }

  // SALVAR / CRIAR EVENTO
  void salvarEvento(Evento e) async {
    final i = _eventos.indexWhere((item) => item.id == e.id);
    if (i != -1) { _eventos[i] = e; } else { _eventos.add(e); }
    
    notifyListeners();
    await _salvarCacheLocal();
    await _firebase.salvarEvento(e); // Sincroniza com Firebase
  }

  // DELETAR EVENTO
  void deletarEvento(String id) async { 
    _eventos.removeWhere((e) => e.id == id); 
    notifyListeners(); 
    await _salvarCacheLocal();
    await _firebase.deletar(id); 
  }

  // ADICIONAR CONVIDADO
  void adicionarConvidado(String eventoId, Convidado c) async {
    final evento = _eventos.firstWhere((e) => e.id == eventoId);
    evento.convidados.add(c);
    
    notifyListeners();
    await _salvarCacheLocal();
    await _firebase.salvarEvento(evento);
  }

  // DELETAR CONVIDADO
  void deletarConvidado(String eventoId, String convidadoId) async {
    final evento = _eventos.firstWhere((e) => e.id == eventoId);
    evento.convidados.removeWhere((c) => c.id == convidadoId);
    
    notifyListeners();
    await _salvarCacheLocal();
    await _firebase.salvarEvento(evento);
  }

  // ATUALIZAR PRESENÇA DO CONVIDADO
  void atualizarPresenca(String eventoId, String convidadoId, PresencaStatus status) async {
    final evento = _eventos.firstWhere((e) => e.id == eventoId);
    evento.convidados.firstWhere((c) => c.id == convidadoId).status = status;
    
    notifyListeners();
    await _salvarCacheLocal();
    await _firebase.salvarEvento(evento);
  }

  // Taxa de Resposta (Aceitos + Recusados)
  double getTaxaResposta(Evento e) => e.convidados.isEmpty 
    ? 0 
    : e.convidados.where((c) => c.status != PresencaStatus.none).length / e.convidados.length;
}