import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../navegacao/navegacao_principal_tela.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnfitriao = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF3B0B59), Color(0xFF003D4C)], begin: Alignment.topRight, end: Alignment.bottomLeft))),
          Positioned(top: -100, right: -50, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF9C27B0).withAlpha(51), boxShadow: [BoxShadow(color: const Color(0xFF9C27B0).withAlpha(51), blurRadius: 100)]))),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(color: Colors.white.withAlpha(25), borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.white.withAlpha(51), width: 1.5)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/imagens/logo_marca.png',
                          height: 240,
                          width: 400,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                    
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.black.withAlpha(76), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              _loginTab("Anfitrião", isAnfitriao, () { HapticFeedback.selectionClick(); setState(() => isAnfitriao = true); }),
                              _loginTab("Convidado", !isAnfitriao, () { HapticFeedback.selectionClick(); setState(() => isAnfitriao = false); }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        _inputField(isAnfitriao ? 'E-mail do Organizador' : 'Código do Evento', Icons.alternate_email),
                        const SizedBox(height: 16),
                        
                        if (isAnfitriao) ...[
                          _inputField('Senha', Icons.lock_outline, obscure: true),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Instruções enviadas para o e-mail!')));
                                },
                                child: const Text('Esqueceu a senha?', style: TextStyle(color: Colors.white70, fontSize: 13)),
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tela de cadastro em desenvolvimento.')));
                                },
                                child: const Text('Criar conta', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          const SizedBox(height: 40),
                        ],
                        
                        SizedBox(
                          width: double.infinity, height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: const Color(0xFF003D4C), elevation: 10, shadowColor: const Color(0xFF00E5FF).withAlpha(128), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              // Empurra a tela principal substituindo o login
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
                            },
                            child: const Text('ENTRAR', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginTab(String t, bool active, VoidCallback fn) => Expanded(child: InkWell(onTap: fn, borderRadius: BorderRadius.circular(16), child: AnimatedContainer(duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart, padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: active ? const Color(0xFF6A1B9A) : Colors.transparent, borderRadius: BorderRadius.circular(16)), child: Text(t, textAlign: TextAlign.center, style: TextStyle(color: active ? Colors.white : Colors.white54, fontWeight: active ? FontWeight.bold : FontWeight.normal, fontSize: 15)))));

  Widget _inputField(String l, IconData i, {bool obscure = false}) => TextField(obscureText: obscure, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500), decoration: InputDecoration(prefixIcon: Icon(i, color: Colors.white70), labelText: l, labelStyle: const TextStyle(color: Colors.white60), filled: true, fillColor: Colors.black.withAlpha(51), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5))));
}