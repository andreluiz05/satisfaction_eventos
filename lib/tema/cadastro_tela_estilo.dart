import 'package:flutter/material.dart';

/// Estilos específicos para a tela de Cadastro.
class CadastroTelaEstilo {
  // --- Cores e Gradientes ---
  static const Color corPrimaria = Color(0xFF3B0B59);
  static const Color corSecundaria = Color(0xFF003D4C);
  static const Color corAcento = Color(0xFF00E5FF);
  static const Color corDecorativa = Color(0xFF9C27B0); // Adicionado para evitar erro

  /// Gradiente de fundo principal da tela
  static const LinearGradient gradienteFundo = LinearGradient(
    colors: [corPrimaria, corSecundaria],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // --- Decorações ---

  /// Decoração para os círculos decorativos ao fundo
  static BoxDecoration decoracaoCirculoFundo(Color cor) => BoxDecoration(
    shape: BoxShape.circle,
    color: cor.withAlpha(51),
    boxShadow: [
      BoxShadow(
        color: cor.withAlpha(51),
        blurRadius: 100,
      ),
    ],
  );

  /// Efeito de glassmorphism para os containers
  static BoxDecoration decoracaoGlassmorphism = BoxDecoration(
    color: Colors.white.withAlpha(25),
    borderRadius: BorderRadius.circular(40),
    border: Border.all(
      color: Colors.white.withAlpha(51),
      width: 1.5,
    ),
  );

  // --- Estilos de Texto ---

  static const TextStyle textoTitulo = TextStyle(
    color: Colors.white, 
    fontSize: 28, 
    fontWeight: FontWeight.w900, 
    letterSpacing: 1
  );

  static const TextStyle textoSubtitulo = TextStyle(
    color: Colors.white70, 
    fontSize: 14
  );

  static const TextStyle textoSnackbar = TextStyle(
    fontWeight: FontWeight.bold, 
    color: Colors.white
  );

  static const TextStyle textoBotaoPrincipal = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 16,
    letterSpacing: 1.5,
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
}
