import 'package:flutter/material.dart';

/// Estilos específicos para a tela de Edição de Dados do perfil.
class EditarDadosEstilo {
  // --- Cores ---
  static const Color corPerigo = Color(0xFFEF4444);
  static const Color corErro = Color(0xFFF44336);

  // --- Estilos de Input ---

  /// Decoração padrão para os campos de texto na tela de edição
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

  // --- Estilos de Diálogo (Exclusão de Conta) ---

  static RoundedRectangleBorder formaDialogo = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  );

  static const TextStyle textoTituloDialogo = TextStyle(
    fontWeight: FontWeight.w900,
    color: corPerigo,
  );

  static TextStyle textoConteudoDialogo(ColorScheme colorScheme) => TextStyle(
    height: 1.5,
    color: colorScheme.onSurfaceVariant,
  );

  static TextStyle textoDestaqueDialogo(ColorScheme colorScheme) => TextStyle(
    fontWeight: FontWeight.bold,
    color: colorScheme.onSurface,
  );

  /// Container para a frase de confirmação de exclusão
  static BoxDecoration decoracaoFraseConfirmacao() => BoxDecoration(
    color: corErro.withAlpha(25),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: corErro.withAlpha(100)),
  );

  static const TextStyle textoFraseConfirmacao = TextStyle(
    fontWeight: FontWeight.w900,
    color: corPerigo,
    letterSpacing: 0.5,
  );

  /// Estilização do input para digitar a frase de confirmação
  static InputDecoration decoracaoInputFrase(ColorScheme colorScheme) => InputDecoration(
    hintText: 'Digite a frase aqui...',
    filled: true,
    fillColor: colorScheme.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.withAlpha(100)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: corPerigo, width: 2),
    ),
  );

  // --- Estilos de Botão ---

  static ButtonStyle estiloBotaoExcluir() => ElevatedButton.styleFrom(
    backgroundColor: corErro,
    disabledBackgroundColor: corErro.withAlpha(100),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static const TextStyle textoBotaoExcluir = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // --- Outros Elementos ---

  static BoxDecoration decoracaoIconePerfil(ColorScheme colorScheme) => BoxDecoration(
    color: colorScheme.primary.withAlpha(25),
    borderRadius: BorderRadius.circular(18),
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

  static ButtonStyle estiloBotaoSalvar(ColorScheme colorScheme) => ElevatedButton.styleFrom(
    backgroundColor: colorScheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  static const TextStyle textoBotaoSalvar = TextStyle(
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 1,
  );

  static ButtonStyle estiloBotaoLink(ColorScheme colorScheme) => TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    foregroundColor: colorScheme.primary,
  );
  
  static TextStyle estiloTextoLink(ColorScheme colorScheme) => TextStyle(
    color: colorScheme.primary,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle textoBotaoExcluirLink = TextStyle(
    color: corPerigo,
    fontWeight: FontWeight.bold,
  );

  static ButtonStyle estiloBotaoExcluirLink = TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}
