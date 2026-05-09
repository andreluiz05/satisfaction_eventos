class Convidado {
  String id, nome, email;
  bool presenca;
  
  Convidado({required this.id, required this.nome, required this.email, this.presenca = false});

  String get iniciais => nome.trim().split(RegExp(' +')).map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase();

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'email': email, 'presenca': presenca};
  
  factory Convidado.fromJson(Map<String, dynamic> json) => Convidado(
    id: json['id'], nome: json['nome'], email: json['email'], presenca: json['presenca'] ?? false,
  );
}