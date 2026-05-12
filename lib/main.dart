import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'backend/controlers/eventos_controlador.dart';
import 'telas/autenticacao/login_tela.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // A sua lógica de inicialização de cache mantida intacta
  await SatisfactionController.instance.initCache();
  
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
          
          // A lógica de alternância de tema
          themeMode: SatisfactionController.instance.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
          // Tema claro personalizado
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
          
          // O tema escuro personalizado
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
          
          // Lógica de tela de carregamento antes do Login
          home: SatisfactionController.instance.isCarregando 
              ? const Scaffold(body: Center(child: CircularProgressIndicator())) 
              : const LoginScreen(),
        );
      }
    );
  }
}