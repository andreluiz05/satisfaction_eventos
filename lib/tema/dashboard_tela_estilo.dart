import 'package:flutter/material.dart';

/// Estilos específicos para a tela de Dashboard (Lista de Eventos).
class DashboardEstilo {
  // --- Estilos da AppBar ---

  static TextStyle tituloAppBar(ThemeData theme) => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.onSurface,
        letterSpacing: -0.5,
      );

  static TextStyle subtituloAppBar(ThemeData theme) => TextStyle(
        fontSize: 16,
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      );

  // --- Elementos de Interface ---

  /// Estilo para badges de operações (ex: contador de eventos)
  static BoxDecoration badgeOperacoes(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      );

  static TextStyle badgeOperacoesTexto(ThemeData theme) => TextStyle(
        fontWeight: FontWeight.w800,
        color: theme.colorScheme.primary,
        fontSize: 12,
      );

  /// Fundo exibido ao deslizar para deletar um item
  static BoxDecoration fundoDelecao = BoxDecoration(
    color: const Color(0xFFEF4444),
    borderRadius: BorderRadius.circular(24),
  );

  static const TextStyle textoBotaoNovoEvento = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
  );

  // --- Estado Vazio ---

  static BoxDecoration iconeEstadoVazio = BoxDecoration(
    color: Colors.grey.withAlpha(25),
    shape: BoxShape.circle,
  );

  static const TextStyle textoEstadoVazio = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.grey,
  );

  // --- Cards de Evento ---

  /// Decoração principal do card de cada evento
  static BoxDecoration cardEvento(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  /// Container para a imagem dentro do card
  static BoxDecoration imagemCardEvento(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      );

  static TextStyle tituloCardEvento(ThemeData theme) => TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 18,
        color: theme.colorScheme.onSurface,
      );

  static const TextStyle localCardEvento = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w500,
    fontSize: 13,
  );

  static BoxDecoration badgeIdEvento(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      );

  static TextStyle badgeIdEventoTexto(ThemeData theme) => TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 12,
        color: theme.colorScheme.primary,
      );

  // --- Formulários e Diálogos ---

  static const TextStyle textoSwitch = TextStyle(
    fontWeight: FontWeight.w700,
  );

  static const TextStyle textoSliderLabel = TextStyle(
    fontWeight: FontWeight.w600,
  );

  static const TextStyle tituloDialog = TextStyle(
    fontWeight: FontWeight.w900,
  );

  /// Placeholder exibido quando não há imagem selecionada no diálogo
  static BoxDecoration placeholderImagemDialog = BoxDecoration(
    color: Colors.grey.withAlpha(25),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.grey.withAlpha(51),
      width: 2,
    ),
  );

  static const TextStyle textoCarregandoImagem = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textoTrocarFoto = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );

  // --- Estilos de Botão ---

  static ButtonStyle botaoSalvarDialog = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6A1B9A),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static const TextStyle textoBotaoSalvar = TextStyle(
    color: Colors.white,
  );

  static const TextStyle textoBotaoCancelar = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static ButtonStyle botaoExcluirDialog = ElevatedButton.styleFrom(
    backgroundColor: Colors.redAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static const TextStyle textoBotaoExcluir = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // --- Bottom Sheet ---

  /// Alça superior do Bottom Sheet
  static BoxDecoration handleBottomSheet = BoxDecoration(
    color: Colors.grey.withAlpha(76),
    borderRadius: BorderRadius.circular(10),
  );

  static const TextStyle tituloBottomSheet = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 26,
  );

  static BoxDecoration placeholderImagemBottomSheet = BoxDecoration(
    color: Colors.grey.withAlpha(25),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.grey.withAlpha(51),
      width: 2,
    ),
  );

  static ButtonStyle botaoSalvarBottomSheet = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6A1B9A),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  static const TextStyle textoBotaoSalvarBottomSheet = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 16,
  );
}
