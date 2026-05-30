import 'package:flutter/material.dart';

/// Estilos específicos para a tela de Login.
class LoginTelaEstilo {
  // --- Cores e Gradientes ---
  static const Color corPrimaria = Color(0xFF3B0B59);
  static const Color corSecundaria = Color(0xFF003D4C);
  static const Color corAcento = Color(0xFF00E5FF);
  static const Color corDecorativa = Color(0xFF9C27B0);

  /// Gradiente de fundo principal da tela de login
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

  /// Efeito de glassmorphism para o container principal
  static BoxDecoration decoracaoGlassmorphism = BoxDecoration(
    color: Colors.white.withAlpha(25),
    borderRadius: BorderRadius.circular(40),
    border: Border.all(
      color: Colors.white.withAlpha(51),
      width: 1.5,
    ),
  );

  /// Fundo da barra de abas (Tabs)
  static BoxDecoration decoracaoTabs = BoxDecoration(
    color: Colors.black.withAlpha(76),
    borderRadius: BorderRadius.circular(20),
  );

  /// Indicador da aba ativa
  static BoxDecoration decoracaoTabAtiva = BoxDecoration(
    color: const Color(0xFF6A1B9A),
    borderRadius: BorderRadius.circular(16),
  );

  // --- Estilos de Texto ---

  static const TextStyle textoSnackbar = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle textoLinkSimples = TextStyle(
    color: Colors.white70,
    fontSize: 13,
  );

  static const TextStyle textoLinkDestaque = TextStyle(
    color: corAcento,
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );

  static const TextStyle textoBotaoPrincipal = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 16,
    letterSpacing: 1.5,
  );

  /// Estilo dinâmico para o texto da aba baseado no estado ativo/inativo
  static TextStyle estiloTextoTab(bool active) => TextStyle(
    color: active ? Colors.white : Colors.white54,
    fontWeight: active ? FontWeight.bold : FontWeight.normal,
    fontSize: 15,
  );

  static const TextStyle estiloTextoInput = TextStyle(
    color: Colors.white, 
    fontWeight: FontWeight.w500
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
