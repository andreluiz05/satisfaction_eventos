import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
//RESPONSAVEIS PELO ESQUECEU SENHA "EMAILJS"
import 'dart:math'; 
import 'package:http/http.dart' as http;
// ----------------------------------

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

  /// Verifica se já existe um anfitrião com o e-mail informado,
  /// tanto no Firebase quanto na lista local.
  Future<bool> emailExists(String email) async {
    final emailLower = email.toLowerCase();
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
    isCarregando = true;
    notifyListeners();

    try {
      final snapshot = await _dbRef.get();

      if (snapshot.exists) {
        final dados = snapshot.value as Map;
        for (final key in dados.keys) {
          final mapa = Map<String, dynamic>.from(dados[key] as Map);
          if (mapa['email'] == email) {
            isCarregando = false;
            notifyListeners();
            return true; 
          }
        }
      }
    } catch (e) {
      debugPrint("Erro ao verificar email: $e");
    }

    isCarregando = false;
    notifyListeners();
    return false; 
  }

  /// Gera uma senha temporária, atualiza no Firebase (com Bcrypt) e envia via EmailJS
  Future<bool> enviarEmailRecuperacao(String email) async {
    isCarregando = true;
    notifyListeners();

    try {
      final snapshot = await _dbRef.get();
      String? anfitriaoId;
      AnfitriaoModelo? anfitriaoEncontrado;

      if (snapshot.exists) {
        final dados = snapshot.value as Map;
        for (final key in dados.keys) {
          final mapa = Map<String, dynamic>.from(dados[key] as Map);
          if (mapa['email'] == email) {
            anfitriaoId = key.toString();
            mapa['id'] = anfitriaoId;
            anfitriaoEncontrado = AnfitriaoModelo.fromJson(mapa);
            break;
          }
        }
      }

      if (anfitriaoId != null && anfitriaoEncontrado != null) {
        final random = Random();
        final novaSenha = (100000 + random.nextInt(900000)).toString();

        anfitriaoEncontrado.setPassword(novaSenha);
        await _dbRef.child(anfitriaoId).update({
          'passwordHash': anfitriaoEncontrado.passwordHash
        });

        final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'service_id': 'gmailsatisfactionevents',
            'template_id': 'template_a70by6s', //
            'user_id': '-adY6aDjf0UMS5YWN',
            'template_params': {
              'to_email': email,
              'temp_password': novaSenha,
            }
          }),
        );

        isCarregando = false;
        notifyListeners();
        return response.statusCode == 200;
      }
    } catch (e) {
      debugPrint("Erro ao recuperar senha: $e");
    }

    isCarregando = false;
    notifyListeners();
    return false; 
  }
}
