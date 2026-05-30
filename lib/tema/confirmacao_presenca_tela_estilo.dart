import 'package:flutter/material.dart';

/// Estilos específicos para a tela de Confirmação de Presença.
class ConfirmacaoPresencaEstilo {
  // --- Cores ---
  static const Color corPrimaria = Color(0xFF3B0B59);
  static const Color corSecundaria = Color(0xFF003D4C);
  static const Color corAcento = Color(0xFF00E5FF);
  static const Color corDecorativa = Color(0xFF9C27B0);
  static const Color corSucesso = Color(0xFF4CAF50);
  static const Color corErro = Color(0xFFF44336);

  // --- Gradientes ---
  
  /// Gradiente de fundo com transparência para sobreposição
  static LinearGradient gradienteFundoTransparente = LinearGradient(
    colors: [
      corPrimaria.withAlpha(180),
      corSecundaria.withAlpha(220),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // --- Estilos de Botão ---
  
  static ButtonStyle estiloBotaoElevado = ElevatedButton.styleFrom(
    backgroundColor: corAcento,
    foregroundColor: corSecundaria,
    elevation: 10,
    shadowColor: corAcento.withAlpha(128),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  static const TextStyle textoBotaoPrincipal = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 16,
    letterSpacing: 1.5,
  );

  // --- Estilos Específicos da Tela ---
  
  /// Overlay escurecido para fundo de diálogos
  static BoxDecoration fundoOverlayBlur = BoxDecoration(
    color: Colors.black.withAlpha(120),
  );

  static const TextStyle textoDialog = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static ButtonStyle botaoDialog = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6A1B9A),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );

  static const TextStyle textoBotaoDialog = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle nomeEvento = TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle dataHoraEvento = TextStyle(
    color: Colors.white70,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle localEvento = TextStyle(
    color: Colors.white54,
    fontSize: 14,
  );

  /// Container estilizado para a descrição do evento
  static BoxDecoration containerDescricao = BoxDecoration(
    color: Colors.black.withAlpha(51),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withAlpha(25)),
  );

  static const TextStyle textoDescricao = TextStyle(
    color: Colors.white70,
    fontSize: 14,
    height: 1.5,
  );

  static const TextStyle tituloBusca = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textoCampoInput = TextStyle(
    color: Colors.white,
  );

  static const TextStyle textoCampoHint = TextStyle(
    color: Colors.white54,
  );

  /// Container com efeito de glassmorphism para o campo de busca
  static BoxDecoration containerBusca = BoxDecoration(
    color: Colors.white.withAlpha(25),
    borderRadius: BorderRadius.circular(32),
    border: Border.all(
      color: Colors.white.withAlpha(51),
      width: 1.5,
    ),
  );

  /// Estilização para mensagens de erro
  static BoxDecoration containerErro = BoxDecoration(
    color: corErro.withAlpha(51),
    borderRadius: BorderRadius.circular(16),
  );

  static const TextStyle textoErro = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  /// Estilização para o card de sucesso na confirmação
  static BoxDecoration containerSucesso = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(32),
  );

  static const TextStyle textoIniciais = TextStyle(
    color: corDecorativa,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static const TextStyle textoSaudacao = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: corPrimaria,
  );

  static const TextStyle textoPerguntaPresenca = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  // --- Botões de Ação ---

  static ButtonStyle botaoNaoIrei = OutlinedButton.styleFrom(
    foregroundColor: corErro,
    side: const BorderSide(color: corErro),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );

  static const TextStyle textoBotaoNaoIrei = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static ButtonStyle botaoConfirmar = ElevatedButton.styleFrom(
    backgroundColor: corSucesso,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );

  static const TextStyle textoBotaoConfirmar = TextStyle(
    fontWeight: FontWeight.bold,
  );
}
