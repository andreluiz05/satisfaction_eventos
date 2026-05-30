import 'package:flutter/material.dart';

/// Estilos específicos para a tela de "Suporte e Ajuda".
class SuporteAjudaTelaEstilo {
  // --- Estilos de Texto ---
  static const TextStyle estiloTituloAppBar = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static const TextStyle estiloPerguntaCabecalho = TextStyle(
    fontSize: 24, 
    fontWeight: FontWeight.w900,
  );

  static TextStyle estiloCabecalhoSessao(Color? color) => TextStyle(
    letterSpacing: 1.5, 
    fontWeight: FontWeight.bold, 
    color: color ?? Colors.grey[600],
  );

  static TextStyle estiloPerguntaFaq(ColorScheme colorScheme) => TextStyle(
    fontWeight: FontWeight.w700, 
    fontSize: 15, 
    color: colorScheme.onSurface,
  );

  static TextStyle estiloRespostaFaq(ColorScheme colorScheme) => TextStyle(
    color: colorScheme.onSurfaceVariant, 
    height: 1.5,
  );

  static TextStyle estiloTituloSessaoContato(ColorScheme colorScheme) => TextStyle(
    letterSpacing: 0.5, 
    fontWeight: FontWeight.bold, 
    color: colorScheme.primary, 
    fontSize: 18,
  );

  static TextStyle estiloSubtituloSessaoContato(Color? color) => TextStyle(
    color: color ?? Colors.grey[600], 
    fontSize: 14,
  );

  static const TextStyle estiloTituloContato = TextStyle(
    fontWeight: FontWeight.bold, 
    fontSize: 16,
  );

  static const TextStyle estiloSubtituloContato = TextStyle(
    color: Colors.grey, 
    fontSize: 14,
  );

  static TextStyle estiloTextoBotaoContato(ColorScheme colorScheme) => TextStyle(
    color: colorScheme.primary, 
    fontWeight: FontWeight.bold,
  );

  // --- Decorações e Cards ---
  static BoxDecoration decoracaoCardFaq(ColorScheme colorScheme) => BoxDecoration(
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

  static BoxDecoration decoracaoCardContato(ColorScheme colorScheme) => BoxDecoration(
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

  static BoxDecoration decoracaoIconeContato(ColorScheme colorScheme) => BoxDecoration(
    color: colorScheme.primary.withAlpha(25),
    borderRadius: BorderRadius.circular(12),
  );
}
