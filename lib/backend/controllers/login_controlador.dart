import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/anfitriao_modelo.dart';
import 'eventos_controlador.dart';

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

  Future<void> updateCurrent({String? nome, String? email, String? password}) async {
    if (_current == null) return;

    if (nome != null && nome.isNotEmpty) {
      _current!.nome = nome;
    }
    if (email != null && email.isNotEmpty) {
      _current!.email = email;
    }
    if (password != null && password.isNotEmpty) {
      _current!.setPassword(password);
    }

    try {
      if (_current!.id != null && _current!.id!.isNotEmpty) {
        final updateData = Map<String, dynamic>.from(_current!.toJson())..remove('id');
        await _dbRef.child(_current!.id!).update(updateData);
      } else {
        await _saveOrUpdateLocalUser(_current!);
      }
    } catch (e) {
      debugPrint('Falha ao atualizar usuário no Firebase: $e');
      await _saveOrUpdateLocalUser(_current!);
    }

    await _saveCurrentToPrefs(_current!);
    notifyListeners();
  }

  Future<void> _saveOrUpdateLocalUser(AnfitriaoModelo a) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = await _loadLocalUsers();
    final index = lista.indexWhere((item) =>
        (item.id != null && item.id == a.id) || item.email == a.email);
    if (index >= 0) {
      lista[index] = a;
    } else {
      lista.add(a);
    }
    final jsonList = lista.map((e) => e.toJson()).toList();
    await prefs.setString(_localUsersKey, jsonEncode(jsonList));
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Erro ao encerrar sessão no Firebase Auth: $e');
    }

    _current = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    SatisfactionController.instance.clearSessionData();
    notifyListeners();
  }

  // --- Método de exclusão de conta ---
  Future<void> deletarConta() async {
    if (_current == null) return;

    if (_current!.id != null && _current!.id!.isNotEmpty) {
      // 1. Apaga todos os eventos vinculados a este anfitrião
      await SatisfactionController.instance.deletarTodosEventosDoAnfitriao(_current!.id!);

      // 2. Apaga o registro do anfitrião no nó 'anfitriaos' do Firebase
      await _dbRef.child(_current!.id!).remove();

      try {
        await FirebaseAuth.instance.currentUser?.delete();
      } catch (e) {
        debugPrint('Erro ao excluir conta do Firebase Auth: $e');
      }
    }

    // 3. Limpa o cache local e desloga
    await signOut();
  }
  // ------------------------------------

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
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null || uid.isEmpty) {
        throw Exception('Usuário não foi criado pelo Firebase Authentication.');
      }

      novo.id = uid;
      await _dbRef.child(uid).set(novo.toJson());

      await credential.user?.updateDisplayName(nome);
    } catch (e) {
      debugPrint('Falha ao registrar com Firebase Auth, usando fallback do banco local: $e');

      try {
        final newRef = _dbRef.push();
        await newRef.set(novo.toJson());
        novo.id = newRef.key;
      } catch (_) {
        await _saveLocalUser(novo);
      }
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
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid != null && uid.isNotEmpty) {
        final snapshot = await _dbRef.child(uid).get();

        if (snapshot.exists && snapshot.value is Map) {
          final mapa = Map<String, dynamic>.from(snapshot.value as Map);
          mapa['id'] = uid;

          final anfitriao = AnfitriaoModelo.fromJson(mapa);
          _current = anfitriao;
          await _saveCurrentToPrefs(anfitriao);
          isCarregando = false;
          notifyListeners();
          return anfitriao;
        }

        final fallback = AnfitriaoModelo(
          id: uid,
          nome: userCredential.user?.displayName?.trim().isNotEmpty == true
              ? userCredential.user!.displayName!
              : email.split('@').first,
          email: userCredential.user?.email ?? email.trim(),
          passwordHash: 'firebase-auth',
        );

        _current = fallback;
        await _saveCurrentToPrefs(fallback);
        isCarregando = false;
        notifyListeners();
        return fallback;
      }
    } catch (e) {
      debugPrint('Falha no login com Firebase Auth: $e');
    }

    // fallback: procurar na lista local para compatibilidade com contas salvas offline
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

  /// Verifica se já existe um anfitrião com o e-mail informado,
  /// tanto no Firebase quanto na lista local.
  Future<bool> emailExists(String email) async {
    final emailLower = email.trim().toLowerCase();

    try {
      final snapshot = await _dbRef.get();
      if (snapshot.exists) {
        final dados = snapshot.value as Map;
        for (final key in dados.keys) {
          final mapa = Map<String, dynamic>.from(dados[key] as Map);
          final e = (mapa['email'] as String?)?.toLowerCase();
          if (e != null && e == emailLower) return true;
        }
      }
    } catch (e) {
      debugPrint('Erro ao verificar e-mail no Firebase: $e');
    }

    final local = await _loadLocalUsers();
    for (final anfit in local) {
      if (anfit.email.toLowerCase() == emailLower) return true;
    }

    return false;
  }
  /// Verifica se o e-mail existe no banco de dados
  Future<bool> verificarEmailParaRecuperacao(String email) async {
    final existe = await emailExists(email);
    return existe;
  }

  /// Envia um e-mail de redefinição de senha via Firebase Authentication.
  Future<bool> enviarEmailRecuperacao(String email) async {
    isCarregando = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      isCarregando = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Erro ao enviar e-mail de recuperação: $e');
      isCarregando = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Erro inesperado ao enviar e-mail de recuperação: $e');
      isCarregando = false;
      notifyListeners();
      return false;
    }
  }
}
