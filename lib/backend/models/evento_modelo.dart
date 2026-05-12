import 'convidado_modelo.dart';

class Evento {
  String id, nome, local, data, horario, descricao; // <-- Adicionamos a descrição aqui
  List<Convidado> convidados;
  
  Evento({
    required this.id, 
    required this.nome, 
    required this.local, 
    required this.data, 
    required this.horario, 
    required this.convidados,
    this.descricao = '', // Padrão é vazio caso o usuário não preencha
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'nome': nome, 'local': local, 'data': data, 'horario': horario,
    'descricao': descricao, // <-- Salvando no cache
    'convidados': convidados.map((c) => c.toJson()).toList(),
  };

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'], 
    nome: json['nome'], 
    local: json['local'], 
    data: json['data'], 
    horario: json['horario'],
    descricao: json['descricao'] ?? '', // <-- Lendo do cache (ou vazio se for antigo)
    convidados: (json['convidados'] as List).map((c) => Convidado.fromJson(c)).toList(),
  );
}