enum PresencaStatus { none, accepted, refused }

class Convidado {
  String id, nome, email;
  PresencaStatus status;
  
  Convidado({
    required this.id, 
    required this.nome, 
    required this.email, 
    this.status = PresencaStatus.none
  });

  String get iniciais => nome.trim().split(RegExp(' +')).map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase();

  // SEU CÓDIGO ORIGINAL: Lógica de transição de status
  PresencaStatus get nextStatus {
    switch (status) {
      case PresencaStatus.none:
        return PresencaStatus.accepted;
      case PresencaStatus.accepted:
        return PresencaStatus.refused;
      case PresencaStatus.refused:
        return PresencaStatus.none;
    }
  }

  // SEU CÓDIGO ORIGINAL: Labels amigáveis para a tela de detalhes
  String get statusLabel {
    switch (status) {
      case PresencaStatus.accepted:
        return 'ACEITO';
      case PresencaStatus.refused:
        return 'RECUSADO';
      case PresencaStatus.none:
        return 'SEM RESPOSTA';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'email': email,
    'status': status.name,
  };
  
  factory Convidado.fromJson(Map<String, dynamic> json) => Convidado(
    id: json['id'],
    nome: json['nome'],
    email: json['email'],
    status: _parseStatus(json) ?? PresencaStatus.none,
  );

  static PresencaStatus? _parseStatus(Map<String, dynamic> json) {
    final statusValue = json['status'];
    if (statusValue is String && statusValue.isNotEmpty) {
      return PresencaStatus.values.firstWhere(
        (value) => value.name == statusValue,
        orElse: () => PresencaStatus.none,
      );
    }
    // Fallback de segurança para o boolean do seu colega
    final presencaValue = json['presenca'];
    if (presencaValue is bool) {
      return presencaValue ? PresencaStatus.accepted : PresencaStatus.refused;
    }
    return PresencaStatus.none;
  }
}