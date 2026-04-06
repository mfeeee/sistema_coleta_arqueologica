import 'package:flutter/material.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  // Controladores de texto
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.primaryColor),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          
                        ),
                        child: Center(
                          child: Icon(
                            Icons.architecture,
                            size: 50,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Recuperar Senha',
                        textAlign: TextAlign.justify,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 30,
                          letterSpacing: -0.7
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Insira o e-mail cadastrado para receber as instruções de recuperação.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- Form Container ---
                  
                  // E-mail
                  Text(
                    'E-mail',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.primaryColor),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'exemplo@instituicao.br',
                    ),
                  ),
                  const SizedBox(height: 16),


                  // --- Action Buttons ---
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Lógica envio do link de recuperação
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Text(
                          'Enviar Link',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // --- Footer Info ---
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                      children: [
                        const TextSpan(text: 'Lembrou sua senha? '),
                        TextSpan(
                          text: 'Fazer login',
                          style: TextStyle(color: theme.primaryColor, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}