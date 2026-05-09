import 'package:flutter/material.dart';
import 'backend/controlers/eventos_controlador.dart';
import 'telas/autenticacao/login_tela.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          themeMode: SatisfactionController.instance.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: Colors.purple),
          home: const LoginScreen(),
        );
      },
    );
  }
}
