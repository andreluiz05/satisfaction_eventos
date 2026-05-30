import 'package:flutter/material.dart';

/// Estilos específicos para a tela de Recuperação de Senha.
class RecuperarSenhaTelaEstilo {
  // --- Cores ---
  static const Color corFundo = Color(0xFF1E293B);
  static const Color corAcento = Color(0xFF00E5FF);
  static const Color corPrimaria = Color(0xFF6A1B9A);

  // --- Estilos de Texto ---
  static const TextStyle textoSnackbar = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textoTituloDialogo = TextStyle(
    fontWeight: FontWeight.w900,
  );

  static const TextStyle textoBotaoDialogo = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textoTitulo = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );

  static const TextStyle textoSubtitulo = TextStyle(
    fontSize: 15,
    color: Colors.white70,
  );

  static const TextStyle estiloTextoInput = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle estiloLabelInput = TextStyle(
    color: Colors.white60,
  );

  static const TextStyle textoBotaoPrincipal = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.5,
  );

  // --- Botões ---
  static ButtonStyle estiloBotaoDialogo = ElevatedButton.styleFrom(
    backgroundColor: corPrimaria,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );

  static ButtonStyle estiloBotaoPrincipal = ElevatedButton.styleFrom(
    backgroundColor: corPrimaria,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 8,
  );
}
