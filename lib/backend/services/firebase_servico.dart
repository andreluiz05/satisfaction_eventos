import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/evento_modelo.dart';

class FirebaseServico {
  // Sua URL do Firebase
  static const String _baseUrl = 'https://satisfaction-eventos-default-rtdb.firebaseio.com/';

  // SALVAR (Create)
  Future<void> criarEvento(Evento evento) async {
    final url = Uri.parse('$_baseUrl/eventos.json');
    await http.post(url, body: jsonEncode(evento.toJson()));
  }

  // BUSCAR TODOS (Read)
  Future<List<Evento>> lerEventos() async {
    final url = Uri.parse('$_baseUrl/eventos.json');
    final response = await http.get(url);

    if (response.body == 'null') return [];

    final Map<String, dynamic> dados = jsonDecode(response.body);
    final List<Evento> lista = [];

    dados.forEach((idFirebase, mapa) {
      mapa['id'] = idFirebase; // O ID agora vem do Firebase
      lista.add(Evento.fromJson(mapa));
    });

    return lista;
  }

  // APAGAR (Delete)
  Future<void> deletar(String id) async {
    final url = Uri.parse('$_baseUrl/eventos/$id.json');
    await http.delete(url);
  }
}