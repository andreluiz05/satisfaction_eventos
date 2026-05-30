import 'package:flutter/material.dart';
import '../../backend/models/convidado_modelo.dart';

/// Estilos específicos para a tela de Detalhes do Evento.
class DetalhesEventoEstilo {
  // --- Cores ---
  static const Color corPrimaria = Color(0xFF3B0B59);
  static const Color corSecundaria = Color(0xFF003D4C);

  // --- Gradientes ---
  
  /// Gradiente de fundo com transparência para a AppBar
  static LinearGradient gradienteFundoTransparente = LinearGradient(
    colors: [
      corPrimaria.withAlpha(180),
      corSecundaria.withAlpha(220),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // --- Estilos da AppBar e Cabeçalho ---

  static const TextStyle textoSemAnfitriao = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle nomeEventoAppBar = TextStyle(
    fontWeight: FontWeight.w900,
    color: Colors.white,
    fontSize: 20,
  );

  static const TextStyle infoEventoAppBar = TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.w600,
  );

  // --- Cards de Informação ---

  /// Estilo do card de descrição do evento
  static BoxDecoration cardDescricao(ThemeData theme) => BoxDecoration(
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

  static TextStyle tituloCardDescricao(ThemeData theme) => TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 16,
        color: theme.colorScheme.onSurface,
      );

  static TextStyle textoCardDescricao(ThemeData theme) => TextStyle(
        fontSize: 14,
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.5,
      );

  /// Estilo do card que exibe a taxa de resposta (RSVP)
  static BoxDecoration cardTaxaResposta(ThemeData theme) => BoxDecoration(
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

  static TextStyle tituloCardTaxaResposta(ThemeData theme) => TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 18,
        color: theme.colorScheme.onSurface,
      );

  static BoxDecoration badgePercentualResposta = BoxDecoration(
    color: const Color(0xFF00E5FF).withAlpha(51),
    borderRadius: BorderRadius.circular(20),
  );

  static const TextStyle textoPercentualResposta = TextStyle(
    fontWeight: FontWeight.w900,
    color: Color(0xFF00838F),
  );

  static TextStyle textoContagemResposta = TextStyle(
    fontSize: 12,
    color: Colors.grey[600],
    fontWeight: FontWeight.w600,
  );

  // --- Barra de Progresso ---

  static BoxDecoration containerLinearProgress = BoxDecoration(
    color: Colors.grey.withAlpha(25),
  );

  static BoxDecoration linearProgressDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  );

  // --- Lista de Convidados ---

  static TextStyle textoNenhumConvidado = TextStyle(
    color: Colors.grey.withAlpha(204),
    fontWeight: FontWeight.w600,
  );

  static BoxDecoration containerConvidado(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      );

  static const TextStyle iniciaisConvidado = TextStyle(
    fontWeight: FontWeight.bold,
  );

  /// Estilo dinâmico para o nome do convidado baseado no status
  static TextStyle nomeConvidado(Convidado c) => TextStyle(
        fontWeight: FontWeight.w800,
        color: c.status == PresencaStatus.accepted
            ? Colors.green
            : c.status == PresencaStatus.refused
                ? Colors.red
                : Colors.grey,
      );

  static const TextStyle emailConvidado = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  /// Estilo dinâmico para o status do convidado
  static TextStyle statusConvidado(Convidado c) => TextStyle(
        fontSize: 12,
        color: c.status == PresencaStatus.accepted
            ? Colors.green
            : c.status == PresencaStatus.refused
                ? Colors.red
                : Colors.grey,
        fontWeight: FontWeight.w700,
      );

  // --- Diálogos e Modais ---

  static const TextStyle tituloDialogConfirmacao = TextStyle(
    fontWeight: FontWeight.w900,
  );

  static const TextStyle textoBotaoCancelar = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static ButtonStyle botaoExcluir = ElevatedButton.styleFrom(
    backgroundColor: Colors.redAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static const TextStyle textoBotaoExcluir = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle tituloDialogConvidado = TextStyle(
    fontWeight: FontWeight.w900,
  );

  /// Container para exibir o código do evento
  static BoxDecoration containerCodigoEvento = BoxDecoration(
    color: Colors.grey.withAlpha(25),
    borderRadius: BorderRadius.circular(12),
  );

  static const TextStyle labelCodigoEvento = TextStyle(
    fontWeight: FontWeight.w600,
  );

  static const TextStyle valorCodigoEvento = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 16,
  );

  static ButtonStyle botaoSalvarDialog = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6A1B9A),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static const TextStyle textoBotaoSalvar = TextStyle(
    color: Colors.white,
  );

  /// Overlay escurecido para fundo de diálogos
  static BoxDecoration fundoOverlayBlur = BoxDecoration(
    color: Colors.black.withAlpha(120),
  );

  static const TextStyle tituloDialogEdicao = TextStyle(
    fontWeight: FontWeight.w900,
  );

  /// Placeholder de imagem no diálogo de edição
  static BoxDecoration containerImagemEdicao = BoxDecoration(
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

  static const TextStyle textoAdicionarFoto = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle textoSwitch = TextStyle(
    fontWeight: FontWeight.w700,
  );

  static const TextStyle textoSliderLabel = TextStyle(
    fontWeight: FontWeight.w600,
  );
}
