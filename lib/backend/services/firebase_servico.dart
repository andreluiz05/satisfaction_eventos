import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/evento_modelo.dart';

class FirebaseServico {
  // A URL do Firebase (sem a barra no final para evitar erros de formatação)
  static const String _baseUrl = 'https://satisfaction-eventos-default-rtdb.firebaseio.com';

  // SALVAR / ATUALIZAR (Create / Update)
  // Houve a mudança de POST para PUT, forçando o Firebase a usar o código de 6 dígitos de cada evento como chave.
  Future<void> salvarEvento(Evento evento) async {
    final url = Uri.parse('$_baseUrl/eventos/${evento.id}.json');
    await http.put(url, body: jsonEncode(evento.toJson()));
  }

  // BUSCAR TODOS (Read)
  Future<List<Evento>> lerEventos() async {
    final url = Uri.parse('$_baseUrl/eventos.json');
    final response = await http.get(url);

    if (response.body == 'null') return [];

    final Map<String, dynamic> dados = jsonDecode(response.body);
    final List<Evento> lista = [];

    dados.forEach((idFirebase, mapa) {
      // O idFirebase será o seu código de 6 dígitos
      mapa['id'] = idFirebase; 
      
      // Se o evento não tiver convidados, o Firebase retorna null
      // Garantimos que seja uma lista vazia para evitar erros na hora de criar o objeto Evento
      if (mapa['convidados'] == null) {
        mapa['convidados'] = [];
      }
      
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