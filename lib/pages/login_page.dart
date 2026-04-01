import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
	const LoginPage({super.key});

	@override
	State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	// Controladores para pegar o texto que o usuario digitar
	final _emailController = TextEditingController();
	final _passwordController = TextEditingController();

	// Controle para esconder a senha
	bool _hidePassword = true;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return Scaffold(
			body: SafeArea(
				child: Center(
					child: SingleChildScrollView(
						padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 44.0),
						child: Container(
							constraints: const BoxConstraints(maxWidth: 480),
							decoration: BoxDecoration(
								color: theme.scaffoldBackgroundColor == const Color(0xFF12100E)
									? const Color(0xFF1C1917)
									: Colors.white,
								borderRadius: BorderRadius.circular(12),
								border: Border.all(
									color: theme.primaryColor.withValues(alpha: 0.1),
								),
								boxShadow: [
									BoxShadow(
										color: Colors.black.withValues(alpha: 0.1),
										blurRadius: 25,
										offset: const Offset(0, 10),
									),
								]
							),
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									// Header / Area da logo
									Container(
										height: 180,
										width: double.infinity,
										decoration: BoxDecoration(
											color: theme.primaryColor.withValues(alpha: 0.05),
											borderRadius: const BorderRadius.vertical(top: Radius.circular(12))
										),
										child: Center(
											child: CircleAvatar(
												radius: 34,
												backgroundColor: theme.scaffoldBackgroundColor,
												child: Icon(Icons.architecture, size: 36, color: theme.primaryColor,),
											),
										),
									),

									// Area do formulario
									Padding(
										padding: const EdgeInsets.all(24.0),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.stretch,
											children: [
												Text(
													'Acesso ao Sistema',
													textAlign: TextAlign.center,
													style: theme.textTheme.displayLarge?.copyWith(
														fontSize: 28,
														letterSpacing: -0.7
													),
												),
												const SizedBox(height: 8),
												Text(
													'Plataforma de Coleta de Dados Arqueológicos',
													textAlign: TextAlign.center,
													style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
												),
												const SizedBox(height: 32),

												// Input de e-mail
												Text(
													'E-mail',
													style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: theme.primaryColor),
												),
												const SizedBox(height: 6),
												TextFormField(
													controller: _emailController,
													keyboardType: TextInputType.emailAddress,
													decoration: const InputDecoration(
														hintText: 'exemplo@arqueo.org',
														prefixIcon: Icon(Icons.email_outlined),
													),
												),
												const SizedBox(height: 16),

												// Input de senha
												Text(
													'Senha',
													style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: theme.primaryColor),
												),
												const SizedBox(height: 6),
												TextFormField(
													controller: _passwordController,
													obscureText: _hidePassword,
													decoration: InputDecoration(
														hintText: 'Digite sua senha',
														prefixIcon: Icon(Icons.lock_outline),
														suffixIcon: IconButton(
															icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
															onPressed: () {
																setState(() {
																  _hidePassword = !_hidePassword;
																});
															},
														),
													),
												),

												const SizedBox(height: 16),

												// Botao de ENTRAR
												ElevatedButton(
													onPressed: () {
														//TODO
													},
													child: const Text(
														'Entrar',
														style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
													),
												),
												
												const SizedBox(height: 12),

												// Botao de CADASTRO
												OutlinedButton(
													style: OutlinedButton.styleFrom(
														minimumSize: const Size(double.infinity, 54),
														side: BorderSide(color: theme.primaryColor.withValues(alpha: 0.2)),
														shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
													),
													onPressed: () {
														//TODO
													},
													child: Text(
														'Criar Conta',
														style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.primaryColor),
													),
												),

												const SizedBox(height: 16),

												// Link esqueceu a senha
												Align(
													alignment: Alignment.center,
													child: TextButton(
														onPressed: () {
															//TODO
														},
														child: const Text(
															'Esqueceu sua senha?',
															style: TextStyle(
																fontSize: 12,
																decoration: TextDecoration.underline,
																color: Colors.grey
															),
														),
													),
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