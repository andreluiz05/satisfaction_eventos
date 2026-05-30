import 'package:flutter/material.dart';

/// Estilos específicos para a tela de Perfil do usuário.
class PerfilTelaEstilo {
  // --- Estilos da AppBar ---

  static TextStyle estiloTituloAppBar(ColorScheme colorScheme) => TextStyle(
    color: colorScheme.onSurface,
    fontWeight: FontWeight.w900,
    fontSize: 24,
  );

  // --- Estilos do Cabeçalho de Perfil ---

  /// Decoração para a imagem de avatar do perfil
  static BoxDecoration decoracaoAvatar(ColorScheme colorScheme) => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: colorScheme.primary,
      width: 2,
    ),
  );

  static TextStyle estiloNome(ColorScheme colorScheme) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: colorScheme.onSurface,
  );

  static const TextStyle estiloEmail = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );

  // --- Estilos de Menu ---

  /// Decoração para cada item de menu no perfil
  static BoxDecoration decoracaoItemMenu(ColorScheme colorScheme) => BoxDecoration(
    color: colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(10),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  /// Container para o ícone lateral de cada item de menu
  static BoxDecoration decoracaoIconeMenu(ColorScheme colorScheme) => BoxDecoration(
    color: colorScheme.primary.withAlpha(25),
    borderRadius: BorderRadius.circular(10),
  );

  static TextStyle estiloTituloMenu(ColorScheme colorScheme) => TextStyle(
    fontWeight: FontWeight.w700,
    color: colorScheme.onSurface,
  );

  // --- Estilos de Botão ---

  static const Color corErro = Color(0xFFF44336);

  /// Estilo do botão de Logout (Sair)
  static ButtonStyle estiloBotaoSair() => ElevatedButton.styleFrom(
    backgroundColor: corErro.withAlpha(25),
    foregroundColor: corErro,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  static const TextStyle textoBotaoSair = TextStyle(
    fontWeight: FontWeight.w900,
    letterSpacing: 1,
  );
}
