import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // AppBar seguindo o design de "Header / TopAppBar"
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.colorScheme.primary.withValues(
              alpha: 0.1,
            ), // border-bottom: rgba(73, 54, 39, 0.1)
            height: 1.0,
          ),
        ),
        title: Text(
          'Criar Conta',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme
                .textTheme
                .displayLarge
                ?.color, // Texto escuro no modo claro, branco no modo escuro
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // _AppBarArea(theme:theme),
                  _HeaderArea(theme: theme),
                  const _RegisterForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class _AppBarArea extends StatelessWidget {
//   const _AppBarArea({required this.theme});

//   final ThemeData theme;

//   @override
//   Widget build(BuildContext context) {

//     throw UnimplementedError();
//   }
// }

class _HeaderArea extends StatelessWidget {
  const _HeaderArea({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.person_add_alt_1,
              size: 30,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Junte-se à nossa comunidade de exploração arqueológica.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
        ),
      ],
    );
    throw UnimplementedError();
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  // Controladores de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Controles de visibilidade de senha
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  // Variável para armazenar o valor do Dropdown de Classificação
  String? _selectedClassification;
  final List<String> _classifications = [
    'Estudante',
    'Pesquisador',
    'Curador',
    'Visitante',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // --- Form Container ---

          // Nome Completo
          Text(
            'Nome Completo',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Digite seu nome completo',
            ),
          ),
          const SizedBox(height: 16),

          // E-mail
          Text(
            'E-mail',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: theme.colorScheme.primary,
            ),
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

          // Classificação (Dropdown)
          Text(
            'Classificação',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedClassification,
            decoration: const InputDecoration(hintText: 'Selecione seu perfil'),
            items: _classifications.map((String classification) {
              return DropdownMenuItem<String>(
                value: classification,
                child: Text(classification),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedClassification = newValue;
              });
            },
          ),
          const SizedBox(height: 16),

          // Senha
          Text(
            'Senha',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _hidePassword,
            decoration: InputDecoration(
              hintText: 'Crie uma senha',
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confirmar Senha
          Text(
            'Confirmar Senha',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _hideConfirmPassword,
            decoration: InputDecoration(
              hintText: 'Repita a senha',
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _hideConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _hideConfirmPassword = !_hideConfirmPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 32),

          // --- Action Buttons ---
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Criar Conta',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.person_add_alt_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              side: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.canPop() ? context.pop() : context.go('/login');
              ;
            },
            child: Text(
              'Já tenho uma conta, entrar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Footer Info ---
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ao se cadastrar, você concorda com nossos',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('#');
                      }
                    },
                    child: Text(
                      'Termos de Serviço',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.surfaceTint,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    'e',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('#');
                      }
                    },
                    child: Text(
                      'Política de Privacidade',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.surfaceTint,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}
