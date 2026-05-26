import 'convidado_modelo.dart';

class Evento {
  String id, nome, local, data, horario, descricao;
  List<Convidado> convidados;
  String? anfitriaoId;
  String? imagemFundoUrl;
  String? imagemFundoDeleteUrl;
  bool imagemFundoMostrarInteira;
  double imagemFundoAlinhamentoY;

  Evento({
    required this.id,
    required this.nome,
    required this.local,
    required this.data,
    required this.horario,
    required this.convidados,
    this.descricao = '',
    this.anfitriaoId,
    this.imagemFundoUrl,
    this.imagemFundoDeleteUrl,
    this.imagemFundoMostrarInteira = false,
    this.imagemFundoAlinhamentoY = -1,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'local': local,
    'data': data,
    'horario': horario,
    'descricao': descricao,
    'convidados': convidados.map((c) => c.toJson()).toList(),
    'anfitriaoId': anfitriaoId,
    'imagemFundoUrl': imagemFundoUrl,
    'imagemFundoDeleteUrl': imagemFundoDeleteUrl,
    'imagemFundoMostrarInteira': imagemFundoMostrarInteira,
    'imagemFundoAlinhamentoY': imagemFundoAlinhamentoY,
  };

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'],
    nome: json['nome'],
    local: json['local'],
    data: json['data'],
    horario: json['horario'],
    descricao: json['descricao'] ?? '',
    anfitriaoId: json['anfitriaoId'] as String?,
    imagemFundoUrl:
        (json['imagemFundoUrl'] as String?) ??
        (json['imagemFundoLocal'] as String?),
    imagemFundoDeleteUrl: json['imagemFundoDeleteUrl'] as String?,
    imagemFundoMostrarInteira: json['imagemFundoMostrarInteira'] as bool? ?? false,
    imagemFundoAlinhamentoY:
        (json['imagemFundoAlinhamentoY'] as num?)?.toDouble() ?? -1,
    convidados: json['convidados'] != null
        ? (json['convidados'] as List)
              .map((c) => Convidado.fromJson(Map<String, dynamic>.from(c as Map)))
              .toList()
        : [],
  );
}
