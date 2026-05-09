import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/evento_modelo.dart';
import '../models/convidado_modelo.dart';

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
    : _eventos.where((e) => e.nome.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            e.local.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

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

  void atualizarPresenca(String eventoId, String convidadoId, bool presenca) {
    _eventos.firstWhere((e) => e.id == eventoId).convidados.firstWhere((c) => c.id == convidadoId).presenca = presenca;
    _salvarCache(); 
    notifyListeners();
  }

  double getTaxaPresenca(Evento e) => e.convidados.isEmpty ? 0 : e.convidados.where((c) => c.presenca).length / e.convidados.length;
}