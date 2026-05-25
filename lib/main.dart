import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'backend/services/firebase_options.dart'; // Arquivo gerado pelo FlutterFire CLI

import 'backend/controllers/eventos_controlador.dart';
import 'backend/controllers/login_controlador.dart';
import 'telas/autenticacao/login_tela.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase passando as chaves automáticas para Web e Android
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Carrega sessão de anfitrião (se houver) antes de iniciar a escuta do Firebase
  await LoginControlador.instance.loadCurrentFromPrefs();
  // Inicia a escuta do banco de dados em tempo real
  SatisfactionController.instance.monitorarFirebase();
  
  runApp(const SatisfactionApp());
}

class SatisfactionApp extends StatelessWidget {
  const SatisfactionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SatisfactionController.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          
          themeMode: SatisfactionController.instance.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6A1B9A), 
              primary: const Color(0xFF6A1B9A), 
              secondary: const Color(0xFF00E5FF), 
              surface: Colors.white, 
              brightness: Brightness.light
            ),
          ),
          
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF9C27B0), 
              primary: const Color(0xFF9C27B0), 
              secondary: const Color(0xFF00E5FF), 
              surface: const Color(0xFF1E293B), 
              brightness: Brightness.dark
            ),
          ),
          locale: const Locale('pt', 'BR'),
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SatisfactionController.instance.isCarregando 
              ? const Scaffold(body: Center(child: CircularProgressIndicator())) 
              : const LoginScreen(),
        );
      }
    );
  }
}