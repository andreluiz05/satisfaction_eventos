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
  Future<AnfitriaoModelo> register(String email, String password) async {
    isCarregando = true;
    notifyListeners();

    final novo = AnfitriaoModelo.create(email: email, password: password);

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
      final snapshot = await _dbRef.orderByChild('email').equalTo(email).get();

      if (snapshot.exists) {
        final dados = snapshot.value as Map<dynamic, dynamic>;
        for (final entry in dados.entries) {
          final key = entry.key.toString();
          final mapa = Map<String, dynamic>.from(entry.value);
          mapa['id'] = key;
          final anfitriao = AnfitriaoModelo.fromJson(mapa);
          if (anfitriao.verifyPassword(password)) {
            _current = anfitriao;
            await _saveCurrentToPrefs(anfitriao);
            isCarregando = false;
            notifyListeners();
            return anfitriao;
          }
        }
      }
    } catch (_) {
      // ignore and fallback to local
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
    return decoded.map((e) => AnfitriaoModelo.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<AnfitriaoModelo> loginAsAdmin() async {
    final localUsers = await _loadLocalUsers();
    for (final user in localUsers) {
      if (user.email == 'admin') {
        _current = user;
        await _saveCurrentToPrefs(user);
        notifyListeners();
        return user;
      }
    }

    final admin = AnfitriaoModelo.create(id: 'admin', email: 'admin@eventos.com', password: '123');
    _current = admin;
    await _saveCurrentToPrefs(admin);
    await _saveLocalUser(admin);
    notifyListeners();
    return admin;
  }
}
