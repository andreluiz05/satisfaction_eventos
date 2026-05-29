import 'package:flutter/material.dart'; // Pacote principal do Flutter para criação de interfaces (Material Design)
import 'package:flutter_localizations/flutter_localizations.dart'; // Pacote para traduzir o app para outros idiomas (ex: pt-BR para datas e calendários)
import 'package:firebase_core/firebase_core.dart'; // Núcleo do Firebase, necessário antes de usar qualquer serviço na nuvem
import 'backend/services/firebase_options.dart'; // Arquivo com as chaves de acesso geradas pelo FlutterFire CLI para conectar ao seu banco

import 'backend/controllers/eventos_controlador.dart'; // Controlador que gerencia a lógica e os dados dos eventos
import 'backend/controllers/login_controlador.dart'; // Controlador que gerencia a lógica de autenticação e sessão do usuário
import 'telas/autenticacao/login_tela.dart'; // Tela inicial do aplicativo onde o usuário faz o login

// Função principal que é executada assim que o aplicativo é aberto
void main() async {
  // Garante que o Flutter inicializou os componentes internos antes de rodar código assíncrono (como o Firebase)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase conectando o app ao servidor usando as chaves do firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Verifica na memória do celular se já existe um anfitrião logado da sessão anterior
  await LoginControlador.instance.loadCurrentFromPrefs();
  
  // Inicia a "escuta" do banco de dados em tempo real. Se alguém adicionar um evento, o app atualiza na hora
  SatisfactionController.instance.monitorarFirebase();
  
  // Roda o widget principal do aplicativo (a estrutura base do app)
  runApp(const SatisfactionApp());
}

// Classe principal do aplicativo que define as configurações globais (Tema, Idioma, Tela Inicial)
class SatisfactionApp extends StatelessWidget {
  const SatisfactionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder "escuta" o controlador de eventos. Se o tema for alterado (claro/escuro), ele refaz a tela.
    return ListenableBuilder(
      listenable: SatisfactionController.instance,
      builder: (context, _) {
        // MaterialApp é a "casca" principal do aplicativo, onde as regras globais são definidas
        return MaterialApp(
          debugShowCheckedModeBanner: false, // Remove a faixa de "DEBUG" vermelha no canto superior direito
          
          // Define se o app vai usar o tema claro ou escuro com base no botão clicado no painel
          themeMode: SatisfactionController.instance.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
          // --- CONFIGURAÇÃO DO TEMA CLARO ---
          theme: ThemeData(
            useMaterial3: true, // Usa o design mais moderno do Flutter (Material 3)
            fontFamily: 'Inter', // Define a fonte padrão de todos os textos do aplicativo
            scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Cor de fundo padrão das telas no tema claro
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6A1B9A), // Cor base para gerar as outras tonalidades
              primary: const Color(0xFF6A1B9A), // Cor principal (Roxo)
              secondary: const Color(0xFF00E5FF), // Cor secundária (Ciano)
              surface: Colors.white, // Cor das superfícies (como os cartões dos eventos)
              brightness: Brightness.light // Informa ao Flutter que este é o tema claro
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          
          // --- CONFIGURAÇÃO DO TEMA ESCURO ---
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color(0xFF0F172A), // Cor de fundo escura padrão
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF9C27B0), 
              primary: const Color(0xFF9C27B0), 
              secondary: const Color(0xFF00E5FF), 
              surface: const Color(0xFF1E293B), // Cor das superfícies no modo escuro
              brightness: Brightness.dark // Informa ao Flutter que este é o tema escuro
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E293B),
              surfaceTintColor: Colors.transparent,
            ),
            inputDecorationTheme: InputDecorationTheme(
              fillColor: const Color(0xFF1E293B),
              labelStyle: const TextStyle(color: Color(0xFFCBD5E1)),
              hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          
          // --- CONFIGURAÇÃO DE IDIOMA E LOCALIZAÇÃO ---
          locale: const Locale('pt', 'BR'), // Força o app a abrir em Português do Brasil
          supportedLocales: const [Locale('pt', 'BR')], // Idiomas suportados
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate, // Traduz textos padrão do Android (ex: "OK", "Cancelar", calendários)
            GlobalWidgetsLocalizations.delegate, // Configura a direção do texto da esquerda para a direita
            GlobalCupertinoLocalizations.delegate, // Traduz textos padrão de componentes estilo iOS (iPhone)
          ],
          
          // --- PONTO DE ENTRADA / PRIMEIRA TELA DO APLICATIVO ---
          home: SatisfactionController.instance.isCarregando 
              ? const Scaffold(body: Center(child: CircularProgressIndicator())) // Tela de carregamento (bolinha girando)
              : const LoginScreen(), // Tela inicial de Login
        );
      }
    );
  }
}
