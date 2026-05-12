import 'package:firebase_database/firebase_database.dart';
import '../models/evento_modelo.dart';

class FirebaseServico {
  // Conecta diretamente com o nó "eventos" usando o SDK oficial
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("eventos");

  // SALVAR / ATUALIZAR (Create / Update)
  Future<void> salvarEvento(Evento evento) async {
    // Usamos o .set() apontando para o ID do evento, equivalente ao PUT do HTTP
    await _dbRef.child(evento.id).set(evento.toJson());
  }

  // BUSCAR TODOS (Read)
  // Nota: Se você já está usando o monitorarFirebase() no controlador, 
  // essa função talvez nem seja mais usada, mas mantemos para buscas manuais!
  Future<List<Evento>> lerEventos() async {
    final snapshot = await _dbRef.get();

    if (!snapshot.exists) return [];

    final Map<dynamic, dynamic> dados = snapshot.value as Map<dynamic, dynamic>;
    final List<Evento> lista = [];

    dados.forEach((key, value) {
      final mapa = Map<String, dynamic>.from(value);
      mapa['id'] = key.toString(); // O idFirebase será o seu código
      
      // Garantimos a lista vazia se não houver convidados
      if (mapa['convidados'] == null) {
        mapa['convidados'] = [];
      }
      
      lista.add(Evento.fromJson(mapa));
    });

    return lista;
  }

  // APAGAR (Delete)
  Future<void> deletar(String id) async {
    // Usamos o .remove() para deletar o nó específico
    await _dbRef.child(id).remove();
  }
}