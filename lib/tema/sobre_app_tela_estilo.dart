import 'package:flutter/material.dart';

/// Estilos específicos para a tela "Sobre o App".
class SobreAppTelaEstilo {
  // --- Estilos de Texto ---
  static const TextStyle estiloTituloAppBar = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static TextStyle estiloTituloApp(ColorScheme colorScheme) => TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: colorScheme.primary,
  );

  static const TextStyle estiloVersao = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );

  static TextStyle estiloTituloCardInfo(ColorScheme colorScheme) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: colorScheme.onSurface,
  );

  static TextStyle estiloDescricaoCardInfo(ColorScheme colorScheme) => TextStyle(
    fontSize: 14,
    height: 1.5,
    color: colorScheme.onSurfaceVariant,
  );

  static const TextStyle estiloTextoRodape1 = TextStyle(
    fontSize: 16,
  );

  static const TextStyle estiloTextoRodape2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle estiloCabecalhoDevs = TextStyle(
    letterSpacing: 2,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const TextStyle estiloNomeDev = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle estiloCargoDev = TextStyle(
    fontSize: 13,
    color: Colors.grey,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle estiloCopyright = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  // --- Decorações e Cards ---
  static BoxDecoration decoracaoCardInfo(ColorScheme colorScheme) => BoxDecoration(
    color: colorScheme.surface,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(10),
        blurRadius: 15,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration decoracaoCardDev = BoxDecoration(
    color: Colors.grey.withAlpha(20),
    borderRadius: BorderRadius.circular(15),
  );
}
