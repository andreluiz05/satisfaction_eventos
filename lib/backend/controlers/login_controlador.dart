import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/anfitriao_modelo.dart';

class LoginControlador extends ChangeNotifier {
  static final LoginControlador instance = LoginControlador._();
  LoginControlador._();

  AnfitriaoModelo? _current;
  bool isCarregando = false;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('anfitriaos');
  static const String _prefsKey = 'current_anfitriao';
  static const String _localUsersKey = 'anfitriaos_local';

  AnfitriaoModelo? get current => _current;

  Future<void> loadCurrentFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      final mapa = jsonDecode(jsonString) as Map<String, dynamic>;
      _current = AnfitriaoModelo.fromJson(mapa);
      notifyListeners();
    }
  }

  Future<void> _saveCurrentToPrefs(AnfitriaoModelo a) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(a.toJson()));
  }

  Future<void> signOut() async {
    _current = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    notifyListeners();
  }

  /// Registra um novo anfitrião. Tenta salvar no Firebase; em caso de falha salva localmente.
  Future<AnfitriaoModelo> register(
    String nome,
    String email,
    String password,
  ) async {
    isCarregando = true;
    notifyListeners();

    // Agora passa o nome!
    final novo = AnfitriaoModelo.create(
      nome: nome,
      email: email,
      password: password,
    );

    try {
      final newRef = _dbRef.push();
      await newRef.set(novo.toJson());
      novo.id = newRef.key;
    } catch (_) {
      // fallback: salvar localmente
      await _saveLocalUser(novo);
    }

    _current = novo;
    await _saveCurrentToPrefs(novo);

    isCarregando = false;
    notifyListeners();
    return novo;
  }

  /// Tenta logar com email e senha. Retorna o `AnfitriaoModelo` se bem-sucedido, ou null.
  Future<AnfitriaoModelo?> login(String email, String password) async {
    isCarregando = true;
    notifyListeners();

    try {
      // Busca a lista inteira para evitar o erro de Indexação do Firebase
      final snapshot = await _dbRef.get();

      if (snapshot.exists) {
        // Usamos 'as Map' puro para evitar erros de tipagem no Flutter Web
        final dados = snapshot.value as Map;
        
        for (final key in dados.keys) {
          final mapa = Map<String, dynamic>.from(dados[key] as Map);
          mapa['id'] = key.toString();
          
          // Filtra o e-mail manualmente no código
          if (mapa['email'] == email) {
            final anfitriao = AnfitriaoModelo.fromJson(mapa);
            
            // Verifica se a senha digitada bate com a criptografada
            if (anfitriao.verifyPassword(password)) {
              _current = anfitriao;
              await _saveCurrentToPrefs(anfitriao);
              isCarregando = false;
              notifyListeners();
              return anfitriao;
            } else {
              // Encontrou o e-mail, mas a senha está errada
              break; 
            }
          }
        }
      }
    } catch (e) {
      // Agora, se algo der errado, veremos no console!
      debugPrint("Erro detalhado no login do Firebase: $e");
    }

    // fallback: procurar na lista local
    final local = await _loadLocalUsers();
    for (final anfit in local) {
      if (anfit.email == email && anfit.verifyPassword(password)) {
        _current = anfit;
        await _saveCurrentToPrefs(anfit);
        isCarregando = false;
        notifyListeners();
        return anfit;
      }
    }

    isCarregando = false;
    notifyListeners();
    return null;
  }
  
  Future<void> _saveLocalUser(AnfitriaoModelo a) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = await _loadLocalUsers();
    lista.add(a);
    final jsonList = lista.map((e) => e.toJson()).toList();
    await prefs.setString(_localUsersKey, jsonEncode(jsonList));
  }

  Future<List<AnfitriaoModelo>> _loadLocalUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_localUsersKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((e) => AnfitriaoModelo.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
