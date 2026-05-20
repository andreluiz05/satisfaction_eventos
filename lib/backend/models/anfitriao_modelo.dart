import 'package:bcrypt/bcrypt.dart';

class AnfitriaoModelo {
	String? id;
	String nome; // <-- ADICIONADO
	String email;
	String passwordHash;
	DateTime? createdAt;

	AnfitriaoModelo({
		this.id,
		required this.nome, // <-- ADICIONADO
		required this.email,
		required this.passwordHash,
		DateTime? createdAt,
	}) : createdAt = createdAt ?? DateTime.now();

	/// Cria um anfitrião a partir de nome, email e senha em texto puro.
	factory AnfitriaoModelo.create({String? id, required String nome, required String email, required String password}) {
		final hash = BCrypt.hashpw(password, BCrypt.gensalt());
		return AnfitriaoModelo(id: id, nome: nome, email: email, passwordHash: hash);
	}

	void setPassword(String password) {
		passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
	}

	bool verifyPassword(String password) {
		try {
			return BCrypt.checkpw(password, passwordHash);
		} catch (_) {
			return false;
		}
	}

	Map<String, dynamic> toJson() => {
				'id': id,
				'nome': nome, // <-- ADICIONADO
				'email': email,
				'passwordHash': passwordHash,
				'createdAt': createdAt?.toIso8601String(),
			};

	factory AnfitriaoModelo.fromJson(Map<String, dynamic> json) => AnfitriaoModelo(
				id: json['id'] as String?,
				nome: json['nome'] as String? ?? 'Organizador', // <-- ADICIONADO
				email: json['email'] as String,
				passwordHash: json['passwordHash'] as String,
				createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
			);
}