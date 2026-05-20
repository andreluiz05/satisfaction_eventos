import 'package:bcrypt/bcrypt.dart';

class AnfitriaoModelo {
	String? id;
	String email;
	String passwordHash;
	DateTime? createdAt;

	AnfitriaoModelo({
		this.id,
		required this.email,
		required this.passwordHash,
		DateTime? createdAt,
	}) : createdAt = createdAt ?? DateTime.now();

	/// Cria um anfitrião a partir de email e senha em texto puro.
	factory AnfitriaoModelo.create({String? id, required String email, required String password}) {
		final hash = BCrypt.hashpw(password, BCrypt.gensalt());
		return AnfitriaoModelo(id: id, email: email, passwordHash: hash);
	}

	/// Define a senha (gera novo hash usando bcrypt).
	void setPassword(String password) {
		passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
	}

	/// Verifica se a senha em texto puro confere com o hash armazenado.
	bool verifyPassword(String password) {
		try {
			return BCrypt.checkpw(password, passwordHash);
		} catch (_) {
			return false;
		}
	}

	Map<String, dynamic> toJson() => {
				'id': id,
				'email': email,
				'passwordHash': passwordHash,
				'createdAt': createdAt?.toIso8601String(),
			};

	factory AnfitriaoModelo.fromJson(Map<String, dynamic> json) => AnfitriaoModelo(
				id: json['id'] as String?,
				email: json['email'] as String,
				passwordHash: json['passwordHash'] as String,
				createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
			);
}

