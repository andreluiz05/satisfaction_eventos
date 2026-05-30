import 'package:flutter/material.dart';

/// Estilos específicos para a tela de Privacidade e Senha.
class PrivacidadeSenhaTelaEstilo {
  // --- Estilos de Texto e Cabeçalho ---

  static const TextStyle estiloTituloAppBar = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static TextStyle estiloTitulo(ColorScheme colorScheme) => TextStyle(
    color: colorScheme.onSurface,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle estiloSubtitulo(ColorScheme colorScheme) => TextStyle(
    color: colorScheme.onSurfaceVariant,
    height: 1.5,
  );

  // --- Estilos de Input ---

  /// Decoração padrão para os campos de alteração de senha
  static InputDecoration decoracaoCampo(String label, ColorScheme colorScheme, {Widget? suffixIcon}) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: colorScheme.surface,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  );

  // --- Estilos de Botão ---

  static ButtonStyle estiloBotaoSalvar(ColorScheme colorScheme) => ElevatedButton.styleFrom(
    backgroundColor: colorScheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  static const TextStyle textoBotaoSalvar = TextStyle(
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 1.1,
  );
}
